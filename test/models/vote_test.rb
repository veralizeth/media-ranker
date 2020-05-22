require "test_helper"

describe Vote do
  let (:work) {
    Work.create(category: "book", title: "The Opera", creator: "Opera", publication_year: "1995", description: "the Opera 75")
  }

  let (:user) {
    User.create(username: "verawang")
  }

  let (:vote_one) {
    Vote.new(user_id: user.id, work_id: work.id)
  }

  describe "relationships" do
    it "can have one user" do
      vote_one.save
      expect(vote_one.user).must_be_instance_of User
    end

    it "can have one work" do
      vote_one.save
      expect(vote_one.work).must_be_instance_of Work
    end
  end
  describe "validations" do
    it "must have a user_id" do
      # Arrange
      vote_one.user_id = nil
      # Assert
      expect(vote_one.valid?).must_equal false
      expect(vote_one.errors.messages).must_include :user_id
      expect(vote_one.errors.messages[:user_id]).must_equal ["can't be blank"]
    end

    it "must have a work_id" do
      # Arrange
      vote_one.work_id = nil
      # Assert
      expect(vote_one.valid?).must_equal false
      expect(vote_one.errors.messages).must_include :work_id
      expect(vote_one.errors.messages[:work_id]).must_equal ["can't be blank"]
    end
  end
end
