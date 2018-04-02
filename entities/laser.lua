-- Laser
local Laser = { __type = 'Laser' }
Laser.__index = Laser

setmetatable(Laser, {
    __call = function(cls, ...)
        cls.new(...)
    end
})
