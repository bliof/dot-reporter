# frozen_string_literal: true

module DotReporter
  class Formatter
    BRAILLE_BASE = 0x2800
    BRAILLE_MAP = [0x1, 0x2, 0x4, 0x40, 0x8, 0x10, 0x20, 0x80].freeze # 1, 2, 3, 7, 4, 5, 6, 8 (dots)
    # Braille pattern numbering:
    # 1 4
    # 2 5
    # 3 6
    # 7 8

    # We map our 8 test results to these positions in order.
    # 1st test -> dot 1 (top left)
    # 2nd test -> dot 2 (mid left)
    # 3rd test -> dot 3 (bot left)
    # 4th test -> dot 7 (bot-bot left)
    # 5th test -> dot 4 (top right)
    # 6th test -> dot 5 (mid right)
    # 7th test -> dot 6 (bot right)
    # 8th test -> dot 8 (bot-bot right)

    attr_reader :output

    def initialize(output)
      @output = output
      @buffer = []
      @current_line_tests = 0
      @total_tests = 0
      @passed_count = 0
      @failed_count = 0
      @pending_count = 0
      @start_time = Time.now

      @current_line_passed = 0

      # Handle resize
      @terminal_width = Terminal.width

      # We need a way to trap signals, but formatters might not own the process.
      # RSpec/Minitest might not like us trapping signals globally.
      # But standard practice for progress bars is to handle SIGWINCH.
      begin
        Signal.trap('WINCH') do
          @terminal_width = Terminal.width
          refresh_current_line
        end
      rescue ArgumentError
        # Windows or other environments might not support SIGWINCH
      end
    end

    def start(count)
      @total_count = count
      # Hide cursor? "\e[?25l"
    end

    def close
      flush_buffer(force: true)
      @output.puts # Newline after progress
      print_summary
    end

    def example_passed
      @buffer << :passed
      @passed_count += 1
      @total_tests += 1
      @current_line_passed ||= 0
      @current_line_passed += 1
      @current_line_tests += 1

      flush_and_print
    end

    def example_failed
      @buffer << :failed
      @failed_count += 1
      @total_tests += 1
      @current_line_tests += 1

      flush_and_print
    end

    def example_pending
      @buffer << :pending
      @pending_count += 1
      @total_tests += 1
      @current_line_tests += 1

      flush_and_print
    end

    private

    def refresh_current_line
      # Calculate available width for dots
      # Status length approx 20 chars.
      status = " | #{status_text}"
      available_width = @terminal_width - status.length - 1

      # If we just filled a char, we might have exceeded the width.
      # We need to track how many chars we have printed on THIS line.

      # Ideally we use a buffer for the current line's Braille characters.

      # Initialize @line_buffer if nil
      @line_buffer ||= ''

      # Construct the current partial char from @buffer
      partial_char = ''
      unless @buffer.empty?
        char_code = BRAILLE_BASE
        has_failure = false
        @buffer.each_with_index do |result, index|
          char_code += BRAILLE_MAP[index]
          has_failure = true if result == :failed
        end
        raw_char = [char_code].pack('U')
        partial_char = has_failure ? Colorizer.red(raw_char) : Colorizer.green(raw_char)
      end

      # Check if we need to wrap
      # Visible length of line buffer (excluding ANSI codes)
      visible_length = uncolorize(@line_buffer).length

      if visible_length >= available_width
        # Line is full.
        # Clear the line, print the line buffer without status, then newline.
        @output.print "\r#{@line_buffer}#{' ' * status.length}\n"
        @line_buffer = ''
        @current_line_tests = @buffer.size # Reset count for new line
        @current_line_passed = 0
      end

      # Print current line state
      @output.print "\r#{@line_buffer}#{partial_char}#{status}"
    end

    def status_text
      # "✓ 40/48 passed"
      # passed on this line? or total?
      # PRD: "At the end of the line it should show how many tests are successful from all the tests on the line so far."

      # So we need to track passed tests on the current line.
      # We reset @current_line_tests when we wrap.
      # But wait, @current_line_tests includes failed too.
      # We need passed count on current line.

      # Let's track @current_line_passed.

      pct = @current_line_passed || 0
      tot = @current_line_tests || 0

      # Also PRD shows "✓ 40/48 passed".
      # 40 passed out of 48 total on this line.

      "✓ #{pct}/#{tot} passed"
    end

    # Overriding example hooks to update line stats
    def update_line_stats(result)
      @current_line_passed ||= 0
      @current_line_passed += 1 if result == :passed
    end

    def uncolorize(text)
      text.gsub(/\e\[\d+m/, '')
    end

    # We need to hook into example_passed/failed/pending to update @line_buffer when flushing

    def flush_buffer(force: false)
      return if @buffer.empty? && !force

      char_code = BRAILLE_BASE
      has_failure = false
      @buffer.each_with_index do |result, index|
        if result
          char_code += BRAILLE_MAP[index]
          has_failure = true if result == :failed
        end
      end

      char = [char_code].pack('U')
      colored_char = has_failure ? Colorizer.red(char) : Colorizer.green(char)

      @line_buffer ||= ''
      @line_buffer += colored_char

      @buffer = []
    end

    def flush_and_print
      flush_buffer if @buffer.size == 8
      print_status
    end

    def print_status
      refresh_current_line
    end

    def print_summary
      duration = Time.now - @start_time
      pass_rate = @total_tests.positive? ? ((@passed_count.to_f / @total_tests) * 100).round(1) : 0

      summary = <<~SUMMARY

        ╔════════════════════════════════════════╗
        ║   Dot Reporter Summary                 ║
        ╠════════════════════════════════════════╣
        ║ Total Tests:       #{@total_tests.to_s.ljust(20)}║
        ║ ✓ Passed:         #{@passed_count.to_s.ljust(21)}║
        ║ ✗ Failed:         #{@failed_count.to_s.ljust(21)}║
        ║ ⊘ Skipped:        #{@pending_count.to_s.ljust(20)}║
        ╠════════════════════════════════════════╣
        ║ Duration:         #{"#{duration.round(2)}s".ljust(21)}║
        ║ Pass Rate:        #{"#{pass_rate}%".ljust(21)}║
        ╚════════════════════════════════════════╝
      SUMMARY

      @output.puts summary
    end
  end
end
