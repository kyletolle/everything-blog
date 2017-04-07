module Everything
  module AddPathnameToEverythingRefinement
    refine Everything.singleton_class do
      def pathname
        Pathname.new(path)
      end
    end
  end
end
