class GitHubCommit < ActiveRecord::Base
  self.table_name = "github_commits"
  establish_connection :hindsight

  serialize :commit
  serialize :author
  serialize :committer
  serialize :parents
end
