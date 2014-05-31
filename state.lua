local State = class('State')

function State:initialize(switch)
  self.switch_state = switch
end

function State:update(dt)
end

function State:draw()

end

function State:keyreleased(key)
end

function State:keypressed(key)
end


return State
