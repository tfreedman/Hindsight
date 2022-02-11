class ExchangeRate < ActiveRecord::Base
  establish_connection :finances
end
