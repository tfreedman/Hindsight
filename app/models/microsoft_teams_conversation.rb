class MicrosoftTeamsConversation < ActiveRecord::Base
  establish_connection :hindsight

  serialize :properties
  serialize :thread_properties
end
