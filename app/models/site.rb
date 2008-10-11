class Site
  include DataMapper::Resource
  
  ### Properties
  
  property :id, Serial
  property :url, String
  property :created_at, DateTime
  property :updated_at, DateTime
  
  ### Associations
  
  has n, :ratings
  # has n, :nodes, :through => Rating
  
  ### Methods
  
  def average_rating
    @average_rating ||= begin
      ratings = 0
      rating = 0.0
      self.query_ratings.each do |rating|
        ratings += 1
        rating += rating.rating
      end
      rating / ratings.to_f
    end
  end
  
  def query_ratings
    Node.active.all.map do |node|
      next if node == Node.current
      node.query_ratings_for(site)
    end.compact
  end
  
  def to_json
    self.attributes.to_json
  end
  
  ### Class Methods
  
  class << self
    
    def update_from(nodes)
      nodes.each do |node|
        next if node == Node.current
        puts node.inspect
        node.query_sites.each do |remote_site|
          unless site = current_node.sites.first(:url => remote_site[:url])
            site = Site.new(:url => remote_site[:url])
            site.save
          end
        end
      end
    end
    
  end
  
end
