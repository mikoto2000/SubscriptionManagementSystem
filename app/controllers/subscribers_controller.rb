class SubscribersController < ApplicationController
  include Pundit
  include Pagy::Backend

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  before_action :set_subscriber, only: %i[show edit update destroy]

  # GET /subscribers
  def index
    authorize Subscriber
    @subscribers = Subscriber
      .all
    @q = @subscribers.ransack(params[:q])
    @q.sorts = "id asc" if @q.sorts.empty?
    @pagy, @subscribers = pagy(@q.result, page: params[:page], items: params[:items])
  end

  # GET /subscribers/1
  def show
    authorize Subscriber
  end

  # GET /subscribers/new
  def new
    authorize Subscriber
    @subscriber = Subscriber.new
  end

  # GET /subscribers/1/edit
  def edit
    authorize Subscriber
  end

  # POST /subscribers
  def create
    authorize Subscriber
    @subscriber = Subscriber.new(subscriber_params)

    if @subscriber.save
      redirect_to @subscriber, notice: t("controller.create.success", model: Subscriber.model_name.human)
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /subscribers/1
  def update
    authorize Subscriber
    if @subscriber.update(subscriber_params)
      redirect_to @subscriber, notice: t("controller.edit.success", model: Subscriber.model_name.human)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /subscribers/1
  def destroy
    authorize Subscriber
    @subscriber.destroy!
    redirect_to subscribers_url, notice: t("controller.destroy.success", model: Subscriber.model_name.human)
  end

  private

    # Use callbacks to share common setup or constraints between actions.
    def set_subscriber
      @subscriber = Subscriber
        .find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def subscriber_params
      params.require(:subscriber).permit(:name, :email_address)
    end
end
