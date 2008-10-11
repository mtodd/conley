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
    
  end
end # Sites
