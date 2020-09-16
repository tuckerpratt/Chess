# frozen_string_literal: true

# rubocop: disable Layout/LineLength

# Constants and methods for prettier terminal output
module Output
    RED_DISC = "\u{1f534}"
    BLUE_DISC = "\u{1f535}"
  
    COLORS = {
      red: "\e[31m",
      green: "\e[32m",
      yellow: "\e[33m",
      blue: "\e[34m"
    }.freeze
  
    CLEAR_FORMATTING = "\e[0m"
  
    def clear_screen
      print "\e[2J\e[H"
    end
  
    def clear_line_above
      print "\e[1A\e[K"
    end
  
    # Board related
    GRID_WIDTH = 39
    COLUMNS = 8
    ROWS = 8
  
    SQUARE = "\e[47m  \e[0m"
  
    CIRCLED_LETTERS = {
      a: "\u24b6",
      b: "\u24b7",
      c: "\u24b8",
      d: "\u24b9",
      e: "\u24ba",
      f: "\u24bb",
      g: "\u24bc",
      h: "\u24bd"
    }.freeze
  
    COLUMN_HEADINGS = "#{SQUARE}| #{COLORS[:green]}#{CIRCLED_LETTERS.map { |_k, v| v }.join(' ' * 4)}#{CLEAR_FORMATTING}  |#{SQUARE}"
  
    COLUMN_HEADING_DIVIDER = "#{SQUARE}|#{'=' * GRID_WIDTH}|#{SQUARE}"
    ROW_DIVIDER = "#{SQUARE}|#{COLUMNS.times.map { '----' }.join('+')}|#{SQUARE}"
    
  
    def format_row(row)
      row = (grid.reverse)[row].map { |cell| cell == '' ? '  ' : "#{cell.symbol} " }.join(' | ')
      "#{SQUARE}| #{row} |#{SQUARE}"
    end
  end
  # rubocop: enable Layout/LineLength