module Securities

  class FileCacheAPI

    attr_accessor :api, :cache_directory

    def initialize(api, cache_directory)
      @api = api
      @cache_directory
    end

    def [](query)
      results = self.read_cache(query)
      if results.nil?
        results = @api[query]
        self.write_cache(query, results)
      end
      results
    end

    protected

    def read_cache(query)
      file = self.cache_file(query)
      File.exists?(file) ? File.read(file) : nil
    end

    def write_cache(query, result)
      file = self.cache_file(query)
      File.write(file, result)
    end

    def normalize_query(query)
      query.to_s.upcase.strip
    end

    def cache_file(query)
      query = normalize_query(query)
      File.join(@cache_file, "#{ query }.yaml")
    end

  end

end # Securities