class Work < ApplicationRecord
  has_many :votes
  has_many :users, through: :votes

  validates :title, presence: true, uniqueness: true
  validates :description, length: { maximum: 200,
                                    too_long: "%{count} characters is the maximum allowed" }
  validates :publication_year, numericality: { greater_than: 0 }

  def self.top_ten(category)
    all_works = self.all
    ten_works = all_works.select do |work|
      work.category == category
    end

    return ten_works
  end
end
