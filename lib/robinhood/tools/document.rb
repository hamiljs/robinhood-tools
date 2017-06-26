module Robinhood
  module Tools

    ##
    # A Robinhood document
    # For ease of processing data from Robinhood
    class Document
      attr_reader :account, :broker, :events, :created_at

      def initialize(account, broker, events, created_at = nil)
        @account = account
        @broker = broker
        @events = events
        @created_at = created_at
      end

      def self.parse(account, broker, file_name)
        # Process file
        events = []
        CSV.foreach(file_name, headers: :first_row) { |row| events << parse_row(row) }

        # Create the new document
        new(account, broker, events, File.ctime(file_name))
      end

      def self.parse_row(row)
        case row['Type']
        when 'MONEY_MOVEMENTS'
          case row['Description']
          when /CASH DIV/i
            Dividend.new(row)
          when /ACH DEPOSIT/i
            Deposit.new(row)
          else
            MoneyMovement.new(row)
          end

        when 'TRADES'
        	case row[Trade::TRADE_ACTION]
        	when Trade::BUY
        		Buy.new(row)
        	when Trade::SELL
        		Sell.new(row)
        	else
      	    Trade.new(row)
      	end

        else
          RobinhoodAction.new(row)
        end
      end

      ##
      # Collect all trade dates from events
      def trade_dates
        @trade_dates ||= @events.map(&:trade_date)
      end

      ##
      # The earliest trade date
      def earliest_trade_date
        @earliest_trade_date ||= self.trade_dates.min
      end

      ##
      # The latest trade date
      def latest_trade_date
        @latest_trade_date ||= self.trade_dates.max
      end

      def validate
        missing_symbols = Set.new(@events.map(&:symbol)) - Set.new(CUSIP.keys)

        if missing_symbols.any?
          puts "Missing symbols: #{ missing_symbols.map(&:to_s).join(' ') }"
        end
      end

      ##
      # Convert document to XML
      def to_xml
        # Build the XML doc
        xml = Builder::XmlMarkup.new
        document = xml.OFX {
          # Sign on Message
          xml << OFX::SignOnMessage.new(self.broker.name, self.broker.fid, self.account.username, self.created_at).to_xml

          # Investment Information
          xml.INVSTMTMSGSRSV1 {
            xml.INVSTMTTRNRS {
              xml.TRNUID 0
              OFX::Status.new(0, 'INFO', 'SUCCESS').to_xml
              xml.INVSTMTRS {
                xml.DTASOF OFX.format_timestamp(self.created_at)
                xml.CURDEF self.account.currency
                xml.INVACCTFROM {
                  xml.BROKERID self.broker.id
                  xml.ACCTID self.account.id
                }
                xml.INVTRANLIST {
                  xml.DTSTART OFX.format_timestamp(self.earliest_trade_date)
                  xml.DTEND OFX.format_timestamp(self.latest_trade_date)

                  # For every action, plug in!
                  self.events.each do |entry|
                    xml << entry.to_xml if entry.respond_to?(:to_xml)
                  end
                }
              }
            }
          }

          # Investment Position List

          # Investment Balance
        }

        # Security List
        xml << OFX::SecurityList.new(CUSIP).to_xml
      end

    end # class Document

  end
end # module Robinhood