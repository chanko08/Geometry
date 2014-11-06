return {
  version = "1.1",
  luaversion = "5.1",
  orientation = "orthogonal",
  width = 100,
  height = 100,
  tilewidth = 32,
  tileheight = 32,
  properties = {},
  tilesets = {},
  layers = {
    {
      type = "objectgroup",
      name = "Actors",
      visible = true,
      opacity = 1,
      properties = {},
      objects = {
        {
          name = "Player",
          type = "",
          shape = "rectangle",
          x = 57.7589,
          y = 96.6975,
          width = 64,
          height = 64,
          rotation = -90.4551,
          visible = true,
          properties = {
            ["bboxHeight"] = 32.0,
            ["bboxWidth"] = 32,
            ["debugColor"] = {r=255,g=0,b=0},
            ["fallDamageHeight"] = 500,
            ["gravity"] = 10,
            ["maxJumpVelocity"] = 100,
            ["maxLateralSpeed"] = 75,
            ["prototypes"] = 'player',
            ["shape"] = 'square',
            ["spritemap"] = 'assets/player/map.lua',
            ["states"] = {'idle',' jump', 'shoot', 'land', 'death', 'crouch', 'walljump', 'damaged'},
            ["static"] = false
          }
        },
        {
          name = "Grunt1",
          type = "",
          shape = "rectangle",
          x = 1210,
          y = 375,
          width = 45,
          height = 62,
          rotation = 0,
          visible = true,
          properties = {}
        }
      }
    },
    {
      type = "objectgroup",
      name = "Terrain",
      visible = true,
      opacity = 1,
      properties = {},
      objects = {
        {
          name = "rect wall",
          type = "",
          shape = "rectangle",
          x = 34,
          y = 170,
          width = 743,
          height = 34,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          name = "sloped wall",
          type = "",
          shape = "polyline",
          x = 92,
          y = 447,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          polyline = {
            { x = 0, y = 0 },
            { x = 566, y = 410 },
            { x = 1233, y = 408 }
          },
          properties = {}
        },
        {
          name = "rect wall",
          type = "",
          shape = "rectangle",
          x = 602,
          y = 454,
          width = 668,
          height = 43,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          name = "boundary",
          type = "",
          shape = "polyline",
          x = 8,
          y = 5,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          polyline = {
            { x = 0, y = 0 },
            { x = 1, y = 1195 },
            { x = 1561, y = 1193 },
            { x = 1560, y = 1 },
            { x = 1, y = 1 }
          },
          properties = {}
        }
      }
    },
    {
      type = "objectgroup",
      name = "Items",
      visible = true,
      opacity = 1,
      properties = {},
      objects = {
        {
          name = "item1",
          type = "",
          shape = "rectangle",
          x = 739,
          y = 791,
          width = 40,
          height = 40,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          name = "item2",
          type = "",
          shape = "rectangle",
          x = 856,
          y = 803,
          width = 52,
          height = 25,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          name = "item3",
          type = "",
          shape = "rectangle",
          x = 1019,
          y = 800,
          width = 35,
          height = 28,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          name = "gun",
          type = "",
          shape = "rectangle",
          x = 1224,
          y = 795,
          width = 69,
          height = 29,
          rotation = 0,
          visible = true,
          properties = {}
        }
      }
    }
  }
}
