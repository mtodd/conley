class Site
  include DataMapper::Resource
  
  ### Properties
  
  property :id, Serial
  property :url, String
  
  ### Associations
  
  has n, :ratings
  
end
