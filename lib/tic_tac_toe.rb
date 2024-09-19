# Player class to handle player details
class Player
  attr_reader :name, :symbol

  def initialize(name, symbol)
    @name = name
    @symbol = symbol
  end
end

# Board class to manage the tic-tac-toe board
class Board
  attr_accessor :grid

  def initialize
    @grid = Array.new(3) { Array.new(3, ' ') }
  end

  def display
    puts "  1 2 3 "
    @grid.each_with_index do |row, index|
      puts "#{index + 1} #{row.join(' | ')}"
      puts "  ---------" unless index == 2
    end
  end

  def update(row, col, symbol)
    @grid[row][col] = symbol
  end

  def valid_move?(row, col)
    row.between?(0, 2) && col.between?(0, 2) && @grid[row][col] == ' '
  end

  def full?
    @grid.flatten.none? { |cell| cell == ' ' }
  end

  def winning_combination?(symbol)\
    rows = @grid.any? { |row| row.all? { |cell| cell == symbol } }
    cols = @grid.transpose.any? { |col| col.all? { |cell| cell == symbol } }
    diag1 = (0..2).all? { |i| @grid[i][i] == symbol }
    diag2 = (0..2).all? { |i| @grid[i][2 - i] == symbol }

    rows || cols || diag1 || diag2
  end
end

# Game class to handle the game logic
class Game
  def initialize
    @board = Board.new
    @players = create_players
    @current_player = @players.first
  end

  def play
    until game_over?
      @board.display
      puts "#{@current_player.name}, it's your turn! Enter row and column numbers (e.g., '1 1'): "
      row, col = gets.chomp.split.map { |i| i.to_i - 1 }

      if @board.valid_move?(row, col)
        @board.update(row, col, @current_player.symbol)

        if winner?
          @board.display
          puts "Congratulations #{@current_player.name}, you won!"
          return
        end

        switch_player
      else
        puts "Invalid move, please try again."
      end
    end

    @board.display
    puts "It's a draw!" if draw?
  end

  private

  def create_players
    puts "Enter the name of Player 1 (X):"
    player1 = Player.new(gets.chomp, 'X')

    puts "Enter the name of Player 2 (O):"
    player2 = Player.new(gets.chomp, 'O')

    [player1, player2]
  end

  def switch_player
    @current_player = @current_player == @players.first ? @players.last : @players.first
  end

  def winner?
    @board.winning_combination?(@current_player.symbol)
  end

  def draw?
    @board.full?
  end

  def game_over?
    winner? || draw?
  end
end

# To start the game, we just need to create a Game instance and call the play method:
Game.new.play
