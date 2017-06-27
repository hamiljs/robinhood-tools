module Robinhood
  module Tools

    ##
    # A basic Robinhood event
    class Event
      attr_reader :raw, :row

      def initialize(row)
        @raw = @row = row
      end

      def id
        Digest::SHA1.hexdigest [ self.trade_date, self.settle_date, self.symbol, self.description, self.net_amount].join(' '.freeze)
      end

      def type
      	@raw['Type'.freeze]
      end

      def trade_date
      	@trade_date ||= DateTime.parse(@raw['Trade Date'.freeze])
      end

      def settle_date
      	@settle_date ||= DateTime.parse(@raw['Settle Date'.freeze])
      end

      def net_amount
      	@net_amount ||= BigDecimal.new(@raw['Net Amount'.freeze]).abs
      end

      def description
        @raw['Description'.freeze]
      end

      def symbol
      	@raw['Symbol'.freeze]
      end

      def asset
        ASSETS[self.symbol]
      end

    end

  end # Tools
end # Robinhood
