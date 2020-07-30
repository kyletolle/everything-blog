module Everything
  class Blog
    module Output
      class << self
        def absolute_dir
          Pathname.new(Fastenv.blog_output_path)
        end

        def templates_dir
          Pathname.new(Fastenv.templates_path)
        end
      end
    end
  end
end

