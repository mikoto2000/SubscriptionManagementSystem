class PaymentStatusesController < ApplicationController
  include Pagy::Backend
  before_action :set_payment_status, only: %i[show edit update destroy]

  # GET /payment_statuses
  def index
    @payment_statuses = PaymentStatus
      .all
    @q = @payment_statuses.ransack(params[:q])
    @q.sorts = "id asc" if @q.sorts.empty?
    @pagy, @payment_statuses = pagy(@q.result, page: params[:page], items: params[:items])
  end

  # GET /payment_statuses/1
  def show
  end

  # GET /payment_statuses/new
  def new
    @payment_status = PaymentStatus.new
  end

  # GET /payment_statuses/1/edit
  def edit
  end

  # POST /payment_statuses
  def create
    @payment_status = PaymentStatus.new(payment_status_params)

    if @payment_status.save
      redirect_to @payment_status, notice: t("controller.create.success", model: PaymentStatus.model_name.human)
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /payment_statuses/1
  def update
    if @payment_status.update(payment_status_params)
      redirect_to @payment_status, notice: t("controller.edit.success", model: PaymentStatus.model_name.human)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /payment_statuses/1
  def destroy
    @payment_status.destroy!
    redirect_to payment_statuses_url, notice: t("controller.destroy.success", model: PaymentStatus.model_name.human)
  end

  private

    # Use callbacks to share common setup or constraints between actions.
    def set_payment_status
      @payment_status = PaymentStatus
        .find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def payment_status_params
      params.require(:payment_status).permit(:name)
    end
end
