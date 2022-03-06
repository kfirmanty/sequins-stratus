local sequence_view = {
   state = nil
}

function sequence_view:init(state)
   self.state = state
   for x = 1, 8 do
      for y = 1, 8 do
         self.state.g:led(x, y, 0)
      end
   end
   self.state.g:refresh()
end

function sequence_view:on_key(x,y,z)
   if z == 1 then
      if self.state.bottom_selects_notes and y > 4 then
         if x == 8 then
            local oct = self.state.notes_held[y-4][3]
            self.state.notes_held[y-4][3] = oct == 1 and 2 or 1
         else self.state.notes_held[y-4][1] = math.min(x, #self.state.scale) end
      else
         self.state.notes_held[y][2] = x
      end
      for xt = 1, 8 do
         self.state.g:led(xt,y, 0)
      end
      self.state.g:led(x, y, 15)
      self.state.g:refresh()
   end
end

return sequence_view
