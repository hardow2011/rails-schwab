require 'csv'

module TransactionsBuilder
  def set_transactions(csv)
    # TODO: replace destroy_all for more efficient process.
    #  Maybe set flag instead, and remove with background process
    self.transactions.destroy_all

    csv = csv.values[0]
    csv = CSV.read(csv)
    transactions_first_index = nil
    csv.each_with_index do |row, i|
      transactions_first_index = i + 1 if row[0] == "Posted Transactions"
    end
    csv[transactions_first_index..-1].each_with_index do |row, i|
      date = Date.strptime(row[0], "%m/%d/%Y")
      transaction_type = TransactionType.find_or_create_by(name: row[1])
      description = row[3]
      puts "*** #{date} #{description}"
      withdrawal = convert_to_float(row[4])
      deposit = convert_to_float(row[5])
      running_balance = convert_to_float(row[6])
      Transaction.create(date: date, transaction_type: transaction_type, description: description,
                         withdrawal: withdrawal, deposit: deposit,
                         running_balance: running_balance,
                         user: self)
    end

    self.transactions_chart_cache = build_chart_data
    save
    return
  end

  def get_transactions_chart_data
    chart_data = (transactions_chart_cache || [])
    if chart_data.empty?
      p "*** CACHE NOT USED. SAVE TO CACHE ***"
      build_chart_data
    else
      p "*** CACHE USED. RETURN ALREADY FORMATTED DATA ***"
      chart_data
    end
  end

  def build_chart_data
    chart_data = []
    p "*** CACHE NOT USED. SAVE TO CACHE ***"
    last_transactions_by_date = transactions.order(:created_at).group_by(&:date).transform_values(&:first).values.reverse
    last_transactions_by_date.each_with_index do |t, i|
      next_t = last_transactions_by_date[i + 1]
      chart_data << t.as_json(:chart_data)
      if next_t
        days_between_next_transaction = (next_t.date - t.date).to_i - 1
        if days_between_next_transaction >= 1
          new_day = t
          (0..days_between_next_transaction - 1).each_with_index do |_, k|
            new_day.date = new_day.date.next_day(k + 1)
            chart_data << new_day.as_json(:chart_data)
            new_day.date = t.date
          end
        end
      end
    end
    chart_data.to_json
  end

  private

  def convert_to_float(string)
    return string.gsub(/[^(\d|\.)]/, "").to_f if string
    ""
  end
end