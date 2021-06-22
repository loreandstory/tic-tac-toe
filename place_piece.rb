# rubocop:disable Metrics/MethodLength
module PlacePiece
  require 'colorize'

  #          board:  [
  #                    ['X', 2, 'O'],
  #                    ['O', 'X', 'O'],
  #                    ['O', 'O', 'X']
  #                  ],

  def self.valid_spot?(string)
    string.match?(/[1-9]/)
  end

  def self.find_spot_index(board_arr, number)
    #              [row, col]
    spot_indexes = [nil, nil]

    board_arr.size.times do |row_num|
      board_arr[row_num].size.times do |col_num|
        if board_arr[row_num][col_num] == number
          spot_indexes[0] = row_num
          spot_indexes[1] = col_num
        end
      end
    end

    spot_indexes # returns [nil, nil] if spot already taken
  end

  # rubocop:disable Metrics/AbcSize
  def self.get_valid_player_choice(game)
    board_arr = game[:board]
    spot_indexes = [nil, nil]

    loop do
      player = game[:turn]
      call_player = ("#{player}!").colorize(game[player][:color])
      print "=> #{call_player} Enter your choice: "
      player_choice = gets.chomp

      if valid_spot?(player_choice)
        spot_indexes = find_spot_index(board_arr, player_choice.to_i)

        if !spot_indexes[0].nil? && !spot_indexes[1].nil?
          break
        else
          print "Spot taken! Please choose another...\n\n"
          next
        end

      else
        print "Not a valid input! Pleae try again...\n\n"
        next
      end
    end

    spot_indexes
  end
  # rubocop:enable Metrics/AbcSize

  def self.place_piece(game, spot_indexes)
    row = spot_indexes[0]
    col = spot_indexes[1]

    whose_turn = game[:turn]
    piece_to_place = game[whose_turn][:piece]

    game[:board][row][col] = piece_to_place
    game[whose_turn][:pieces_left] -= 1
  end
end
# rubocop:enable Metrics/MethodLength
