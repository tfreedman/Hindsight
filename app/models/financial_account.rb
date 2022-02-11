class FinancialAccount < ApplicationRecord
  establish_connection :finances
  self.table_name = 'accounts'
  has_many :transactions, :foreign_key => 'account_id', :class_name => "FinancialTransaction", :primary_key => 'id'
end
