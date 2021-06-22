module PlayOrder
  # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
  def self.assign_pieces(game)
    pieces = {
      # piece => number of pieces
      'X' => [5, :red],
      'O' => [4, :blue]
    }

    possible_pieces = pieces.keys
    player_piece = possible_pieces.sample

    possible_pieces.delete(player_piece)
    bot_piece = possible_pieces[0]

    game[:player][:piece] = player_piece
    game[:player][:pieces_left] = pieces[player_piece][0]
    game[:player][:color] = pieces[player_piece][1]

    game[:bot][:piece] = bot_piece
    game[:bot][:pieces_left] = pieces[bot_piece][0]
    game[:bot][:color] = pieces[bot_piece][1]

    game[:turn] = if game[:player][:piece] == 'X'
                    :player
                  else
                    :bot
                  end

    nil
  end
  # rubocop:enable Metrics/AbcSize, Metrics/MethodLength

  def self.initialize_play(game)
    game[:board] = [
      [1, 2, 3],
      [4, 5, 6],
      [7, 8, 9]
    ]

    assign_pieces(game)
  end

  def self.toggle_turn(game)
    game[:turn] = if game[:turn] == :player
                    :bot
                  else
                    :player
                  end
  end
end
