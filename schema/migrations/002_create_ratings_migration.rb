migration 3, :create_ratings  do
  
  up do
    create_table :ratings do
      column :id, Integer, :serial => true
      column :site_id, Integer
      column :node_id, Integer
      column :rating, Integer
      column :created_at, DateTime
      column :updated_at, DateTime
    end
  end
  
  down do
    drop_table :ratings
  end
  
end
