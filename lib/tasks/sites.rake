namespace(:sites) do
  
  desc "Setup some default sites"
  task :default => [:merb_env] do
    %w(
      http://merbivore.com/
      http://github.com/
      http://digg.com/
      http://highgroove.com/
      http://maraby.org/
      http://github.com/mtodd/
      http://xkcd.com/
      http://ruby-doc.org/core/
      http://api.rubyonrails.org/
    ).each do |url|
      unless site = Site.first(:url => url)
        site = Site.new(:url => url)
        site.save
      end
    end
  end
  
end
