require 'yaml'

module Robinhood
  module Tools

    class Account
      attr_reader :id, :username, :currency

      def initialize(id, username, currency)
        @id = id
        @username = username
        @currency = currency
      end

      def self.parse(filename)
        config = ::YAML.load_file(filename)['account']
        new(config['id'], config['username'], config['currency'])
      end
    end

  end # Tools
end # Robinhood