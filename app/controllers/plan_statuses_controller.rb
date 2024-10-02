class PlanStatusesController < ApplicationController
  include Pagy::Backend
  before_action :set_plan_status, only: %i[show edit update destroy]

  # GET /plan_statuses
  def index
    @plan_statuses = PlanStatus
      .all
    @q = @plan_statuses.ransack(params[:q])
    @q.sorts = "id asc" if @q.sorts.empty?
    @pagy, @plan_statuses = pagy(@q.result, page: params[:page], items: params[:items])
  end

  # GET /plan_statuses/1
  def show
  end

  # GET /plan_statuses/new
  def new
    @plan_status = PlanStatus.new
  end

  # GET /plan_statuses/1/edit
  def edit
  end

  # POST /plan_statuses
  def create
    @plan_status = PlanStatus.new(plan_status_params)

    if @plan_status.save
      redirect_to @plan_status, notice: t("controller.create.success", model: PlanStatus.model_name.human)
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /plan_statuses/1
  def update
    if @plan_status.update(plan_status_params)
      redirect_to @plan_status, notice: t("controller.edit.success", model: PlanStatus.model_name.human)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /plan_statuses/1
  def destroy
    @plan_status.destroy!
    redirect_to plan_statuses_url, notice: t("controller.destroy.success", model: PlanStatus.model_name.human)
  end

  private

    # Use callbacks to share common setup or constraints between actions.
    def set_plan_status
      @plan_status = PlanStatus
        .find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def plan_status_params
      params.require(:plan_status).permit(:name)
    end
end
