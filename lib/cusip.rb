require 'nokogiri'
require 'open-uri'

module CUSIP

  def self.lookup(ticker)
    # Format and prepare
    ticker = ticker.strip.upcase

    # Download
    uri = "http://www.quantumonline.com/search.cfm?tickersymbol=#{ ticker }&sopt=symbol"
    puts uri
    doc = Nokogiri::HTML(open(uri)) do |config|
      config.nonet
    end

    # Get asset name
    name = doc.xpath("//table/tbody/tr/td/font[@size='+1']/center/b") #.first

    # Get the CUSIP
    # cusip = doc.xpath("//table/tbody/tr/td/font[@size='-1']/center/b")

    # Compile and return response
    {
      name: name.strip,
      cusip: cusip.strip,
      ticker: ticker
    }

  end

end # CUSIP