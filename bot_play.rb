# rubocop:disable  Metrics/ModuleLength
module BotPlay
  $LOAD_PATH << '.'

  require 'game_over'
  require 'place_piece'
  require 'colorize'

  def self.board_empty?(board_arr)
    flattened_array = board_arr.flatten

    flattened_array.all? do |spot|
      spot.to_s =~ /[1-9]/
    end
  end

  def self.board_empty_randomly_place_piece(game)
    spot_to_play = [rand(0..2), rand(0..2)]
    spot_picked = game[:board][spot_to_play[0]][spot_to_play[1]]

    PlacePiece.place_piece(game, spot_to_play)
    spot_picked
  end

  def self.find_empty_spot_values(board_arr)
    flattened_array = board_arr.flatten

    flattened_array.select do |spot|
      spot.instance_of?(Integer)
    end
  end

  def self.one_spot_left?(board_arr)
    empty_spots_values = find_empty_spot_values(board_arr)

    empty_spots_values.size == 1
  end

  def self.place_piece_final_spot(game)
    empty_spot_value = find_empty_spot_values(game[:board])[0]
    final_spot_index = PlacePiece.find_spot_index(game[:board],
                                                  empty_spot_value)

    spot_picked = game[:board][final_spot_index[0]][final_spot_index[1]]

    PlacePiece.place_piece(game, final_spot_index)
    spot_picked
  end

  def self.duplicate_game(game)
    dup_board = []
    game[:board].each do |row|
      dup_board << row.dup
    end

    {
      board: dup_board,
      player: game[:player].dup,
      bot: game[:bot].dup,
      turn: game[:turn],
      winner: game[:winner]
    }.dup
  end

  def self.play_to_win_returnindexes(game)
    empty_spots_values = find_empty_spot_values(game[:board])
    spot_indexes = [nil, nil]

    empty_spots_values.each do |value|
      dup_game = duplicate_game(game)

      selected_index = PlacePiece.find_spot_index(dup_game[:board], value)
      PlacePiece.place_piece(dup_game, selected_index)

      if GameOver.bot_won?(dup_game)
        spot_indexes = selected_index
        break
      end
    end

    spot_indexes
  end

  def self.avoid_losing_returnindexes(game)
    empty_spots_values = find_empty_spot_values(game[:board])
    spot_indexes = [nil, nil]

    empty_spots_values.each do |value|
      dup_game = duplicate_game(game)
      dup_game[:turn] = :player

      selected_index = PlacePiece.find_spot_index(dup_game[:board], value)
      PlacePiece.place_piece(dup_game, selected_index)

      if GameOver.player_won?(dup_game)
        spot_indexes = selected_index
        break
      end
    end

    spot_indexes
  end

  def self.randomly_place_piece(game)
    empty_spots_values = find_empty_spot_values(game[:board])
    randomly_chosen_val = empty_spots_values.sample

    chosen_index = PlacePiece.find_spot_index(game[:board], randomly_chosen_val)

    spot_picked = game[:board][chosen_index[0]][chosen_index[1]]

    PlacePiece.place_piece(game, chosen_index)
    spot_picked
  end

  # rubocop:disable  Metrics/AbcSize
  def self.bot_ai_place_piece(game)
    will_win_indexes = play_to_win_returnindexes(game)
    avoid_losing_indexes = avoid_losing_returnindexes(game)

    if !will_win_indexes[0].nil? && !will_win_indexes[1].nil?
      spot_picked = game[:board][will_win_indexes[0]][will_win_indexes[1]]
      PlacePiece.place_piece(game, will_win_indexes)
      spot_picked

    elsif !avoid_losing_indexes[0].nil? && !avoid_losing_indexes[1].nil?
      # rubocop:disable Layout/LineLength
      spot_picked = game[:board][avoid_losing_indexes[0]][avoid_losing_indexes[1]]
      # rubocop:enable Layout/LineLength

      PlacePiece.place_piece(game, avoid_losing_indexes)
      spot_picked

    else
      randomly_place_piece(game)
    end
  end
  # rubocop:enable  Metrics/AbcSize

  def self.bot_play(game)
    bot = game[:turn]
    bot_color = game[bot][:color]

    bot_played_at = if board_empty?(game)
                      board_empty_randomly_place_piece(game)
                    elsif one_spot_left?(game[:board])
                      place_piece_final_spot(game)
                    else
                      bot_ai_place_piece(game)
                    end

    puts "=> #{bot.to_s.colorize(bot_color)} chose: #{bot_played_at}"
  end
end
# rubocop:enable  Metrics/ModuleLength
