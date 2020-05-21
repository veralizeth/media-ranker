class Work < ApplicationRecord
  has_many :votes
  has_many :users, through: :votes

  validates :title, presence: true, uniqueness: true
  validates :description, length: { maximum: 200,
                                    too_long: "%{count} characters is the maximum allowed" }
  validates :publication_year, numericality: { greater_than: 0 }

  def self.all_work(category)
    all_works = self.all
    ten_works = all_works.select do |work|
      work.category == category
    end
    return ten_works
  end

  def self.top_ten(category)
    all_works = self.all
    voted_works = all_works.select do |work|
      work.category == category && work.votes.count > 0
    end
    # Minus -work to order the results descending. 
    top = voted_works.sort_by { |work| -work.votes.length }

    top.length < 10 ? top : top[0..9]
  end

  def self.spotlight
    all_works = self.all
    spotlight = all_works.select do |work|
      work.votes.count > 0
    end
    # Minus -work to order the results descending.
    top = spotlight.sort_by { |work| -work.votes.length }

    return top[0]
  end
end
