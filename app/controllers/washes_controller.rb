class WashesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_wash, only: %i[show edit update destroy]

  # Office: read · Store: manage (they own it) · Cutting: read.
  before_action :authorize_wash_read!, only: %i[index show print_washsheet_pdf]
  before_action :authorize_wash_manage!, only: %i[new create edit update destroy]

  # GET /washes
  def index
    @washes = Wash.all
  end

  # GET /washes/:id
  def show
    @picksheetitems = PicksheetItem.where(
      picksheet_id: @wash.picksheet_ids
    )

    @picksheetitems = washable_picksheet_items(@picksheetitems)
    @picksheetitems_by_product = @picksheetitems.group_by(&:product)
  end

  # GET /washes/new
  def new
    @wash = Wash.new
    set_available_picksheets_for_new
  end

  # GET /washes/:id/edit
  def edit
    set_available_picksheets_for_edit
  end

  # POST /washes
  def create
    @wash = Wash.new(wash_params)

    respond_to do |format|
      if @wash.save
        format.html do
          redirect_to wash_url(@wash),
                      notice: "Wash was successfully created."
        end

        format.json do
          render :show,
                 status: :created,
                 location: @wash
        end
      else
        set_available_picksheets_for_new

        format.html do
          render :new,
                 status: :unprocessable_entity
        end

        format.json do
          render json: @wash.errors,
                 status: :unprocessable_entity
        end
      end
    end
  end

  # PATCH/PUT /washes/:id
  def update
    respond_to do |format|
      if @wash.update(wash_params)
        format.html do
          redirect_to wash_url(@wash),
                      notice: "Wash was successfully updated."
        end

        format.json do
          render :show,
                 status: :ok,
                 location: @wash
        end
      else
        set_available_picksheets_for_edit

        format.html do
          render :edit,
                 status: :unprocessable_entity
        end

        format.json do
          render json: @wash.errors,
                 status: :unprocessable_entity
        end
      end
    end
  end

  # DELETE /washes/:id
  def destroy
    @wash.destroy

    respond_to do |format|
      format.html do
        redirect_to washes_url,
                    notice: "Wash was successfully destroyed."
      end

      format.json { head :no_content }
    end
  end

  def print_washsheet_pdf
    raleway_font_path =
      Rails.root.join("app/assets/fonts/raleway/Raleway-Medium.ttf")

    raleway_bold_font_path =
      Rails.root.join("app/assets/fonts/raleway/Raleway-Bold.ttf")

    logo_img_path =
      Rails.root.join("app/assets/images/poacher_logo.jpeg")

    pdf = Prawn::Document.new

    pdf.font_families.update(
      "raleway" => {
        normal: raleway_font_path.to_s,
        bold: raleway_bold_font_path.to_s
      }
    )

    pdf.font "raleway"

    @washsheet = Wash.find(params[:id])

    @picksheetitems = PicksheetItem.where(
      picksheet_id: @washsheet.picksheet_ids
    )

    @picksheetitems = washable_picksheet_items(@picksheetitems)
    @picksheetitems_by_product = @picksheetitems.group_by(&:product)

    pdf.text(
      "Wash Sheet for #{@washsheet.action_date.strftime('%b %d, %Y')}",
      size: 14,
      style: :bold,
      align: :left
    )

    pdf.text(
      "Print Date: #{Date.current.strftime('%b %d, %Y')}",
      size: 6,
      align: :left
    )

    pdf.move_down 8

    washsheet_header_table_data = [
      ["Action Date:", "Status:", "Approved By:"],
      [
        @washsheet.action_date.strftime("%b %d, %Y"),
        @washsheet.wash_status,
        "User Name"
      ]
    ]

    pdf.table(washsheet_header_table_data) do
      self.width = 300
      self.cell_style = {
        inline_format: true,
        size: 10
      }

      columns(0..2).width = 100
      columns(0..2).align = :center
      rows(0).background_color = "D3D3D3"
      rows(0).size = 7
    end

    pdf.move_down 20

    washsheet_detail_table_data = [
      ["Product", "Whole Cheese Count", "Cheeses Washed", "Notes"]
    ]

    @picksheetitems_by_product.each do |product, picksheetitems|
      washsheet_detail_table_data << [
        product,
        how_many_cheeses_do_i_need(product, picksheetitems),
        "",
        ""
      ]
    end

    pdf.table(washsheet_detail_table_data) do
      self.width = 450
      self.cell_style = {
        inline_format: true,
        size: 10
      }

      columns(0..2).width = 100
      columns(3).width = 150
      columns(0..3).align = :center
      rows(0).background_color = "D3D3D3"
      rows(0).size = 7
    end

    pdf.move_down 20

    signature_box = [
      ["Wash completed by:"],
      [""]
    ]

    pdf.table(signature_box) do
      self.width = 300
      self.cell_style = {
        inline_format: true,
        size: 10
      }

      columns(0).width = 300
      rows(0).background_color = "D3D3D3"
      rows(0).size = 7
      rows(1).height = 70
    end

    pdf.image(
      logo_img_path.to_s,
      at: [482, 742],
      width: 80
    )

    send_data(
      pdf.render,
      filename: "washsheet_pdf.pdf",
      type: "application/pdf",
      disposition: "inline"
    )
  end

  private

  def set_wash
    @wash = Wash.find(params[:id])
  end

  def authorize_wash_read!
    authorize! :read, @wash || Wash
  end

  def authorize_wash_manage!
    authorize! :manage, @wash || Wash
  end

  def wash_params
    params.require(:wash).permit(
      :action_date,
      :wash_status,
      picksheet_ids: []
    )
  end

  def set_available_picksheets_for_new
    assigned_picksheet_ids = WashPicksheet.pluck(:picksheet_id)

    @picksheets_subset =
      Picksheet
      .where.not(status: "Shipped")
      .where.not(id: assigned_picksheet_ids)
      .order(:delivery_required_by)
  end

  def set_available_picksheets_for_edit
    @picksheets_subset =
      Picksheet
      .where("delivery_required_by >= ?", Date.current)
      .order(:delivery_required_by)
  end

  def washable_picksheet_items(picksheet_items)
    washable_products =
      Calculation
      .where(size: "Whole")
      .pluck(:product)

    picksheet_items.where(product: washable_products)
  end

  def weight_of_whole_cheese(product)
    Calculation.find_by(
      product: product,
      size: "Whole"
    )&.weight
  end

  def get_weight_of_group(picksheet_items)
    picksheet_items.sum(&:get_weight)
  end

  def how_many_cheeses_do_i_need(product, picksheet_items)
    ordered_weight_in_grams =
      get_weight_of_group(picksheet_items) * 1000

    whole_cheese_weight =
      weight_of_whole_cheese(product)

    if whole_cheese_weight.blank?
      raise "Whole cheese weight is not configured for #{product}"
    end

    (
      ordered_weight_in_grams.to_f /
      whole_cheese_weight.to_f
    ).round(1)
  end
end