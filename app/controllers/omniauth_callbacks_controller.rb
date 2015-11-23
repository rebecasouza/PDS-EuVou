class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  

#para fazer login por mais de uma rede social
  def facebook
    @user = User.from_omniauth(request.env['omniauth.auth'])
    sign_in_and_redurect user, notice: 'Login efetuado com sucesso'
  end

end
