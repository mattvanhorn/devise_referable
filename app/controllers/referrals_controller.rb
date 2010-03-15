class ReferralsController < ApplicationController

  def create
    unless user_signed_in?
      @referral = Referral.from_token(params[:referrer_token])      
      session[:referral_token] = @referral.referral_token if @referral
    end
    redirect_to "/#{params[:path].join('/')}"
  end

end

