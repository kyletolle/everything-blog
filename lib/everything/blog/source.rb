module Everything
  class Blog
    module Source
      class << self
        DIR = 'blog'

        def absolute_dir
          Everything.path.join(dir)
        end

        def dir
          Pathname.new(DIR)
        end
      end
    end
  end
end

