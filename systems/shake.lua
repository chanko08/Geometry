local System  = require 'systems.system'
local Vector  = require 'lib.hump.vector'

local ShakeSystem = class({})
ShakeSystem:include(System)


local function RK4(y,f,dt,mass,stiffness,damping)
    local k1 = f(y,         mass,stiffness,damping)
    local k2 = f(y+dt*k1/2, mass,stiffness,damping)
    local k3 = f(y+dt*k2/2, mass,stiffness,damping)
    local k4 = f(y+dt*k3,   mass,stiffness,damping)

    return y + dt/6 * (k1 + 2*k2 + 2*k3 + k4)
end

local function f(s,v,mass,stiffness,damping)
    return -stiffness/mass*s - damping/mass*v
end

function ShakeSystem:init( state )
    System.init(self,state)

    self.modes   = {}
    self.octaves = {2,5,13,21}
    for i=1,4 do
        table.insert(self.modes, {s=Vector(0,0), v=Vector(0,0)})
    end

    -- The actual camera offset
    self.shake_offset = Vector(0,0)

    self:listen_for('fire')
end

function ShakeSystem:run(dt)

    -- look for new bullets
    for k,event in ipairs(self.event_queue) do
        print('shake system:',event.name, event.ent)
        self:shake(event.ent.gun.shake_spectrum)
    end


    -- Reset the accumulation
    self.shake_offset = Vector(0,0)

    for i=1,4 do
        local oct = self.modes[i]
        -- oct.v = oct.v + dt*(-1*i*oct.s - 1 * oct.v)
        local mass      = 2
        local stiffness = 50/i
        local damping   = 7/i
        oct.v = RK4(  oct.v, _.curry(f,oct.s), self.octaves[i]*dt, mass,stiffness,damping )
        oct.s = oct.s + self.octaves[i]*dt*oct.v

        -- probably clamp stuff here. let's go crazy for now!

        self.shake_offset = self.shake_offset + oct.s/i
    end
    -- FLUSH
    self.event_queue = {}
    print('Shake amount: ',self.shake)
end

function ShakeSystem:impulse(mode,magnitude,direction)
    local d = direction or Vector(0,1):rotated(math.random() * 2 * math.pi )
    print('Shake: ',mode,magnitude,d)
    self.modes[mode].v = self.modes[mode].v + magnitude*d
end

function ShakeSystem:shake(shake_spectrum)
    self:impulse(4,shake_spectrum[4])
    self:impulse(3,shake_spectrum[3])
    self:impulse(2,shake_spectrum[2])
    self:impulse(1,shake_spectrum[1])
end

return ShakeSystem