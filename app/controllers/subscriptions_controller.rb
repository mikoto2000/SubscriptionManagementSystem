class SubscriptionsController < ApplicationController
  include Pagy::Backend
  before_action :set_subscription, only: %i[show edit update destroy]

  # GET /subscriptions
  def index
    @subscriptions = Subscription
      .eager_load(:publisher)
      .eager_load(:subscriber)
      .eager_load(:plan)
    @q = @subscriptions.ransack(params[:q])
    @q.sorts = "id asc" if @q.sorts.empty?
    @pagy, @subscriptions = pagy(@q.result, page: params[:page], items: params[:items])
  end

  # GET /subscriptions/1
  def show
  end

  # GET /subscriptions/new
  def new
    @subscription = Subscription.new
  end

  # GET /subscriptions/1/edit
  def edit
  end

  # POST /subscriptions
  def create
    @subscription = Subscription.new(subscription_params)

    if @subscription.save
      # TODO: ちゃんとリクエスト画面がわかるパラメーターを追加する
      if params[:commit] == "作成"
        redirect_to @subscription, notice: t("controller.create.success", model: Subscription.model_name.human)
      else
        redirect_to account_path(:id => params[:subscription][:publisher_id]), notice: t("controller.create.success", model: Subscription.model_name.human)
      end
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /subscriptions/1
  def update
    if @subscription.update(subscription_params)
      # TODO: ちゃんとリクエスト画面がわかるパラメーターを追加する
      if params[:commit] == "更新"
        redirect_to @subscription, notice: t("controller.edit.success", model: Subscription.model_name.human)
      else
        redirect_to account_path, notice: t("controller.edit.success", model: Subscription.model_name.human)
      end
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /subscriptions/1
  def destroy
    @subscription.destroy!
    redirect_to subscriptions_url, notice: t("controller.destroy.success", model: Subscription.model_name.human)
  end

  private

    # Use callbacks to share common setup or constraints between actions.
    def set_subscription
      @subscription = Subscription
        .eager_load(:publisher)
        .eager_load(:subscriber)
        .eager_load(:plan)
        .find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def subscription_params
      params.require(:subscription).permit(:publisher_id, :subscriber_id, :start_date, :end_date, :plan_id)
    end
end
