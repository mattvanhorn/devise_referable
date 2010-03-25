class ReferralsController < ApplicationController

  def create
    
    unless user_signed_in?
      @referral = Referral.from_token(params[:referrer_token])      
      cookies['referral_token'] = {:value => @referral.referral_token, :expires => 1.month.from_now} if @referral
    end
    redirect_to "/#{params[:path].join('/')}"
  end
  
end
