module Robinhood
  module Tools

    class Sell < Trade
      def to_xml
        xml = Builder::XmlMarkup.new
        xml.SELLSTOCK {
          xml.INVSELL {
            xml << OFX::InvestmentTransaction.new(self.id, self.trade_date, self.settle_date, self.description).to_xml
            xml << OFX::SecurityID.with_ticker(self.asset.symbol).to_xml
            xml.UNITS (self.quantity * -1).to_s('F')
            xml.UNITPRICE ( self.net_amount / self.quantity ).to_s('F')
            xml.TOTAL self.net_amount.to_s('F')
            xml.SUBACCTSEC 'CASH'
            xml.SUBACCTFUND 'CASH'
          }
          xml.SELLTYPE 'SELL'.freeze
        }
      end
    end

  end # Tools
end # Robinhood
