class SubscriberPaymentsController < ApplicationController
  include Pagy::Backend
  before_action :set_subscriber_payment, only: %i[show edit update destroy]

  # GET /subscriber_payments
  def index
    @subscriber_payments = SubscriberPayment
      .eager_load(:payment_status)
      .eager_load(:subscriber)
    @q = @subscriber_payments.ransack(params[:q])
    @q.sorts = "id asc" if @q.sorts.empty?
    @pagy, @subscriber_payments = pagy(@q.result, page: params[:page], items: params[:items])
  end

  # GET /subscriber_payments/1
  def show
  end

  # GET /subscriber_payments/new
  def new
    @subscriber_payment = SubscriberPayment.new
  end

  # GET /subscriber_payments/1/edit
  def edit
  end

  # POST /subscriber_payments
  def create
    @subscriber_payment = SubscriberPayment.new(subscriber_payment_params)

    if @subscriber_payment.save
      redirect_to @subscriber_payment, notice: t("controller.create.success", model: SubscriberPayment.model_name.human)
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /subscriber_payments/1
  def update
    if @subscriber_payment.update(subscriber_payment_params)
      redirect_to @subscriber_payment, notice: t("controller.edit.success", model: SubscriberPayment.model_name.human)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /subscriber_payments/1
  def destroy
    @subscriber_payment.destroy!
    redirect_to subscriber_payments_url, notice: t("controller.destroy.success", model: SubscriberPayment.model_name.human)
  end

  private

    # Use callbacks to share common setup or constraints between actions.
    def set_subscriber_payment
      @subscriber_payment = SubscriberPayment
        .eager_load(:payment_status)
        .eager_load(:subscriber)
        .find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def subscriber_payment_params
      params.require(:subscriber_payment).permit(:month_for_payment, :payment_date, :payment_status_id, :subscriber_id)
    end
end
