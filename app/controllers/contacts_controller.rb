class ContactsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_contact, only: %i[ show edit update destroy ]

  # GET /contacts or /contacts.json
  def index
    @contacts = Contact.all.order(:business_name)

    # Apply search filter if present
    if params[:search].present?
      @contacts = @contacts.where("business_name ILIKE ?", "%#{params[:search]}%")
    end
  
    # Apply sorting if present
    if params[:column].present? && params[:direction].present?
      @contacts = @contacts.order("#{params[:column]} #{params[:direction]}")
    else
      @contacts = @contacts.order(:business_name) # Default ordering
    end

    respond_to do |format|
      format.html # Normal page load
      format.turbo_stream # Handles Turbo update
    end
  end

  # GET /contacts/1 or /contacts/1.json
  def show
    @contact = Contact.includes(:makesheets).find(params[:id])
    @picksheets = @contact.picksheets
                          .includes(:user) # for taken by initials
                          .order(date_order_placed: :desc, id: :desc)
    @makesheets = Makesheet.where(contact_id: nil).where.not(status: "Finished").where.not(grade: [nil, '']).ordered # Only unlinked makesheets

  end

  def search_makesheets
    @contact = Contact.find(params[:id])
    if params[:make_date].present?
      @makesheets = Makesheet.where(make_date: params[:make_date], contact_id: nil)
    else
      @makesheets = Makesheet.where(contact_id: nil).where.not(status: "Finished")
    end
    render :show
  end

  def link_makesheets
    @contact = Contact.find(params[:id])

    selected_makesheets = Makesheet.where(id: params[:makesheet_ids])

    # Link the selected makesheets to the contact
    selected_makesheets.update_all(contact_id: @contact.id)

    redirect_to @contact, notice: "Makesheets linked successfully!"
  end

  # GET /contacts/new
  def new
    @contact = Contact.new
  end

  # GET /contacts/1/edit
  def edit
  end

  # POST /contacts or /contacts.json
  def create
    @contact = Contact.new(contact_params)

    respond_to do |format|
      if @contact.save
        format.html { redirect_to contact_url(@contact), notice: "Contact was successfully created." }
        format.json { render :show, status: :created, location: @contact }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @contact.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /contacts/1 or /contacts/1.json
  def update
    respond_to do |format|
      if @contact.update(contact_params)
        format.html { redirect_to contact_url(@contact), notice: "Contact was successfully updated." }
        format.json { render :show, status: :ok, location: @contact }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @contact.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /contacts/1 or /contacts/1.json
  def destroy
    @contact.destroy

    respond_to do |format|
      format.html { redirect_to contacts_url, notice: "Contact was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_contact
      @contact = Contact.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def contact_params
      params.require(:contact).permit(:business_name, :contact_name, :reference, :email, :mobile, :phone, :country, :address, :pre_payment, :payment_on_receipt, :days_after_invoice, :terms_and_conditions, :sage_delivery_note, :contact_id, :notes)
    end
end
