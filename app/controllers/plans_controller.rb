class PlansController < ApplicationController
  include Pundit
  include Pagy::Backend

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  before_action :set_plan, only: %i[show edit update destroy]

  # GET /plans
  def index
    authorize Plan
    @plans = Plan
      .eager_load(:publisher)
    @q = @plans.ransack(params[:q])
    @q.sorts = "id asc" if @q.sorts.empty?
    @pagy, @plans = pagy(@q.result, page: params[:page], items: params[:items])
  end

  # GET /plans/1
  def show
    authorize Plan
  end

  # GET /plans/new
  def new
    authorize Plan
    @plan = Plan.new
  end

  # GET /plans/1/edit
  def edit
    authorize Plan
  end

  # POST /plans
  def create
    authorize Plan
    @plan = Plan.new(plan_params)

    if @plan.save
      # TODO: ちゃんとリクエスト画面がわかるパラメーターを追加する
      if params[:commit] == "作成"
        redirect_to @plan, notice: t("controller.create.success", model: Plan.model_name.human)
      else
        redirect_to root_path, notice: t("controller.edit.success", model: Plan.model_name.human)
      end
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /plans/1
  def update
    authorize Plan
    if @plan.update(plan_params)
      redirect_to @plan, notice: t("controller.edit.success", model: Plan.model_name.human)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /plans/1
  def destroy
    authorize Plan
    @plan.destroy!
    redirect_to plans_url, notice: t("controller.destroy.success", model: Plan.model_name.human)
  end

  private

    # Use callbacks to share common setup or constraints between actions.
    def set_plan
      @plan = Plan
        .eager_load(:publisher)
        .find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def plan_params
      params.require(:plan).permit(:publisher_id, :name, :cost)
    end
end
