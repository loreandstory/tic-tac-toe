module GameOver
  def self.won_horizontally?(board_arr, piece)
    board_arr.any? do |line|
      line.all? do |spot|
        spot == piece
      end
    end
  end

  def self.transform_array(array)
    # shift array, rows <=> columns; i.e.:
    #   [ [1, 2],       ===>   [ [1, 3],
    #     [3, 4] ]               [2, 4] ]

    transformed_array = Array.new(array[0].size) { Array.new(array.size) }

    array.size.times do |row_num|
      array[row_num].size.times do |col_num|
        transformed_array[col_num][row_num] = array[row_num][col_num]
      end
    end

    transformed_array
  end

  def self.won_vertically?(board_arr, piece)
    xarray = transform_array(board_arr)

    won_horizontally?(xarray, piece)
  end

  def self.diagonals_only(array)
    tl_to_br = []
    tr_to_bl = []

    array.each_with_index do |row, row_num|
      row.each_with_index do |val, col_num|
        # diag tr->bl a[r][c] ==> r - c == 0
        # i.e. taking \ diagonal and making it a straight array.
        tl_to_br << val if row_num - col_num == 0

        # diag tl->br a[r][c] ==> r + c == a.size - 1
        # i.e. taking / diagonal and making it a straight array.
        tr_to_bl << val if row_num + col_num == array.size - 1
      end
    end

    [tl_to_br, tr_to_bl]
  end

  def self.won_diagonally?(board_arr, piece)
    diagonals_only = diagonals_only(board_arr)

    won_horizontally?(diagonals_only, piece)
  end

  def self.player_won?(game)
    [
      won_horizontally?(game[:board], game[:player][:piece]),
      won_vertically?(game[:board], game[:player][:piece]),
      won_diagonally?(game[:board], game[:player][:piece])
    ].any?
  end

  def self.bot_won?(game)
    [
      won_horizontally?(game[:board], game[:bot][:piece]),
      won_vertically?(game[:board], game[:bot][:piece]),
      won_diagonally?(game[:board], game[:bot][:piece])
    ].any?
  end

  # Game_tie? does not check if a win has occurred,
  # only that the board is full -> i.e. all 'X's and 'O's.
  #
  # So, be sure this check comes AFTER checking if the player or bot has won!
  def self.game_tie?(game)
    combined_array = game[:board].flatten

    combined_array.all? do |spot|
      spot =~ /[XO]/
    end
  end
end
