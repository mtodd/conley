migration 2, :create_sites  do
  
  up do
    Site.auto_migrate!
  end

  down do
    Site.auto_migrate!
  end
  
end
