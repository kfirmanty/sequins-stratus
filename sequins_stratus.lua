s = require 'sequins'
engine.name = "PolyPerc"
local grid = util.file_exists(_path.code.."midigrid") and include "midigrid/lib/mg_128" or grid

local g = grid.connect(3)
local rows = 4
local cols = 4
local base_freq = 110
local just_intonation_minor = {1, 9/8, 6/5, 4/3, 3/2, 8/5, 9/5}
local scale = just_intonation_minor
local notes_held = {{1, 1}, {3, 2}, {5, 3}, {7, 4}} --note index in scale and column index
local matrix = {}

function create_matrix(cols_seq_constructors)
   local matrix = {}
   for x = 1, cols do
      matrix[x] = {}
      for y = 1, rows do
         matrix[x][y] = cols_seq_constructors[x]()
      end
   end
   return matrix
end

function four_on_the_floor() return s{1}:every(4) end
function fake_skipping_shuffle() return s{1, 0, 0, 1, 0} end
function three_three_two() return s{1, 0, 0, 1, 0, 0, 1, 0} end
function five_steps() return s{0, 1, 0, 0, 1} end

function init()
   for x = 1, 8 do
      for y = 1, 8 do
         g:led(x, y, 0)
      end
   end
   g:refresh()
   matrix = create_matrix({four_on_the_floor, fake_skipping_shuffle, three_three_two, five_steps})
   clock.run(iter)
end

function iter()
   while true do
      clock.sync(1/4)
      for y = 1, #notes_held do
         local scale_step, seq_column = table.unpack(notes_held[y])
         local gate = matrix[seq_column][y]()
         if gate == 1 then
            local hertz = scale[scale_step] * base_freq
            engine.hz(hertz)
         end
      end
   end
end

function g.key(x,y,z)
   if z == 1 then
      notes_held[y][2] = x
      for xt = 1, cols do
         g:led(xt,y, 0)   
      end
      g:led(x, y, 15)
      g:refresh()
   end
end
