class PublisherPaymentsController < ApplicationController
  include Pagy::Backend
  before_action :set_publisher_payment, only: %i[show edit update destroy]

  # GET /publisher_payments
  def index
    @publisher_payments = PublisherPayment
      .eager_load(:payment_status)
      .eager_load(:publisher)
    @q = @publisher_payments.ransack(params[:q])
    @q.sorts = "id asc" if @q.sorts.empty?
    @pagy, @publisher_payments = pagy(@q.result, page: params[:page], items: params[:items])
  end

  # GET /publisher_payments/1
  def show
  end

  # GET /publisher_payments/new
  def new
    @publisher_payment = PublisherPayment.new
  end

  # GET /publisher_payments/1/edit
  def edit
  end

  # POST /publisher_payments
  def create
    @publisher_payment = PublisherPayment.new(publisher_payment_params)

    if @publisher_payment.save
      redirect_to @publisher_payment, notice: t("controller.create.success", model: PublisherPayment.model_name.human)
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /publisher_payments/1
  def update
    if @publisher_payment.update(publisher_payment_params)
      redirect_to @publisher_payment, notice: t("controller.edit.success", model: PublisherPayment.model_name.human)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /publisher_payments/1
  def destroy
    @publisher_payment.destroy!
    redirect_to publisher_payments_url, notice: t("controller.destroy.success", model: PublisherPayment.model_name.human)
  end

  private

    # Use callbacks to share common setup or constraints between actions.
    def set_publisher_payment
      @publisher_payment = PublisherPayment
        .eager_load(:payment_status)
        .eager_load(:publisher)
        .find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def publisher_payment_params
      params.require(:publisher_payment).permit(:month_for_payment, :payment_date, :payment_status_id, :publisher_id)
    end
end
