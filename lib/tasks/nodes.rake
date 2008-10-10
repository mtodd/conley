namespace(:nodes) do
  
  desc "Purge inactive nodes."
  task :purge => [:merb_env] do
    Node.inactive.purge
  end
  
end
