module Chicanery
  module Collections
    %w{server repo site}.each do |entity|
      class_eval <<-EOF
        def #{entity} entity
          #{entity}s << entity
        end

        def #{entity}s
          @#{entity}s ||= []
        end
      EOF
    end
  end
end