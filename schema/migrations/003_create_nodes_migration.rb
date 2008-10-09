migration 4, :create_nodes  do
  
  up do
    create_table :nodes do
      column :id, Integer, :serial => true
      column :address, String
      column :last_active_at, DateTime
      column :created_at, DateTime
      column :updated_at, DateTime
    end
  end
  
  down do
    drop_table :nodes
  end
  
end
