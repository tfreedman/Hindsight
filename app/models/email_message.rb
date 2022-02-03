class EmailMessage < ActiveRecord::Base
  establish_connection :hindsight
  serialize :to
  serialize :reply_to
  serialize :sender
  serialize :cc
  serialize :bcc
end
