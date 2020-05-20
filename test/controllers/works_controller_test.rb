require "test_helper"

describe WorksController do
  describe "index" do
    it "should get index" do
      get "/works"
      must_respond_with :success
    end

    it "can get works_path" do
      get works_path(Work.all)

      must_respond_with :success
    end
  end

  describe "show" do
    before do
      @new_work = Work.create(category: "book", title: "Harry Potter and the Prisoner of Azkaban", creator: "J.K.Rowling", publication_year: "1999", description: "Harry is back at the Dursley's for the summer holidays, where he sees on Muggle television that a convict named Sirius Black has escaped from prison.")
    end

    it "will get show for valid ids" do
      # Arrange
      valid_work_id = @new_work.id

      # Act
      get "/works/#{valid_work_id}"

      # Assert
      must_respond_with :success
    end

    it "will respond with not_found for invalid ids" do
      # Arrange
      invalid_work_id = 999

      # Act
      get "/works/#{invalid_work_id}"

      # Assert
      must_respond_with :not_found
    end
  end

  describe "new" do
    it "can get the new_work_path" do
      get new_work_path

      must_respond_with :success
    end
  end

  describe "create" do
    work_hash = {
      work: {
        category: "book",
        title: "Harry Potter and the Prisoner of Azkaban",
        creator: "J.K.Rowling",
        publication_year: "1999",
        description: "Harry is back at the Dursley's for the summer holidays, where he sees on Muggle television that a convict named Sirius Black has escaped from prison.",
      },
    }

    it "can create a work" do
      expect {
        post works_path, params: work_hash
      }.must_differ "Work.count", 1

      new_work = Work.find_by(title: work_hash[:work][:title])

      expect(new_work.title).must_equal work_hash[:work][:title]
      expect(new_work.creator).must_equal work_hash[:work][:creator]
      expect(new_work.description).must_equal work_hash[:work][:description]

      must_respond_with :redirect
      must_redirect_to work_path(new_work.id)
    end

    it "will not create a work with invalid params" do
      work_hash[:work][:title] = nil

      expect {
        post works_path, params: work_hash
      }.must_differ "Work.count", 0

      must_respond_with :bad_request
    end
  end

  describe "update" do
    before do
      @new_work2 = Work.create(category: "book", title: "Harry Potter and the Prisoner of Azkaban", creator: "J.K.Rowling", publication_year: "1999", description: "Harry is back at the Dursley's for the summer holidays, where he sees on Muggle television that a convict named Sirius Black has escaped from prison.")
    end
    let (:new_work_hash) {
      {
        work: {
          category: "book",
          title: "Harry Potter and the Prisoner of Azkaban",
          creator: "J.K.Rowling",
          publication_year: "1999",
          description: "Another figth with Voldemort",
        },
      }
    }
    it "will update a model with a valid post request" do
      id = @new_work2.id
      expect {
        patch work_path(id), params: new_work_hash
      }.wont_change "Work.count"

      must_respond_with :redirect

      work = Work.find_by(id: id)
      expect(work.title).must_equal work.title
      expect(work.category).must_equal new_work_hash[:work][:category]
    end

    it "will respond with not_found for invalid ids" do
      id = -1

      expect {
        patch work_path(id), params: new_work_hash
      }.wont_change "Work.count"

      must_respond_with :not_found
    end

    it "will not update if the params are invalid" do
      id = @new_work2.id
      new_work_hash[:work][:title] = nil
      work = Work.find_by(id: id)
      expect {
        patch work_path(work.id), params: new_work_hash
      }.wont_change "Work.count"

      work.reload
      must_respond_with :bad_request
      expect(work.title).wont_be_nil
    end
  end
  describe "destroy" do
    it "can delete a work" do
      deleted_work = Work.create category: "movie", title: "The fight club", creator: "David Fincher", publication_year: "1999", description: "It based on many Philosophies. Fight Club is not a film about fighting or violence. it's a narrative about life, and it's about ridding ourselves of the corporate and cultural influences (or perhaps the confluence of the two)that control our lives."
      # Assert
      expect {
        delete work_path(deleted_work.id)
      }.must_differ "Work.count", -1

      must_redirect_to works_path
    end
    it "will respond with redirect when attempting to delete a nonexistant work" do
      expect {
        delete work_path(-1)
      }.must_differ "Work.count", 0

      # Act-Assert
      must_respond_with :not_found
    end
  end
end
