class PaymentsController < ApplicationController
  include Pagy::Backend
  before_action :set_payment, only: %i[show edit update destroy]

  # GET /payments
  def index
    @payments = Payment
      .eager_load(:payment_status)
      .eager_load(:account)
    @q = @payments.ransack(params[:q])
    @q.sorts = "id asc" if @q.sorts.empty?
    @pagy, @payments = pagy(@q.result, page: params[:page], items: params[:items])
  end

  # GET /payments/1
  def show
  end

  # GET /payments/new
  def new
    @payment = Payment.new
  end

  # GET /payments/1/edit
  def edit
  end

  # POST /payments
  def create
    @payment = Payment.new(payment_params)

    if @payment.save
      redirect_to @payment, notice: t("controller.create.success", model: Payment.model_name.human)
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /payments/1
  def update
    if @payment.update(payment_params)
      redirect_to @payment, notice: t("controller.edit.success", model: Payment.model_name.human)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /payments/1
  def destroy
    @payment.destroy!
    redirect_to payments_url, notice: t("controller.destroy.success", model: Payment.model_name.human)
  end

  private

    # Use callbacks to share common setup or constraints between actions.
    def set_payment
      @payment = Payment
        .eager_load(:payment_status)
        .eager_load(:account)
        .find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def payment_params
      params.require(:payment).permit(:year, :month, :payment_date, :payment_status_id, :account_id)
    end
end
