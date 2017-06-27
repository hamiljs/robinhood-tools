require 'nokogiri'
require 'open-uri'

module CUSIP

  def self.lookup(ticker)
    # Format and prepare
    ticker = ticker.strip.upcase

    # Download
    uri = "http://www.quantumonline.com/search.cfm?tickersymbol=#{ ticker }&sopt=symbol"
    doc = Nokogiri::HTML(open(uri)) do |config|
      config.nonet
    end

    # Get asset name
    name = doc.xpath('/html/body/font/table/tr/td[2]/center/b/text()')[0].to_s

    # Get the ASSETS
    cusip = doc.xpath('/html/body/font/table/tr/td[2]/center/b/text()')[1].to_s
    if /ASSETS:\s*([A-Za-z0-9]{9})/ =~ cusip
      cusip = $1
    end

    # Compile and return response
    {
      name: name.strip,
      cusip: cusip.strip.upcase,
      ticker: ticker
    }

  end

end # ASSETS