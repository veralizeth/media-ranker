class Work < ApplicationRecord

  validates :title, presence: true, uniqueness: true
  
  def self.top_ten(category)
    all_works = self.all
    ten_works = all_works.select do |work|
      work.category == category
    end

    return ten_works
  end
end
