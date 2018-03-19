class CommentsController < ApplicationController
  before_action :authenticate_user!

  def index
    @comments = Comment.includes([:user, :answer]).where(question_id:params[:question_id]).page(params[:page])
    @question = Question.find_by(id: params[:question_id])
    @comment = @question.comments.build
  end

  def create
    @comment = current_user.comments.build(comment_params)
    # ユーザーが投票したときに選んだ回答
    vote = Vote.find_by(question_id: @comment.question_id, user_id: current_user.id)
    # ユーザが選択したときに選んだ回答の情報を@commentに追加
    if vote && vote.answer_id
      @comment.answer_id = vote.answer_id
    end

    if @comment.save
      # コメントをツイートする
      if params['tweet_button'] == "tweet"
        info = "\n\n#goiken " + request.url.gsub("/comments","")
        TwitterAPI.new(session).update(@comment.content+info)
      end
      flash['notice'] = 'コメントしました'
      redirect_to comments_path(@comment.question.id)
    else
      flash.now['alert'] = 'コメントの投稿に失敗しました'
      @question = Question.find_by(id: @comment.question_id)
      #@comments = Comment.where(question_id:params[:question_id])
      @comments = Comment.includes([:user, :answer]).where(question_id:params[:question_id]).page(params[:page])
      render :index
    end
  end

  private
    def comment_params
      params.require(:comment).permit(:question_id, :content)
    end

    def correct_user
      @user = User.find(params[:user_id])
      redirect_to(root_url) unless current_user?(@user)
    end

end
