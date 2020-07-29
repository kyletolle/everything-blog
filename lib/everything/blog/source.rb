module Everything
  class Blog
    module Source
      class << self
        PATH = 'blog'

        def absolute_path
          Everything.path.join(path)
        end

        def path
          Pathname.new(PATH)
        end
      end
    end
  end
end

