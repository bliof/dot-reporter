require 'io/console'

module DotReporter
  module Terminal
    def self.width
      IO.console.winsize[1]
    rescue StandardError
      80
    end
  end
end
