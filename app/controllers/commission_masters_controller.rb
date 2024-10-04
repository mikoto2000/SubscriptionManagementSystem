class CommissionMastersController < ApplicationController
  include Pundit
  include Pagy::Backend

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  before_action :set_commission_master, only: %i[show edit update destroy]

  # GET /commission_masters
  def index
    authorize CommissionMaster
    @commission_masters = CommissionMaster
      .all
    @q = @commission_masters.ransack(params[:q])
    @q.sorts = "id asc" if @q.sorts.empty?
    @pagy, @commission_masters = pagy(@q.result, page: params[:page], items: params[:items])
  end

  # GET /commission_masters/1
  def show
    authorize CommissionMaster
  end

  # GET /commission_masters/new
  def new
    authorize CommissionMaster
    @commission_master = CommissionMaster.new
  end

  # GET /commission_masters/1/edit
  def edit
    authorize CommissionMaster
  end

  # POST /commission_masters
  def create
    authorize CommissionMaster
    @commission_master = CommissionMaster.new(commission_master_params)

    if @commission_master.save
      redirect_to @commission_master, notice: t("controller.create.success", model: CommissionMaster.model_name.human)
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /commission_masters/1
  def update
    authorize CommissionMaster
    if @commission_master.update(commission_master_params)
      redirect_to @commission_master, notice: t("controller.edit.success", model: CommissionMaster.model_name.human)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /commission_masters/1
  def destroy
    authorize CommissionMaster
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
