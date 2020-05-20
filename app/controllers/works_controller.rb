class WorksController < ApplicationController
  def index # Fleshing out our index action.
    @works = Work.all
  end

  def show
    # Raise an exception.
    # Be aware that any string will be converted to 0
    work_id = params[:id].to_i
    # It needs to handle this exception.
    @work = Work.find_by(id: work_id)

    if @work.nil?
      head :not_found
      return
    end
  end

  def new
    @work = Work.new
  end

  def create
    @work = Work.new(work_params)

    if @work.save
      flash[:success] = "#{@work.title} was successfully added!"
      redirect_to work_path(@work.id)
      return
    else
      flash.now[:error] = "#{@work.title} was NOT successfully added :( "
      render :new, status: :bad_request
      return
    end
  end

  def edit
    @work = Work.find_by(id: params[:id])

    if @work.nil?
      head :not_found
      return
    end
  end

  def update
    @work = Work.find_by(id: params[:id])
    if @work.nil?
      head :not_found
      return
    elsif @work.update(work_params)
      redirect_to work_path(@work.id)
      return
    else
      render :edit, status: :bad_request
      return
    end
  end

  def destroy
    work_id = params[:id]
    work = Work.find_by(id: work_id)

    if work.nil?
      head :not_found
      return
    end

    work.destroy
    redirect_to works_path
  end

  private

  def work_params
    return params.require(:work).permit(:category, :title, :creator, :publication_year, :description)
  end
end
