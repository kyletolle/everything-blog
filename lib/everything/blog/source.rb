module Everything
  class Blog
    module Source
      class << self
        def path
          'blog'
        end

        def pathname
          Pathname.new(path)
        end
      end
    end
  end
end
