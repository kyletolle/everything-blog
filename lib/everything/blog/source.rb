module Everything
  class Blog
    module Source
      class << self
        PATH = 'blog'

        def absolute_path
          absolute_pathname.to_s
        end

        # TODO: Just make absolute_path a Pathname.
        def absolute_pathname
          Everything.path.join(path)
        end

        def path
          PATH
        end

        # TODO: Just make path a Pathname.
        def pathname
          Pathname.new(path)
        end
      end
    end
  end
end

