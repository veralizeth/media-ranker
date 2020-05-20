require "test_helper"

describe Work do
  let (:new_work) {
    Work.new(category: "album", title: "A Night at the Opera", creator: "Queen", publication_year: "1975", description: "A Night at the Opera was recorded at various studios across a four-month period in 1975")
  }
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
end
