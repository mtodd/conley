require 'uri'
require 'net/http'
require 'timeout'
require 'json'

class Node
  include DataMapper::Resource
  
  ADDRESS = %r{http://(\d+)\.(\d+)\.(\d+)\.(\d+):(\d+)/}
  
  cattr_accessor :current
  
  ### Properties
  
  property :id, Serial
  property :address, String
  property :last_active_at, DateTime
  property :created_at, DateTime
  property :updated_at, DateTime
  
  ### Associations
  
  has n, :ratings
  # has n, :sites, :through => Rating
  
  ### Hooks
  
  before :save do
    self.last_active_at = Time.now
  end
  
  ### Methods
  
  def query_sites
    http = Resourceful::HttpAccessor.new
    response = http.resource(self.address+'sites.json').get
    Merb.logger.debug "Found: #{response.body.inspect}"
    JSON.parse(response.body)
  rescue IOError => e
    []
  end
  
  def query_ratings_for(site)
    http = Resourceful::HttpAccessor.new
    response = http.resource(self.address+"sites/#{Rack::Utils.escape(site.url)}/ratings.json").get
    response = JSON.parse(response.body)
    Merb.logger.debug "Found: #{response.inspect}"
    response
  end
  
  ### Class Methods
  
  class << self
    
    def active
      self.all(:last_active_at.gt => (Time.now - 60*60*1))
    end
    
    def inactive
      self.all(:last_active_at.lt => (Time.now - 60*60*1))
    end
    
    def purge
      self.all.destroy!
    end
    
    # Scan for other nodes on the same network.
    # 
    def scan(current_node, options = {})
      options = {:continual => true}.merge(options)
      uri = URI.parse(current_node.address)
      
      if ADDRESS =~ current_node.address
        address_template = "#{uri.scheme}://#{$1}.#{$2}.#{$3}.%i:#{Merb.config[:scan_port]}/"
        path = "nodes"
        params = {:address => current_node.address}
        
        10.upto(240) do |n| # port ranges to test over
          
          address = address_template % n
          Merb.logger.debug("Scanning #{address}...")
          
          begin
            response = nil
            
            Timeout.timeout(1) do
              response = Net::HTTP.post_form(URI.parse(address+path), params)
            end
            
            if Net::HTTPCreated === response
              Merb.logger.debug("Positive match on #{address}!")
              unless node = Node.first(:address => address)
                node = Node.new(:address => address)
              end
              node.save
            end
          rescue Errno::ECONNREFUSED => e
            Merb.logger.debug("Connection refused to #{address}.")
          rescue Errno::EHOSTUNREACH => e
            Merb.logger.debug("Host unreachable for #{address}.")
          rescue Errno::ETIMEDOUT => e
            Merb.logger.debug("#{address} timed out.")
          rescue Timeout::Error => e
            Merb.logger.debug("Failed to match on #{address}.")
          end
          
        end
      end
      
      if options[:continual]
        sleep 60*5
        self.detach_and_scan(current_node)
      end
    end
    
    def detach_and_scan(current_node)
      Thread.new do
        self.scan(current_node)
      end
    end
    
  end # class << self
  
end
