class AccountsController < ApplicationController
  include Pundit
  include Pagy::Backend

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  before_action :set_account, only: %i[show edit update destroy]

  # GET /accounts
  def index
    authorize Account
    @accounts = Account
      .eager_load(:publisher)
      .eager_load(:subscriber)
    @q = @accounts.ransack(params[:q])
    @q.sorts = "id asc" if @q.sorts.empty?
    @pagy, @accounts = pagy(@q.result, page: params[:page], items: params[:items])
  end

  # GET /accounts/1
  def show
    authorize Account
  end

  # GET /accounts/new
  def new
    authorize Account
    @account = Account.new
  end

  # GET /accounts/1/edit
  def edit
    authorize Account
  end

  # POST /accounts
  def create
    authorize Account
    @account = Account.new(account_params)

    if @account.save
      redirect_to @account, notice: t("controller.create.success", model: Account.model_name.human)
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /accounts/1
  def update
    authorize Account
    if @account.update(account_params)
      redirect_to @account, notice: t("controller.edit.success", model: Account.model_name.human)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /accounts/1
  def destroy
    authorize Account
    @account.destroy!
    redirect_to accounts_url, notice: t("controller.destroy.success", model: Account.model_name.human)
  end

  private

    # Use callbacks to share common setup or constraints between actions.
    def set_account
      @account = Account
        .eager_load(:publisher)
        .eager_load(:subscriber)
        .find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def account_params
      params.require(:account).permit(:name, :email_address, :publisher_id, :subscriber_id)
    end

    def user_not_authorized
      flash[:alert] = "You are not authorized to perform this action."
      redirect_to(request.referer || root_path)
    end
end
