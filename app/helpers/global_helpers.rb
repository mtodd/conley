module Merb
  module GlobalHelpers
    
    def colorize_rating(rating, label)
      color = case rating
      when (0.0..0.45)
        '#f00'
      when (0.45..0.65)
        '#444'
      when (0.65..1.0)
        '#0f0'
      end
      
      %(<span style="color:#{color}">#{label}</span>)
    end
    
  end
end
