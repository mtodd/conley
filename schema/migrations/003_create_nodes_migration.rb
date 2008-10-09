migration 4, :create_nodes  do
  
  up do
    Node.auto_migrate!
  end
  
  down do
    Node.auto_migrate!
  end
  
end
