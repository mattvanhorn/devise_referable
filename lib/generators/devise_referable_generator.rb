class DeviseReferableGenerator < Rails::Generators::NamedBase

  desc "Create a route for devise referral tracking"

  def create_initializer_file
    devise_route = "devise_for :#{plural_name} do\n "
    devise_route += %Q(    get "ref/:referrer_token/*path", )
    devise_route += %Q(:controller => 'referrals', :action => 'create', )
    devise_route += %Q(:as=>:referral_landing\n)
    devise_route += "end"
    route devise_route
  end
end
