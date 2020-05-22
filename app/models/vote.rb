class Vote < ApplicationRecord
  belongs_to :user
  belongs_to :work
  # it can also validate whether the value of the specified attributes
  # are unique based on multiple scope parameters.
  validates :user_id, presence: true, uniqueness: { scope: :work_id }
  validates :work_id, presence: true
  
end
