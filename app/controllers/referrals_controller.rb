class ReferralsController < ApplicationController

  skip_before_filter :authenticate_login!

  def create

    unless login_signed_in?
      @referral = Referral.from_token(params[:referrer_token], :session_id=>session[:session_id])
      cookies['referral_token'] = {:value => @referral.referral_token, :expires => 1.month.from_now} if @referral
    end
    redirect_to "#{params[:path]}"
  end
end