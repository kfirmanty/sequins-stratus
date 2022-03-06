s = require 'sequins'
engine.name = "PolyPerc"
local grid = util.file_exists(_path.code.."midigrid") and include "midigrid/lib/mg_128" or grid
local er = include("sequins_stratus/lib/euclidean")

local g = grid.connect(3)
local rows = 4
local cols = 8
local base_freq = 110
local just_intonation_minor = {1, 9/8, 6/5, 4/3, 3/2, 8/5, 9/5}
local scale = just_intonation_minor
local notes_held = {{1, 1, 1}, {3, 2, 1}, {5, 3, 1}, {7, 4, 1}} --note index in scale, column and octave index (octave used when playing using only grid)
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
function seven_steps() return s{1, 0, 0, 1, 0, 0, 1} end
function five_steps() return s{0, 1, 0, 0, 1} end
function e_3_8() return er.generate(3,8) end
function e_5_8() return er.generate(5,8) end
function e_3_7() return er.generate(3,7) end
function e_4_9() return er.generate(4,9) end
function init()
   for x = 1, 8 do
      for y = 1, 8 do
         g:led(x, y, 0)
      end
   end
   g:refresh()
   matrix = create_matrix({four_on_the_floor, fake_skipping_shuffle, seven_steps, five_steps, e_3_8, e_5_8, e_3_7, e_4_9})
   clock.run(iter)
end

function engine_out(voice, scale_step, seq_column, octave, gate, hertz)
   if gate == 1 then engine.hz(hertz) end
end

function crow_disting_out(voice, scale_step, seq_column, octave, gate, hertz)
   if gate == 1 then
      crow.ii.disting.voice_pitch(voice, hertz)
      crow.ii.disting.voice_on(voice, 128)
   end
end

local output_fns = {engine = engine_out,
                    crow_disting = crow_disting_out}
local output = "engine"


function iter()
   while true do
      clock.sync(1/4)
      for y = 1, #notes_held do
         local scale_step, seq_column, octave = table.unpack(notes_held[y])
         local gate = matrix[seq_column][y]()
         local hertz = scale[scale_step] * base_freq * octave
         output_fns[output](y, scale_step, seq_column, octave, gate, hertz)
      end
   end
end

local bottom_selects_notes = true

function g.key(x,y,z)
   if z == 1 then
      if bottom_selects_notes and y > 4 then
         if x == 8 then
            local oct = notes_held[y-4][3]
            notes_held[y-4][3] = oct == 1 and 2 or 1
         else notes_held[y-4][1] = math.min(x, #scale) end
      else
         notes_held[y][2] = x
      end
      for xt = 1, 8 do
         g:led(xt,y, 0)
      end
      g:led(x, y, 15)
      g:refresh()
   end
end
