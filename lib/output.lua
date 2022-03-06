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

function output(output_name, voice, scale_step, seq_column, octave, gate, hertz)
   output_fns[output_name](voice, scale_step, seq_column, octave, gate, hertz)
end

return output
