require 'csv'

module TransactionsBuilder
  def set_transactions(csv)
    csv = csv.values[0]
    csv = CSV.read(csv)
    transactions_first_index = 1
    transactions = []
    csv[transactions_first_index..-1].each_with_index do |row, i|
      status = row[1]
      next if status == 'Pending'
      date = Date.strptime(row[0], "%m/%d/%Y")
      type = row[2]
      description = row[4]
      withdrawal = convert_to_float(row[5])
      deposit = convert_to_float(row[6])
      running_balance = convert_to_float(row[7])
      transactions << { date: date, type: type, description: description,
                        withdrawal: withdrawal, deposit: deposit,
                        running_balance: running_balance }
    end

    self.transactions = transactions
    save
    return
  end

  def get_transactions_chart_data
    chart_data = []
    last_transactions_by_date = transactions.group_by { |t| t['date'] }.transform_values(&:first).values.reverse
    last_transactions_by_date.each_with_index do |t, i|
      next_t = last_transactions_by_date[i + 1]
      chart_data << { date: t['date'], running_balance: t['running_balance'] }
      if next_t
        days_between_next_transaction = (Date.parse(next_t['date']) - Date.parse(t['date'])).to_i - 1
        if days_between_next_transaction >= 1
          new_day = t
          (0..days_between_next_transaction - 1).each_with_index do |_, k|
            new_date =  Date.parse(new_day['date']).next_day(k + 1).strftime('%Y-%m-%d')
            chart_data << { date: new_date, running_balance: new_day['running_balance'] }
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