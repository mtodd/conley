migration 2, :create_sites  do
  
  up do
    create_table :sites do
      column :id, Integer, :serial => true
      column :url, String
      column :created_at, DateTime
      column :updated_at, DateTime
    end
  end

  down do
    drop_table :sites
  end
  
end
