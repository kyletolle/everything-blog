module Everything
  class Blog
    module Output
      class << self
        def absolute_dir
          Pathname.new(Fastenv.blog_output_path)
        end

        # TODO: Let's create a Templates class that's at the same level as
        # Output, and move this templates_dir functionality there...
        def templates_dir
          Pathname.new(Fastenv.templates_path)
        end
      end
    end
  end
end

