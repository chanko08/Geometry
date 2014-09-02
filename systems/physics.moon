inspect = require 'lib/inspect'

physics = (phys_obj, dt, max_v) ->
    max_velocity = max_v or math.huge

    -- print 'phys_obj', inspect(phys_obj)


    vx = phys_obj.vx + phys_obj.ax * dt
    vx = math.max(math.min(vx, max_velocity), -max_velocity)

    px = phys_obj.x + vx * dt


    phys_obj.vx = vx
    phys_obj.x = px
    return phys_obj

return physics