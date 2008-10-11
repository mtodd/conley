class Sites < Application
  
  provides :json
  
  def index
    case content_type
    when :html
      Site.update_from(Node.active.all)
      @sites = Site.all
      render
    when :json
      display Site.all.to_a.to_json
    end
  end
  
  def create
    unless site = Site.first(:url => params[:url])
      site = Site.new(:url => params[:url])
      site.save
    end
    
    case content_type
    when :html
      redirect('/sites')
    when :json
      render "Created", :status => 201
    end
  end
  
end
