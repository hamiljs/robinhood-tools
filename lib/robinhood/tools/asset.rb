module Robinhood
  module Tools

    class Asset
      attr_reader :symbol, :name, :cusip, :stock_type, :asset_class, :fi_asset_class

      def initialize(symbol, name, cusip, stock_type = nil, asset_class = nil, fi_asset_class = nil)
        @symbol = symbol
        @name = name
        @cusip = cusip
        @stock_type = stock_type
        @asset_class = asset_class
        @fi_asset_class = fi_asset_class
      end

    end

  end
end # module Robinhood