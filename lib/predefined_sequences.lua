s = require 'sequins'
local er = include("sequins_stratus/lib/euclidean")

function four_on_the_floor() return s{1}:every(4) end
function fake_skipping_shuffle() return s{1, 0, 0, 1, 0} end
function seven_steps() return s{1, 0, 0, 1, 0, 0, 1} end
function five_steps() return s{0, 1, 0, 0, 1} end
function e_3_8() return er.generate(3,8) end
function e_5_8() return er.generate(5,8) end
function e_3_7() return er.generate(3,7) end
function e_4_9() return er.generate(4,9) end

return {four_on_the_floor = four_on_the_floor,
        fake_skipping_shuffle = fake_skipping_shuffle,
        seven_steps = seven_steps, five_steps = five_steps,
        e_3_8 = e_3_8, e_5_8 = e_5_8, e_3_7 = e_3_7, e_4_9 = e_4_9}
