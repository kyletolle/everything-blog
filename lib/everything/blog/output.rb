module Everything
  class Blog
    module Output
      class << self
        def absolute_path
          Fastenv.blog_output_path
        end

        def absolute_pathname
          Pathname.new(absolute_path)
        end
      end
    end
  end
end

