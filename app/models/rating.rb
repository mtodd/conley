class Rating
  include DataMapper::Resource
  
  ### Properties
  
  property :id, Serial
  property :site_id, Integer
  property :node_id, Integer
  property :rating, Integer
  
  ### Associations
  
  belongs_to :node
  belongs_to :site
  
end
