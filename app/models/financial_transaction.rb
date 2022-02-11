class FinancialTransaction < ApplicationRecord
  establish_connection :finances
  belongs_to :account, :foreign_key => 'account_id', :class_name => "FinancialAccount", :primary_key => 'id'
  self.table_name = 'transactions'

  def credit
    if self[:credit]
      self[:credit]
    else
      0
    end
  end

  def debit
    if self[:debit]
      self[:debit]
    else
      0
    end
  end

  def amount
    if self[:debit]
      self[:debit] * -1
    elsif self[:credit]
      self[:credit]
    end
  end

  def adjusted_amount
    if self.account.currency == "USD"
      days = 0
      loop do
        x = ExchangeRate.where(date: self[:date] - days.day).first
        if x
          return sprintf('%.2f', (amount / x.usd_rate))
        end
        days += 1
      end
    else
      return sprintf('%.2f', amount)
    end
  end

  def double_entry
    if self[:debit]
      return Transaction.where(date: self[:date], credit: self[:debit]).first
    elsif self[:credit]
      return Transaction.where(date: self[:date], debit: self[:credit]).first
    end
  end
end
