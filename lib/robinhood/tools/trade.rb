module Robinhood
  module Tools

    ##
    # A trade entry
    class Trade < Event

    	TRADE_ACTION = 'Trade Action'.freeze
    	BUY = 'BUY'.freeze
    	SELL = 'SELL'.freeze

      def quantity
      	@quantity ||= BigDecimal.new(@raw['Qty']).abs
      end

      def trade_action
      	@raw[TRADE_ACTION]
      end

      def price
      	@price ||= BigDecimal.new(@raw['Price'])
      end

      def to_s
        "#{ self.class.name } #{ self.symbol } #{ self.quantity } @ #{ self.price.to_s('F') } = #{ self.net_amount.to_s('F') }"
      end

    end

  end # Tools
end # Robinhood
