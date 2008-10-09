class Nodes < Application
  
  provides :json
  
  def index
    @nodes = Node.all
    
    case content_type
    when :html
      render
    when :json
      display @nodes
    end
  end
  
  # Begin scanning for other nodes.
  # 
  def scan
    @scanner = Thread.new do
      Node.scan(current_node)
    end
    
    case content_type
    when :html
      redirect(url(:nodes))
    else
      render "OK"
    end
  end
  
  def create
    puts request.inspect
    
    # case content_type
    # when :html
    #   render "Created", :status => 201
    # when :json
    #   render "Created", :status => 201
    # end
    render "Created", :status => 201
  end
  
end
