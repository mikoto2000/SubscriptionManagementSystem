class PublishersController < ApplicationController
  include Pundit
  include Pagy::Backend

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  before_action :set_publisher, only: %i[show edit update destroy]

  # GET /publishers
  def index
    authorize Publisher
    @publishers = Publisher
      .all
    @q = @publishers.ransack(params[:q])
    @q.sorts = "id asc" if @q.sorts.empty?
    @pagy, @publishers = pagy(@q.result, page: params[:page], items: params[:items])
  end

  # GET /publishers/1
  def show
    authorize Publisher
  end

  # GET /publishers/new
  def new
    authorize Publisher
    @publisher = Publisher.new
  end

  # GET /publishers/1/edit
  def edit
    authorize Publisher
  end

  # POST /publishers
  def create
    authorize Publisher
    @publisher = Publisher.new(publisher_params)

    if @publisher.save
      redirect_to @publisher, notice: t("controller.create.success", model: Publisher.model_name.human)
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /publishers/1
  def update
    authorize Publisher
    if @publisher.update(publisher_params)
      redirect_to @publisher, notice: t("controller.edit.success", model: Publisher.model_name.human)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /publishers/1
  def destroy
    authorize Publisher
    @publisher.destroy!
    redirect_to publishers_url, notice: t("controller.destroy.success", model: Publisher.model_name.human)
  end

  private

    # Use callbacks to share common setup or constraints between actions.
    def set_publisher
      @publisher = Publisher
        .find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def publisher_params
      params.require(:publisher).permit(:name, :email_address)
    end
end
