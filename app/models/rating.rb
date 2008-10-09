class Rating
  include DataMapper::Resource
  
  ### Properties
  
  property :id, Serial
  property :site_id, Integer
  property :rating, Integer
  property :node_id, Integer
  
  ### Associations
  
  
  
end
