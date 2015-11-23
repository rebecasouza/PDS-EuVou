class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  

#para fazer login por mais de uma rede social
  def facebook
    user = User.from_omniauth(request.env['omniauth.auth'])
    if user.persisted?
      sign_in_and_redirect root_path
    else
      redirect_to user_session_path
    end
  end

end
