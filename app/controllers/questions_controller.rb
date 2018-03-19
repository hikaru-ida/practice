class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [:index,
                                              :hashtags,
                                              :hashtags_order_of_popularity,
                                              :order_of_popularity]
  TAG_NUM = 10;

  def index
    @questions = Question.includes(:tags).page(params[:page])
    @tags = Tag.find(Tag.order_of_popularity(TAG_NUM))
    if current_user
      @votes = current_user.votes.pluck(:question_id)
    end
  end

  def new
    @question = Question.new
    #@question.answers.build
    2.times {@question.answers.build}
  end

  def show
    @question = Question.find_by(id:  params[:id])
    if @question
      if view_context.user_signed_in?
        @question_j = @question.create_chart_params
        @comment = @question.comments.build
      end
      vote = current_user.votes.find_by(question_id: @question.id)
      if vote
        @answer = vote.answer.content
      end

      @tags = Tag.find(Tag.order_of_popularity(TAG_NUM))
      @vote = @question.votes.build  # 投票記録
      @comment = @question.comments.build   # コメントフォーム
      url = request.url
      @tweet_url = URI.encode(
        "http://twitter.com/intent/tweet?" +
        "&url=" +
        url +
        "&text=" +
        "質問: " + @question.content
      )
    else
      redirect_to root_path
    end
  end

  def create
    @question = current_user.questions.build(question_params)
    if @question.save
      flash[:notice] = "質問を作成しました"
      redirect_to questions_path
    else
      render :new
    end
  end

  # ハッシュタグごとの質問一覧
  def hashtags
    @tag = Tag.find_by(name: params[:name])
    @tags = Tag.find(Tag.order_of_popularity(TAG_NUM))
    if current_user
      @votes = current_user.votes.pluck(:question_id)
    end
    if @tag
      @questions = @tag.questions.includes(:tags).page(params[:page])
    else
      redirect_to questions_path
    end
  end

  # ハッシュタグごとの質問一覧（投票数順）
  def hashtags_order_of_popularity
    @tag = Tag.find_by(name: params[:name])
    @tags = Tag.find(Tag.order_of_popularity(TAG_NUM))
    if current_user
      @votes = current_user.votes.pluck(:question_id)
    end
    if @tag
      #@questions = Question.find(@tag.questions.joins(:votes).group('votes.question_id').order('count_votes_question_id desc').count('votes.question_id').keys)
      @questions = Kaminari.paginate_array(Question
                                            .unscope(:order)
                                            .unscoped.includes(:tags)
                                            .find(@tag.questions.unscope(:order)
                                              .joins(:votes)
                                              .group('votes.question_id')
                                              .order('count_votes_question_id desc')
                                              .count('votes.question_id')
                                              .keys))
                                            .page(params[:page]).per(18)
    else
      redirect_to questions_path
    end
  end

  # 投票数順の質問一覧
  def order_of_popularity
    #@questions = Question.find(Question.joins(:votes).group(:question_id).order('count_question_id desc').count('question_id').keys)
    @questions = Kaminari.paginate_array(Question
                                          .unscope(:order)
                                          .includes(:tags)
                                          .find(Question.unscope(:order)
                                            .joins(:votes)
                                            .group('votes.question_id')
                                            .order('count_votes_question_id desc')
                                            .count('votes.question_id')
                                            .keys))
                                          .page(params[:page]).per(30)
    @tags = Tag.find(Tag.order_of_popularity(TAG_NUM))
    if current_user
      @votes = current_user.votes.pluck(:question_id)
    end
  end

  private
    def question_params
      params.require(:question).permit(
        :content,
        :description,
        answers_attributes: [:id, :content, :_destroy]
      )
    end
end
