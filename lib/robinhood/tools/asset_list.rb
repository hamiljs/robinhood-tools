module Robinhood
  module Tools

    class AssetList < SimpleDelegator

      def initialize(assets = {})
        super(assets)
      end

      def self.parse(filename)
        config = YAML.load_file(filename)['assets']
        assets = {}

        # Load from assets directory
        assets = Dir["./assets/*.yaml"].each_with_object(assets) do |file, memo|
            asset = YAML.load_file(file)
            asset = Asset.new(asset['symbol'], asset['name'], asset['cusip'])
            memo[asset.symbol] = asset
        end

        # Load from config file
        assets = config.each_with_object(assets) do |asset, memo|
          asset = Asset.new(asset['symbol'], asset['name'], asset['cusip'])
          memo[asset.symbol] = asset
        end
        new(assets)
      end
    end

  end
end # module Robinhood