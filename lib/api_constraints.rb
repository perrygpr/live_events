# Constraint indicates if the client wants anything besides the default version
# of the the API (in this case v1) the game client can send an Accept header 
# indicating that

class ApiConstraints
  def initialize(options)
    @version = options[:version]
    @default = options[:default]
  end

  def matches?(req)
    @default || req.headers['Accept'].include?("application/vnd.PFLiveEvents.v#{@version}")
  end
end