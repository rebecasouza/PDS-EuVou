class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  

#para fazer login por mais de uma rede social
  def facebook
    auth = env['omniauth.auth']
    @user = User.from_omniauth(request.auth)
    if @user.persisted?
      sign_in_and_redirect root_path
    else
      redirect_to user_session_path
    end
  end

end
