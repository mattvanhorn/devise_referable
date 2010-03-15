module DeviseReferable
  module Routes

    protected
      
    def referable(routes, mapping)          
      send(:"referral_landing", 'ref/:referrer_token/*path', {:controller => 'referrals', :action => 'create', :conditions => { :method => :get }})
    end
  end
end

ActionController::Routing::RouteSet::Mapper.send :include, DeviseReferable::Routes
