class UserMailer < ActionMailer::Base

  def welcome

    @user = current_user

    mail(to: @user.email, subject: "Welcome to Specright", bcc: "admin@specright.co.uk", from: "andrew@specright.co.uk" ) do |format|
      format.text
    end

  end

end