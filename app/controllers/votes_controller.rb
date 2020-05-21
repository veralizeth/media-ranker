class VotesController < ApplicationController
  
  def create
    @work = Work.find_by(id: params[:work_id])

    if session[:user_id]
      new_vote = { user_id: session[:user_id], work_id: @work.id }
      @vote = Vote.new(new_vote)
      if @vote.save
        flash[:success] = "You Successfully upvoted for #{@work.title}. Thanks!"
        redirect_to works_path
        return
      else
        flash[:error] = "You have already voted for this #{@work.title}. Select another media. "
        redirect_to works_path
        return
      end
    elsif session[:user_id] == nil
      flash.now[:error] = "You should be logged to vote :( "
      redirect_to works_path
    end
  end

  def vote_params
    return params.require(:vote).permit(:user_id, :work_id)
  end
end
