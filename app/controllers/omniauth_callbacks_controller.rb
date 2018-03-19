class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def twitter
    if current_user # すでにログインしているときは更新
      auth = request.env["omniauth.auth"].except("extra")
      # ユーザーが登録済みだったら何もしない
      if User.find_by(provider: auth[:provider], uid: auth[:uid])
        @questions = Question.includes(:tags).page(params[:page])
        @tags = Tag.all
        flash['alert'] = "このtwitterアカウントはすでに使用されています"
        #render 'questions/index'
        redirect_to questions_path
      # ユーザー情報の更新
      else
        current_user.update_attribute('uid', auth[:uid])
        current_user.update_attribute('image_url', auth[:info][:image])
        current_user.update_attribute('provider', auth[:provider])
        redirect_to user_path(current_user)
      end
    # ログイン処理
    else
      @user = User.from_omniauth(request.env["omniauth.auth"].except("extra"),session)
      auth = request.env["omniauth.auth"]
      # ログイン成功
      if @user.persisted?
        sign_in_and_redirect @user
      # ログイン失敗
      else
        session["devise.user_attributes"] = @user.attributes
        redirect_to new_user_registration_url
      end
    end
  end
end
