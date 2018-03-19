module VotesHelper

  # ユーザーがその質問に回答済みかどうか
  def answered?(question)
    Vote.exists?(question_id: question.id, user_id: current_user.id)
  end
end
