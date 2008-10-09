class Site
  include DataMapper::Resource
  
  ### Properties
  
  property :id, Serial
  property :url, String
  property :created_at, DateTime
  property :updated_at, DateTime
  
  ### Associations
  
  has n, :ratings
  
end
