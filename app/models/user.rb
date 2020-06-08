class User < ApplicationRecord
  # we need to make sure that our User model has the attributes uid and provider
  # saved on them... meaning that every instance of User will either have a value
  # for those two things because they logged in with GitHub,
  # or they will be nil because they did not log in with GitHub.
  has_many :votes
  has_many :works, through: :votes
  validates :username, presence: true

  # class method, because it doesn't operate off of a single instance.
  def self.build_from_github(auth_hash)
    user = User.new
    user.uid = auth_hash[:uid]
    user.provider = "github"
    user.username = auth_hash["info"]["name"]
    user.email = auth_hash["info"]["email"]

    # Note that the user has not been saved.
    # We'll choose to do the saving outside of this method
    return user
  end
end
