# Ruby Assignment Code Skeleton
# Nigel Ward, University of Texas at El Paso
# April 2015, April 2019
# borrowing liberally from Gregory Brown's tic-tac-toe game

#------------------------------------------------------------------
class Board
  def initialize
    @board = Array[[nil,nil,nil,nil,nil,nil,nil],
              [nil,nil,nil,nil,nil,nil,nil],
              [nil,nil,nil,nil,nil,nil,nil],
              [nil,nil,nil,nil,nil,nil,nil],
              [nil,nil,nil,nil,nil,nil,nil],
              [nil,nil,nil,nil,nil,nil,nil] ]
  end

  # process a sequence of moves, each just a column number
  def addDiscs(firstPlayer, moves)
    if firstPlayer == :R
      players = [:R, :O].cycle
    else
      players = [:O, :R].cycle
    end
    moves.each {|c| addDisc(players.next, c)}
  end

  def addDisc(player, column)
    if column >= 7 || column < 0
      puts "  addDisc(#{player},#{column}): out of bounds; move forfeit"
    end
    firstFreeRow =  @board.transpose.slice(column).rindex(nil)
    
    if firstFreeRow == nil
      puts "  addDisc(#{player},#{column}): column full already; move forfeit"
    end
    update(firstFreeRow, column, player)
  end

  def update(row, col, player)
    @board[row][col] = player
  end

  def print
    puts @board.map {|row| row.map { |e| e || " "}.join("|")}.join("\n")
    puts "\n"
  end

  def hasWon? (player)
    return verticalWin?(player)| horizontalWin?(player) |
           diagonalUpWin?(player)| diagonalDownWin?(player)
  end

  def verticalWin? (player)
    (0..6).any? {|c| (0..2).any? {|r| fourFromTowards?(player, r, c, 1, 0)}}
  end

  def horizontalWin? (player)
    (0..3).any? {|c| (0..5).any? {|r| fourFromTowards?(player, r, c, 0, 1)}}
  end

  def diagonalUpWin? (player)
    (0..3).any? {|c| (0..2).any? {|r| fourFromTowards?(player, r, c, 1, 1)}}
  end

  def diagonalDownWin? (player)
    (0..3).any? {|c| (3..5).any? {|r| fourFromTowards?(player, r, c, -1, 1)}}
  end

  def fourFromTowards?(player, r, c, dx, dy)
    return (0..3).all?{|step| @board[r+step*dx][c+step*dy] == player}
  end

end # Board
#------------------------------------------------------------------

def robotMove(player, board)# stub
  win = nil
  win = checkHorWin(player,board)
  if win != nil
    return win
  end
  
  win = checkVertWin(player,board)
  if win != nil
    return win

  end
win = checkDiagonalWin(player,board)
  if win != nil
    return win
  end
  
  win = checkOppHorWin(player,board)
  if win != nil
    return win
  end
  
  #checkOppVertWin(player,board)
  #return rand(7)
end

def Hor3InRow(board, cord, player)
 
  row = cord[0]
  col = cord[1]
  #puts board[row][col+1]
  #puts board[row][col+2]
  if board[row][col+1] != player
    return false
  end
  if board[row][col+2] != player
    return false
  end
  
  puts "Returning true"
  return true
end
#Following methods do as the name intends
def checkHorWin(player,board)
  start = nil
  
  copy = board.instance_variable_get(:@board)
  copy.each_with_index do |row,index|
    start = [index,row.index(player)]
    if start[1] != nil
      
      #CHeck if we got 3 in a row to work with
      if Hor3InRow(copy,start,player)
        #Is the space behind me in bound and open
        backspace = start[1] - 1
        if backspace > 0
          #is it open
          if copy[index][backspace] != :O
            board.addDisc(player,backspace)
            return backspace
          end
        end
          front = start[1] + 3
          if front < 8
            if copy[index][front] != :O
              board.addDisc(player,front)
              return front
            end
          end
        
      
      end
    end
  end
  return nil
end


def checkVertWin(player, board)
  #Tranpose array, to check columns, since they are now left to right, we can
  #basically use the same stuff as a horizontal win, check left to right.
  copy = board.instance_variable_get(:@board)
  copy = copy.transpose
  copy.each_with_index do |row,index|
    start = [index,row.index(player)]
    if start[1] != nil
      
      #Check if we got 3 in a row to work with
      if Hor3InRow(copy,start,player)
        #Is the space above me in bound and open
        above = start[1] - 1
        if above > 0
          #is it open
          if copy[above][start[1]] != :O
            board.addDisc(player,start[1])
            return start[1]
          end
          
      end
      end
    end
      


    
  end
