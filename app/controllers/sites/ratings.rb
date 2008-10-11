class Sites < Application
  class Ratings < Application
    
    provides :json
    
    def index
      unless site = Site.first(:id => params[:site_id]) or Site.first(:url => params[:site_id])
        site = Site.new(:url => params[:site_id])
        site.save
      end
      
      @ratings = site.ratings
      
      case content_type
      when :html
        render
      when :json
        render @ratings.to_a.to_json
      end
    end
    
    def create
      site = Site.first(:id => params[:site_id])
      unless rating = Rating.first(:site_id => params[:site_id], :node_id => current_node.id)
        rating = Rating.new(:site_id => params[:site_id], :node_id => current_node.id, :rating => params[:rating])
        rating.save
      end
      
      case content_type
      when :html
        redirect(url(:sites))
      when :json
        render "Created", :status => 201
      end
    end
    
  end
end # Sites
