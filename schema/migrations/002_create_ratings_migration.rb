migration 3, :create_ratings  do
  
  up do
    Rating.auto_migrate!
  end
  
  down do
    Rating.auto_migrate!
  end
  
end
