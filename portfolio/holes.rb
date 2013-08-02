class Hole
	attr_accessor :occupied
	attr_accessor :index	
	attr_accessor :pos	
	def initialize i
		@index = i
	end
	@occupied = false
	@pos = [0,0]
end
class Board
	attr_accessor :solutionList

	def initialize
		setup
		@solutionList = []
	end

	def holeInDirection hole_index_x, hole_index_y , direction
		#direction 0 1 2 3 4 5
		#index 0-14
		
		if(direction == 0)
			targetx = hole_index_x - 1
			targety = hole_index_y
		
		elsif(direction == 1)
			targetx = hole_index_x
			targety = hole_index_y - 1
		
		elsif(direction == 2)
			targetx = hole_index_x + 1
			targety = hole_index_y - 1
		
		elsif(direction == 3)
			targetx = hole_index_x + 1
			targety = hole_index_y
		
		elsif(direction == 4)
			targetx = hole_index_x
			targety = hole_index_y + 1
		
		elsif(direction == 5)
			targetx = hole_index_x - 1
			targety = hole_index_y + 1
		end

		if (targetx < 0 || targetx > (5-targety-1) || targety < 0 || targety > (5-targetx-1))
			return nil
		else
			return @grid[targetx][targety]
		end
	end

	def opp direction
		return (direction +3 )%6
	end

	def play
		puts "num holes occupied this recursion:" + count_occupied_holes
		return true if count_occupied_holes.to_i < 2
		@holes.each_with_index {|hole, index|
			if hole.occupied
				6.times do |i|
					ad_hole = self.holeInDirection(hole.pos[0],hole.pos[1],i)
					next if ad_hole == nil || !ad_hole.occupied
					over_hole = self.holeInDirection(ad_hole.pos[0],ad_hole.pos[1],i)
					if (over_hole != nil && !over_hole.occupied)
						make_move hole, i

						puts "RECURSE"
						return true if play
						take_back_move over_hole, opp(i)
					end
				end
			end
		}	
		return false
	end

	def count_occupied_holes
		i = 0
		@holes.each_with_index {|hole, index|
			i= i+1 if hole.occupied
		}
		return i.to_s
	end

	def setup
		@grid = []
		@holes = []
		5.times do |j|
			@grid[j] =  Array.new()
		end

		15.times do |i|
			@holes[i] = Hole.new(i)

			row = 0
			if i < 5
				row = 0
			elsif i < 9
				row = 1
			elsif i < 12
				row = 2
			elsif	 i < 14
				row = 3
			else
				row = 4
			end

			width = @grid[row].length
			@grid[row][width] = @holes[i]
			@holes[i].pos = [row,width]
		end

		@holes.each_with_index {|hole, index|
			hole.occupied = true if index != 14
		}
	end

	def make_move hole, direction
		puts "at beginning of make move: " + count_occupied_holes
		adjacent_hole = holeInDirection hole.pos[0], hole.pos[1], direction
		rasie 'adjacent hole was not occupied' unless adjacent_hole.occupied
		over_hole = holeInDirection(adjacent_hole.pos[0],adjacent_hole.pos[1],direction)
		rasie 'over hole was occupied' if over_hole.occupied
		adjacent_hole.occupied = false
		over_hole.occupied = true
		hole.occupied = false
		@solutionList.push(hole.index.to_s + ", " + over_hole.index.to_s)
		puts "direction: " + direction.to_s
		puts "at end of make move: " + count_occupied_holes
	end
	def take_back_move hole, direction
		puts "at beginning of take back move: " + count_occupied_holes
		puts "direction: " + direction.to_s
		adjacent_hole = holeInDirection hole.pos[0], hole.pos[1], direction
		over_hole = holeInDirection(adjacent_hole.pos[0],adjacent_hole.pos[1],direction)
		puts adjacent_hole.class
		puts over_hole.class
		@solutionList.pop
		adjacent_hole.occupied = true
		over_hole.occupied = true
		hole.occupied = false

	end
end

def run
	b = Board.new
	b.setup
	b.play
	puts b.solutionList
end

run

