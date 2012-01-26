#module DeviseReferable
#  module Routes
#
#    protected
#
#    def referable(routes, mapping)
#      send(:"referral_landing", 'ref/:referrer_token/*path', {:controller => 'referrals', :action => 'create', :conditions => { :method => :get }})
#    end
#  end
#end
#
##ActionController::Routing::RouteSet::Mapper.send :include, DeviseReferable::Routes
#ActionDispatch::Routing::DeprecatedMapper.send :include, DeviseReferable::Routes
#
#


module DeviseReferable
  module Routes
    module MapperExtensions
      def chain_selects
        @set.add_route('ref/:referrer_token/*path', {:controller => "referrals", :action => "create"})
      end
    end
  end
end

#ActionController::Routing::RouteSet::Mapper.send :include, DeviseReferable::Routes::MapperExtensions