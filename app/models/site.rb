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
      total_ratings = 0
      average_rating = 0.0
      self.query_ratings.each do |ratings|
        ratings = [ratings] unless ratings.is_a?(Array)
        ratings.each do |rating|
          total_ratings += 1
          average_rating += rating.rating
        end
      end
      average_rating / total_ratings.to_f
    end
  end
  
  def query_ratings
    Node.active.all.map do |node|
      if node == Node.current
        node.ratings.first(:site_id => self.id)
      else
        node.query_ratings_for(self)
      end
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
        node.query_sites.each do |remote_site|
          unless site = Site.first(:url => remote_site[:url])
            site = Site.new(:url => remote_site[:url])
            site.save
          end
        end
      end
    end
    
  end
  
end
