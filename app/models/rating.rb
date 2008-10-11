class Rating
  include DataMapper::Resource
  
  ### Properties
  
  property :id, Serial
  property :site_id, Integer
  property :node_id, Integer
  property :rating, Integer
  property :created_at, DateTime
  property :updated_at, DateTime
  
  ### Associations
  
  belongs_to :node
  belongs_to :site
  
  ### Methods
  
  def to_json
    self.attributes.to_json
  end
  
end
