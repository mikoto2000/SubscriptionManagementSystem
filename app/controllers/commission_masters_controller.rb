class CommissionMastersController < ApplicationController
  include Pagy::Backend
  before_action :set_commission_master, only: %i[show edit update destroy]

  # GET /commission_masters
  def index
    @commission_masters = CommissionMaster
      .all
    @q = @commission_masters.ransack(params[:q])
    @q.sorts = "id asc" if @q.sorts.empty?
    @pagy, @commission_masters = pagy(@q.result, page: params[:page], items: params[:items])
  end

  # GET /commission_masters/1
  def show
  end

  # GET /commission_masters/new
  def new
    @commission_master = CommissionMaster.new
  end

  # GET /commission_masters/1/edit
  def edit
  end

  # POST /commission_masters
  def create
    @commission_master = CommissionMaster.new(commission_master_params)

    if @commission_master.save
      redirect_to @commission_master, notice: t("controller.create.success", model: CommissionMaster.model_name.human)
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /commission_masters/1
  def update
    if @commission_master.update(commission_master_params)
      redirect_to @commission_master, notice: t("controller.edit.success", model: CommissionMaster.model_name.human)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /commission_masters/1
  def destroy
    @commission_master.destroy!
    redirect_to commission_masters_url, notice: t("controller.destroy.success", model: CommissionMaster.model_name.human)
  end

  private

    # Use callbacks to share common setup or constraints between actions.
    def set_commission_master
      @commission_master = CommissionMaster
        .find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def commission_master_params
      params.require(:commission_master).permit(:from_date, :to_date, :commission_fee)
    end
end
