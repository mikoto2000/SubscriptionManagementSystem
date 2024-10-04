class PublisherAccountsController < ApplicationController
  before_action :set_account, only: %i[show]
  before_action :set_plans, only: %i[show]

  def index
    @accounts = Account.all
  end

  def show
  end

  private

    def set_account
      @account = Account.find(params[:id])
    end

    def set_plans
      @plans = Plan.where(publisher_id: @account.publisher_id)
    end
end
