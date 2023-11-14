class TransactionsController < ApplicationController
  before_action :authorized
  def index
    @transactions = current_user.get_transactions_chart_data.to_json.html_safe
  end
end
