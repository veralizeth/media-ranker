require "test_helper"

describe Work do
  let (:new_work) {
    Work.create(category: "album", title: "A Night at the Opera", creator: "Queen", publication_year: "1975", description: "A Night at the Opera was recorded at various studios across a four-month period in 1975")
  }

  let (:user_one) {
    User.create(username: "verawang")
  }

  let (:user_two) {
    User.create(username: "archie")
  }

  describe "relationships" do
    it "can set the vote using a work" do
      work = works(:book_1)
      user = users(:user_1)

      vote = Vote.create(user_id: user.id, work_id: work.id)

      vote.user = user

      #Check that the active record recognizes the relationship
      expect(vote.user_id).must_equal user.id
    end

    it "can have many votes" do
      vote_1 = Vote.create(user_id: user_one.id, work_id: new_work.id)
      vote_2 = Vote.create(user_id: user_two.id, work_id: new_work.id)

      expect(new_work.votes.count).must_equal 2
      expect(new_work.votes.first).must_be_instance_of Vote
    end
  end

  describe "validations" do
    it "must have a title" do
      # Arrange
      new_work.title = nil

      # Assert
      expect(new_work.valid?).must_equal false
      expect(new_work.errors.messages).must_include :title
      expect(new_work.errors.messages[:title]).must_equal ["can't be blank"]
    end

    it "fails validations the title already exists" do
      #Arrange
      new_work2 = Work.new(category: "album", title: "A Night at the Opera")
      # Assert
      expect(new_work2.valid?).must_equal false
    end

    it "must have a publication_year grater than 0 " do
      # Arrange
      new_work.publication_year = 2002

      # Assert
      expect(new_work.valid?).must_equal true
    end

    it "fails if publication_year is not a number" do
      # Arrange
      new_work.publication_year = "adasd"

      # Assert
      expect(new_work.valid?).must_equal false

      expect(new_work.errors.messages[:publication_year]).must_equal ["is not a number"]
    end

    it "fails if publication_year is less than 0 " do
      # Arrange
      new_work.publication_year = -1

      # Assert
      expect(new_work.valid?).must_equal false
      expect(new_work.errors.messages[:publication_year]).must_equal ["must be greater than 0"]
    end

    it " fails if the description is too_long > 200 chars " do
      # Arrange
      # Fake description of 201 a's
      new_work.description = "a" * 201

      # Assert
      expect(new_work.valid?).must_equal false
      expect(new_work.errors.messages[:description]).must_equal ["200 characters is the maximum allowed"]
    end
  end

  describe "Custom model methods" do
    before do
      work1 = Work.create(category: "book", title: "The Opera", creator: "LALA", publication_year: "1935", description: "Night at the Opera")
      work2 = Work.create(category: "movie", title: "The Soer", creator: "Robert Downs", publication_year: "1995", description: "Opera")
      work3 = Work.create(category: "movie", title: "The Soer II", creator: "Robert Downs", publication_year: "2000", description: "Opera II")
    end

    it "can display all_work per category" do
      # Arrange
      movie = Work.all_work("movie")
      movie = Work.all_work("movie")
      book = Work.all_work("book")

      # Act-Assert
      expect(movie.length).must_equal 2
      expect(book.length).must_equal 4

      movie.each do |movie|
        expect(movie.category).must_equal "movie"
      end

      book.each do |book|
        expect(book.category).must_equal "book"
      end
    end

    it "can show top_ten per category" do # //TODO
      # test failling
      # Arrange
      vote_1 = Vote.create(user_id: User.first.id, work_id: Work.first.id)
      vote_2 = Vote.create(user_id: User.second.id, work_id: Work.first.id)
      vote_3 = Vote.create(user_id: User.first.id, work_id: Work.second.id)
      vote_4 = Vote.create(user_id: User.first.id, work_id: Work.last.id)

      top_album = Work.top_ten("album")

      expect(top_album.length).must_equal 2
      expect(top_album[0].votes.count).must_equal 2
    end

    it "spotlight" do
      vote_1 = Vote.create(user_id: User.first.id, work_id: Work.first.id)
      vote_2 = Vote.create(user_id: User.second.id, work_id: Work.first.id)
      vote_3 = Vote.create(user_id: User.first.id, work_id: Work.second.id)
      vote_4 = Vote.create(user_id: User.first.id, work_id: Work.last.id)

      top = Work.spotlight

      expect(top).must_be_instance_of Work
      expect(top.votes.count).must_equal 2
    end
  end
end
