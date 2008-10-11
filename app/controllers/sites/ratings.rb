class Sites < Application
  class Ratings < Application
    
    provides :json
    
    def index
      if params[:site_id] == 0 and params[:url]
        if site = Site.first(:url => params[:url])
          site = Site.new(:url => params[:url])
          site.save
        end
      else
        site = Site.get(params[:site_id])
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
