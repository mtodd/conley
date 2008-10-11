namespace(:nodes) do
  
  desc "Purge inactive nodes."
  task :purge => [:merb_env] do
    Node.inactive.purge
  end
  
  desc "Scan for nodes"
  task :scan => [:merb_env] do
    # the first node is usually the application since it creates the node when
    # a request is first handled (most won't run this before starting the app)
    Node.detach_and_scan(Node.first)
  end
  
end
