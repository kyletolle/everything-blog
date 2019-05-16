module Everything
  class Blog
    module Output
      class << self
        def absolute_path
          absolute_pathname.to_s
        end

        def absolute_pathname
          Pathname.new(Fastenv.blog_output_path)
        end
      end
    end
  end
end

