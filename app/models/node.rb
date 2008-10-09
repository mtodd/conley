require 'uri'
require 'net/http'
require 'timeout'

class Node
  include DataMapper::Resource
  
  ADDRESS = %r{http://(\d+)\.(\d+)\.(\d+)\.(\d+):(\d+)/}
  
  ### Properties
  
  property :id, Serial
  property :address, String
  property :last_active_at, DateTime
  property :created_at, DateTime
  property :updated_at, DateTime
  
  ### Associations
  
  has n, :ratings
  has n, :sites
  
  ### Hooks
  
  before :save do
    self.last_active_at = Time.now
  end
  
  ### Class Methods
  
  class << self
    
    def scan(current_node)
      uri = URI.parse(current_node.address)
      if ADDRESS =~ current_node.address
        address_template = "#{uri.scheme}://#{$1}.#{$2}.#{$3}.%i:#{Merb.config[:scan_port]}/"
        path = "nodes"
        params = {:address => current_node.address}
        
        100.upto(120) do |n| # port ranges to test over
          
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
    end
    
  end # class << self
  
end
