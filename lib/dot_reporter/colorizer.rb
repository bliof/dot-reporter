# frozen_string_literal: true

module DotReporter
  module Colorizer
    COLORS = {
      red: 31,
      green: 32,
      yellow: 33,
      blue: 34,
      magenta: 35,
      cyan: 36,
      white: 37
    }.freeze

    def self.colorize(text, color)
      return text unless COLORS.key?(color)

      "\e[#{COLORS[color]}m#{text}\e[0m"
    end

    def self.red(text) = colorize(text, :red)
    def self.green(text) = colorize(text, :green)
    def self.yellow(text) = colorize(text, :yellow)
    def self.cyan(text) = colorize(text, :cyan)
  end
end
