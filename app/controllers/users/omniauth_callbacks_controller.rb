# User/OmniAuth Controller 
class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController

  # CAS Callback.  The user is checked, if the user exists
  # then authentication is performed.
  # While searching for bugs found this documentaiton,
  # adapted for our situation.
  # https://github.com/jonathandixon/hyrax-docker/wiki/Using-CAS-with-Hyrax
  # @author David J. Davis, Jonathan Dixon
  # @return nil or empty if no user exists.
  # @redirect if the user exists it will use devise to sign in and redirect.
  def cas
    # get the username and email from the cas
    u_name = request.env["omniauth.auth"].uid
    u_email = request.env["omniauth.auth"].mail

    # sign in unless the user doesn't exist.
    @user = User.find_by(username: u_name)
    
    unless @user
      redirect_to '/fail', error: I18n.t('login_failure') and return
    end 

    # use devise to actually authenicate the user 
    sign_in_and_redirect @user, event: :authentication
    set_flash_message(:notice, :success, kind: 'CAS') if is_navigational_format?
  end

  # Failure to authenticate redirects to the root path signin screen.
  # @redirect if the user exists it will use devise to sign in and redirect.
  def failure
    redirect_to '/fail', error: I18n.t('login_failure')
  end
end