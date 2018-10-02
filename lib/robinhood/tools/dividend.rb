module Robinhood
  module Tools

    class Dividend < MoneyMovement
      def to_xml
        xml = Builder::XmlMarkup.new
        xml.INCOME {
          xml << OFX::InvestmentTransaction.new(self.id, self.trade_date, self.settle_date, self.description).to_xml
          xml << OFX::SecurityID.new(self.asset.cusip, 'CUSIP').to_xml
          xml.INCOMETYPE 'DIV'
          xml.TOTAL self.net_amount.to_s('F')
          xml.SUBACCTSEC 'CASH'
          xml.SUBACCTFUND 'CASH'
        }
      end
    end

  end # Tools
end # Robinhood
