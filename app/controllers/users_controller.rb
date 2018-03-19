class UsersController < ApplicationController
  before_action :authenticate_user!, only: [:user_votes, :user_questions]
  before_action :correct_user, only: [:user_votes, :user_questions]

  def associate_with_twitter
    auth = request.env["omniauth.auth"].except("extra")
    current_user.update_attribute(provider: auth["provider"])
    current_user.update_attribute(uid: auth["uid"])
    current_user.update_attribute(image_url: auth["info"]["image"])
  end

  def user_questions
    @user = User.find_by(id: params[:user_id])
    @questions = @user.questions
    @recent_questions = Question.limit(10)
  end

  def user_votes
    @user = User.find_by(id: params[:user_id])
    @recent_questions = Question.limit(10)
    if @user
      @votes = @user.votes.includes([:answer, question: :answers]).page(params[:page])
    else
      redirect_to user_votes_path(current_user)
    end
  end

  def user_comments
    @user = User.find_by(id: params[:user_id])
    @recent_questions = Question.limit(10)
    if @user
      @comments = @user.comments.includes([:answer, :question]).page(params[:page])
    else
      # user_idが存在しないときユーザーのコメントページに飛ばす
      redirect_to user_comments_path(current_user)
    end
  end

  private
    def correct_user
      @user = User.find(params[:user_id])
      redirect_to(root_url) unless current_user?(@user)
    end


end
