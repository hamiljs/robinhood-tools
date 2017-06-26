module Robinhood
  module Tools

    class Broker
      attr_reader :id, :name, :fid

      def initialize(id, name, fid)
        @id = id
        @name = name
        @fid = fid
      end

      def self.parse(filename)
        config = YAML.load_file(filename)['broker']
        new(config['id'], config['name'], config['fid'])
      end
    end

  end
end # module Robinhood