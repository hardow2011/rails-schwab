class TransactionsController < ApplicationController
  before_action :authorized
  def index
    @transactions = current_user.transactions.to_json
  end
end
