class PublishersController < ApplicationController
  include Pagy::Backend

  # GET /publishers
  def index
    @publishers = Publisher
      .all
    @q = @publishers.ransack(params[:q])
    @q.sorts = "id asc" if @q.sorts.empty?
    @pagy, @publishers = pagy(@q.result, page: params[:page], items: params[:items])
  end

  # GET /publishers/1
  def show
  end

  # GET /publishers/new
  def new
    @publisher = Publisher.new
  end

  # GET /publishers/1/edit
  def edit
  end

  # POST /publishers
  def create
    @publisher = Publisher.new(publisher_params)

    if @publisher.save
      redirect_to @publisher, notice: t("controller.create.success", model: Publisher.model_name.human)
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /publishers/1
  def update
    if @publisher.update(publisher_params)
      redirect_to @publisher, notice: t("controller.edit.success", model: Publisher.model_name.human)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /publishers/1
  def destroy
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
