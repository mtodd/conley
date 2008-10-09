class Node
  include DataMapper::Resource
  
  ### Properties
  
  property :id, Serial
  property :address, String
  
  ### Associations
  
  has n, :ratings
  has n, :sites
  
end
