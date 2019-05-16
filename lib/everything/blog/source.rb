require './lib/everything/add_pathname_to_everything_refinement'

module Everything
  class Blog
    module Source
      using Everything::AddPathnameToEverythingRefinement

      class << self
        def absolute_path
          absolute_pathname.to_s
        end

        def absolute_pathname
          Everything.pathname.join(pathname)
        end

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
