require 'csv'

module TransactionsBuilder
  def set_transactions(csv)
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
      byebug
      withdrawal = convert_to_float(row[4])
      deposit = convert_to_float(row[5])
      running_balance = convert_to_float(row[6])
      Transaction.create(date: date, transaction_type: transaction_type, description: description,
                      withdrawal: withdrawal, deposit: deposit,
                      running_balance: running_balance,
                      user: self)
    end

  end

  private

  def convert_to_float(string)
    return string.gsub(/[^(\d|\.)]/, "").to_f if string
    ""
  end
end