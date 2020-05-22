require "test_helper"

describe User do
  let (:new_work) {
    Work.create(category: "album", title: "A Night at the Opera", creator: "Queen", publication_year: "1975", description: "A Night at the Opera was recorded at various studios across a four-month period in 1975")
  }
  let (:work_two) {
    Work.create(category: "book", title: "The Opera", creator: "Opera", publication_year: "1995", description: "the Opera 75")
  }

  let (:user_one) {
    User.create(username: "verawang")
  }

  describe "relationships" do
    it "can have many votes" do
      vote_1 = Vote.create(user_id: user_one.id, work_id: work_two.id)
      vote_2 = Vote.create(user_id: user_one.id, work_id: new_work.id)

      expect(user_one.votes.count).must_equal 2
      expect(user_one.votes.first).must_be_instance_of Vote
    end
  end

  describe "validations" do
    it "must have a username" do
      # Arrange
      user_one.username = nil
      # Assert
      expect(user_one.valid?).must_equal false
      expect(user_one.errors.messages).must_include :username
      expect(user_one.errors.messages[:username]).must_equal ["can't be blank"]
    end
  end
end
