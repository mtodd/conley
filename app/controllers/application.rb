class Application < Merb::Controller
  
  before :current_node
  
  def current_node
    address = "#{request.protocol}://#{request.remote_ip}:#{request.port}/"
    unless @current_node ||= Node.first(:address => address)
      @current_node = Node.new(:address => address)
      @current_node.save
    end
    @current_node
  end
  
end
