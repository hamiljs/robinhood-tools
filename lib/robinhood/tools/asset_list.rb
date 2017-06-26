module Robinhood
  module Tools

    class AssetList < SimpleDelegator

      def initialize(assets = {})
        super(assets)
      end

      def self.parse(filename)
        config = YAML.load_file(filename)['assets']
        assets = config.each_with_object({}) do |asset, memo|
          asset = Asset.new(asset['symbol'], asset['name'], asset['cusip'])
          memo[asset.symbol] = asset
        end
        new(assets)
      end
    end

  end
end # module Robinhood