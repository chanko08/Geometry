local Constants
do
  local _base_0 = {
    Direction = {
      LEFT = -1,
      RIGHT = 1,
      STOP = 0,
      UP = 2,
      DOWN = 3
    },
    GRAVITY = 500,
    MAX_VELOCITY = 333,
    MAX_BULLET_RANGE = 1e12,
    MIN_ZOOM = .4,
    MAX_ZOOM = 1.5
  }
  _base_0.__index = _base_0
  local _class_0 = setmetatable({
    __init = function() end,
    __base = _base_0,
    __name = "Constants"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  Constants = _class_0
end
return Constants
