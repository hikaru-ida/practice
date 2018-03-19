class VotesController < ApplicationController
  before_action :authenticate_user!
  def create
    @vote = current_user.votes.build(vote_params)
    if @vote.save
      @vote.answer.increment!(:vote_count)
      flash[:notice] = "#{@vote.answer.content}に投票しました"
      redirect_to question_path(@vote.question.id)
    else
      redirect_to root_path
    end
  end

  private
    def vote_params
      params.require(:vote).permit(:question_id, :answer_id, :comment)
    end

    def correct_user
      @user = User.find(params[:user_id])
      redirect_to(root_url) unless current_user?(@user)
    end
end
