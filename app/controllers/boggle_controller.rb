require 'json'
class BoggleController < ApplicationController
  def initialize
    @found_words = []
    @all_words = []
    @sequence = []
  end

  def generate
    alphabets = Array('a'..'z')
    @sequence = Array.new(16) { alphabets.sample }.each_slice(4).to_a
    unless params[:sequence].nil?
      @sequence = Array(params[:sequence].split('')).each_slice(4).to_a
    end
    render json: { words: valid_words, sequence: @sequence }
  end

  def valid_words
    @all_words = File.read(Rails.root.join('storage', 'words.txt')).split
    @sequence.each_with_index do |v, i|
      v.each_with_index do |_, j|
        walk(i, j, '')
      end
    end
    @found_words & @all_words
  end

  # move all possible ways i.e. left right up down up-left up-down down-left up-left
  def walk(row, col, word, path = '')
    path += String(row) + String(col)
    if valid_cell(row, col)
      word += @sequence[row][col]
      return unless word_exists(word)

      @found_words.push(word) if word.length > 2
    end

    # move right
    walk(row, col + 1, word, path) if valid_cell(row, col + 1, path)
    # move left
    walk(row, col - 1, word, path) if valid_cell(row, col - 1, path)
    # move down
    walk(row + 1, col, word, path) if valid_cell(row + 1, col, path)
    # move up
    walk(row - 1, col, word, path) if valid_cell(row - 1, col, path)
    # move down-left
    walk(row + 1, col - 1, word, path) if valid_cell(row + 1, col - 1, path)
    # move up-left
    walk(row - 1, col - 1, word, path) if valid_cell(row - 1, col - 1, path)
    # move up-right
    walk(row - 1, col + 1, word, path) if valid_cell(row - 1, col + 1, path)
    # move down-right
    walk(row + 1, col + 1, word, path) if valid_cell(row + 1, col + 1, path)
  end

  def word_exists(prefix)
    @all_words.any? { |word| word.include?(prefix) }
  end

  def valid_cell(row, col, path = nil)
    unless (!path.nil? && path.include?(String(row) + String(col))) || row.negative? || col.negative? || @sequence[row].nil? ||
           @sequence[row][col].nil?
      true
    end
  end

end
