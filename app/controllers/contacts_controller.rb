class ContactsController < ApplicationController
  before_action :authenticate_user!

  before_action :set_contact,
                only: %i[
                  show
                  edit
                  update
                  destroy
                  search_makesheets
                  link_makesheets
                ]

  # Office: manage. Nobody else has any access at all.
  before_action :authorize_contact_read!, only: %i[index show search_makesheets]
  before_action :authorize_contact_manage!, only: %i[new create edit update destroy link_makesheets]

  # ==========================================================
  # CRUD
  # ==========================================================

  # GET /contacts
  def index
    @contacts = Contact.all

    # Search by business name
    if params[:search].present?
      @contacts = @contacts.where(
        "business_name ILIKE ?",
        "%#{params[:search]}%"
      )
    end

    # Whitelisted sorting
    sortable_columns = %w[
      business_name
      contact_name
      reference
      email
      country
    ]

    column =
      params[:column].presence_in(sortable_columns) ||
      "business_name"

    direction =
      params[:direction] == "desc" ? "desc" : "asc"

    @contacts = @contacts.order(column => direction)

    respond_to do |format|
      format.html
      format.turbo_stream
    end
  end

  # GET /contacts/1
  def show
    prepare_show_data
  end

  # GET /contacts/new
  def new
    @contact = Contact.new
  end

  # GET /contacts/1/edit
  def edit
  end

  # POST /contacts
  def create
    @contact = Contact.new(contact_params)

    respond_to do |format|
      if @contact.save
        format.html {
          redirect_to contact_url(@contact),
                      notice: "Contact was successfully created."
        }

        format.json {
          render :show,
                 status: :created,
                 location: @contact
        }
      else
        format.html {
          render :new,
                 status: :unprocessable_entity
        }

        format.json {
          render json: @contact.errors,
                 status: :unprocessable_entity
        }
      end
    end
  end

  # PATCH/PUT /contacts/1
  def update
    respond_to do |format|
      if @contact.update(contact_params)
        format.html {
          redirect_to contact_url(@contact),
                      notice: "Contact was successfully updated."
        }

        format.json {
          render :show,
                 status: :ok,
                 location: @contact
        }
      else
        format.html {
          render :edit,
                 status: :unprocessable_entity
        }

        format.json {
          render json: @contact.errors,
                 status: :unprocessable_entity
        }
      end
    end
  end

  # DELETE /contacts/1
  def destroy
    @contact.destroy

    respond_to do |format|
      format.html {
        redirect_to contacts_url,
                    notice: "Contact was successfully destroyed."
      }

      format.json { head :no_content }
    end
  end

  # ==========================================================
  # Reserved Customer Batches
  # ==========================================================

  def search_makesheets
    prepare_show_data

    @makesheets =
      if params[:make_date].present?
        available_makesheets.where(make_date: params[:make_date])
      else
        available_makesheets
      end

    render :show
  end

  def link_makesheets
    selected_makesheets = Makesheet.where(id: params[:makesheet_ids])

    selected_makesheets.find_each do |makesheet|
      makesheet.update!(contact: @contact)
    end

    redirect_to @contact,
                notice: "Makesheets linked successfully!"
  end

  private

  # ==========================================================
  # Setup
  # ==========================================================

  def set_contact
    @contact = Contact.find(params[:id])
  end

  def authorize_contact_read!
    authorize! :read, @contact || Contact
  end

  def authorize_contact_manage!
    authorize! :manage, @contact || Contact
  end

  def prepare_show_data
    @picksheets = @contact.picksheets
                          .order(
                            date_order_placed: :desc,
                            id: :desc
                          )

    @makesheets ||= available_makesheets
  end

  def available_makesheets
    Makesheet
      .where(contact_id: nil)
      .where.not(status: "Finished")
      .where.not(grade: [nil, ""])
      .ordered
  end

  # ==========================================================
  # Strong params
  # ==========================================================

  def contact_params
    params.require(:contact).permit(
      :business_name,
      :contact_name,
      :reference,
      :email,
      :mobile,
      :phone,
      :country,
      :address,
      :pre_payment,
      :payment_on_receipt,
      :days_after_invoice,
      :terms_and_conditions,
      :sage_delivery_note,
      :contact_id,
      :notes
    )
  end
end