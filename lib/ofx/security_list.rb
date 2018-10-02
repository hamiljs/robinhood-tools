module OFX

  class SecurityList
    attr_reader :securities

    def initialize(securities)
      @securities = securities
    end

    def to_xml
      xml = Builder::XmlMarkup.new
      xml.SECLISTMSGSRSV1 {
        xml.SECLIST {
          @securities.each do |_, asset|
            xml.STOCKINFO {
              xml.SECINFO {
                xml << OFX::SecurityID.new(asset.cusip, 'CUSIP').to_xml
                xml.SECNAME asset.name
                xml.TICKER asset.symbol
                # UNITPRICE
                # DTASOF
              }
              xml.STOCKTYPE asset.stock_type || 'COMMON'
              xml.ASSETCLASS asset.asset_class || 'LARGESTOCK'
              xml.FIASSETCLASS asset.fi_asset_class || 'COMMON STOCK'.freeze
            }
          end
        }
      }
    end

  end # SecurityList

end # OFX