return nil
end
#check if we have 3 in a row, and if we said area has an empty above and has a token below
def check3inDiagonal(board,cord,player)
  row = cord[0]
  col = cord[1]
  #puts row
  #puts col
  if (row-2)>-1 && (col+2)<7
  #puts board[row-1][col+1]
  #puts board[row-2][col+2]
  if board[row-1][col+1] == player && board[row-2][col+2] != :O
    if board[row][col+1] != nil && board[row-1][col+2] != nil
      return 1

    end
  end
  end
  if (row-2)>-1 && (col-2)>-1
if board[row-1][col-1] == player && board[row-2][col-2] != :O
    if board[row][col-1] != nil && board[row-1][col-2] != nil
      return 0

    end
  end
  end
  
  #puts "Returning false"
  return false
end

def checkDiagonalWin(player,board)
copy = board.instance_variable_get(:@board)
copy.each_with_index do |row,row_index|
  row.each_with_index do |col,col_index|
   # puts col
    if col == player
      start = [row_index,col_index]
    
    
   
      
      #CHeck if we got 3 in a row to work with
      placement = check3inDiagonal(copy,start,player)
      #puts "Here is placement"
      #puts placement
      

      if placement == 0
        board.addDisc(player,start[1]-2)
        return start[1]-2
      end

      if placement == 1
        board.addDisc(player,start[1]+2)
        return start[1]+2
      end
      
    end
  end
end
return nil
end

def checkOppHorWin(player, board)
start = nil
  
  copy = board.instance_variable_get(:@board)
  copy.each_with_index do |row,index|
    start = [index,row.index(:O)]
    
    if start[1] != nil
      
      #CHeck if we got 3 in a row to work with
      if Hor3InRow(copy,start,:O)
        #Is the space behind me in bound and open
        backspace = start[1] - 1
        
        if backspace >= 0
          #is it open
          if copy[index][backspace] != :O
            board.addDisc(player,backspace)
            return backspace
          end
        end
          front = start[1] + 3
          if front < 8
            if copy[index][front] != :O
              board.addDisc(player,front)
              return front
            end
          end
        
      end
      
    end
  end
  return nil
end





def checkOppVertWin(player, board)

  #Tranpose array, to check columns, since they are now left to right, we can
  #basically use the same stuff as a horizontal win, check left to right.
  copy = board.instance_variable_get(:@board)
  copy = copy.transpose
  copy.each_with_index do |row,index|
    start = [index,row.index(:O)]
    if start[1] != nil
      
      #Check if we got 3 in a row to work with
      if Hor3InRow(copy,start,:O)
        #Is the space above me in bound and open
        above = start[1] - 1
        if above > 0
          #is it open
          if copy[above][start[1]] != :O
            board.addDisc(player,start[1])
            return start[1]
          end
          
      end
      end
    end
      


    
  end
return nil
end





#------------------------------------------------------------------
def testResult(testID, move, targets, intent)
  if targets.member?(move)
    puts("testResult: passed test #{testID}")
  else
    puts("testResult: failed test #{testID}: \n moved to #{move}, which wasn't one of #{targets}; \n failed: #{intent}")
  end
end


#------------------------------------------------------------------
# test some robot-player behaviors
testboard1 = Board.new
testboard1.addDisc(:R,4)
testboard1.addDisc(:O,4)
testboard1.addDisc(:R,5)
testboard1.addDisc(:O,5)
testboard1.addDisc(:R,6)
testboard1.addDisc(:O,6)
testResult(:hwin, robotMove(:R, testboard1),[3], 'robot should take horizontal win')
testboard1.print

testboard2 = Board.new
testboard2.addDiscs(:R, [3, 1, 3, 2, 3, 4]);
testResult(:vwin, robotMove(:R, testboard2), [3], 'robot should take vertical win')
testboard2.print

testboard3 = Board.new
testboard3.addDiscs(:O, [3, 1, 4, 5, 2, 1, 6, 0, 3, 4, 5, 3, 2, 2, 6 ]);
testResult(:dwin, robotMove(:R, testboard3), [3], 'robot should take diagonal win')
testboard3.print

testboard4 = Board.new
testboard4.addDiscs(:O, [1,1,2,2,3])
testResult(:preventHoriz, robotMove(:R, testboard4), [0,4], 'robot should avoid giving win')
testboard4.print

testboard5 = Board.new
testboard5.addDiscs(:O, [0,0,1,1,2])
testResult(:preventHoriz, robotMove(:R, testboard5), [3], 'robot should avoid giving win')
testboard5.print
