class Nodes < Application
  
  provides :json
  
  def index
    @nodes = Node.active.all
    
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
    Node.detach_and_scan(current_node)
    
    case content_type
    when :html
      redirect(url(:nodes))
    else
      render "OK"
    end
  end
  
  def create
    unless node = Node.first(:address => params[:address])
      node = Node.new(:address => params[:address])
    end
    node.save
    
    # case content_type
    # when :html
    #   render "Created", :status => 201
    # when :json
    #   render "Created", :status => 201
    # end
    render "Created", :status => 201
  end
  
end
