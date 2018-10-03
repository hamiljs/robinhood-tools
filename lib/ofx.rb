module OFX

  def self.format_timestamp(datetime)
    # 20170420203539.283[-5:EST]
    datetime.strftime('%Y%m%d%H%M%S.%L[+0:UTC]')
  end

  class SignOnMessage
    attr_reader :org_name, :org_id, :username, :timestamp

    def initialize(org_name, org_id, username, timestamp)
      @org_name = org_name
      @org_id = org_id
      @username = username
      @timestamp = timestamp
    end

    def to_xml
      xml = Builder::XmlMarkup.new
      xml.SIGNONMSGSRSV1 {
        xml.SONRS {
          Status.new(0, 'INFO', 'SUCCESS').to_xml
          xml.DTSERVER OFX.format_timestamp(timestamp)
          xml.LANGUAGE 'ENG'
          xml.DTPROFUP OFX.format_timestamp(timestamp)
          xml.FI {
            xml.ORG org_name
            xml.FID org_id
          }
          xml.tag! "INTU.BID", org_id
          xml.tag! "INTU.USERID", username
        }
      }
    end

  end

  class Status
    attr_reader :code, :severity, :message

    def initialize(code, severity, message)
      @code = code
      @severity = severity
      @message = message
    end

    def to_xml
      xml = Builder::XmlMarkup.new
      xml.STATUS {
        xml.CODE 0
        xml.SEVERITY 'INFO'
        xml.MESSAGE 'SUCCESS'
      }
    end
  end

  class InvestmentTransaction
    attr_reader :id, :trade_date, :settle_date, :memo

    def initialize(id, trade_date, settle_date, memo)
      @id = id
      @trade_date = trade_date
      @settle_date = settle_date
      @memo = memo
    end

    def to_xml
      xml = Builder::XmlMarkup.new
      xml.INVTRAN {
        xml.FITID   self.id
        xml.DTTRADE OFX.format_timestamp(self.trade_date)
        xml.DTSTTLE OFX.format_timestamp(self.settle_date)
        xml.MEMO    self.memo
      }
    end
  end

  class SecurityID
    attr_reader :id, :type

    def initialize(id, type)
      @id = id
      @type = type
    end

    def to_xml
      xml = Builder::XmlMarkup.new
      xml.SECID {
        xml.UNIQUEID     self.id
        xml.UNIQUEIDTYPE self.type
      }
    end

    def self.with_cusip(cusip)
        new(cusip, 'CUSIP'.freeze)
    end

    def self.with_ticker(ticker)
        new(ticker, 'TICKER'.freeze)
    end
  end

end # module QFX

require './lib/ofx/security_list'
