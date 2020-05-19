class WorksController < ApplicationController
  def index # Fleshing out our index action.
    @works = Work.all
  end
end
