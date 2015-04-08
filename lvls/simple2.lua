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
          name = "Grunt1",
          type = "",
          shape = "rectangle",
          x = 631.333,
          y = 363,
          width = 32,
          height = 32,
          rotation = 0,
          visible = true,
          properties = {
            prototype = 'actors.grunt'
          }
        },
        {
          name = "player",
          type = "",
          shape = "rectangle",
          x = 65,
          y = 45,
          width = 32,
          height = 32,
          rotation = 0,
          visible = true,
          properties = {
            prototype = 'actors.player'
          }
        },
        {
          name = "shotgun",
          type = "",
          shape = "rectangle",
          x = 65,
          y = 45,
          width = 32,
          height = 8,
          rotation = 0,
          visible = true,
          properties = {
            prototype = "gun.shotgun"
          }
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
          properties = {
            ["bbox"] = {},
            ["collision"] = {groups={"Terrain"}},
            ["physics"] = {}
          }
        },
        -- {
        --   name = "sloped wall",
        --   type = "",
        --   shape = "polyline",
        --   x = 92,
        --   y = 447,
        --   width = 0,
        --   height = 0,
        --   rotation = 0,
        --   visible = true,
        --   polyline = {
        --     { x = 0, y = 0 },
        --     { x = 566, y = 410 },
        --     { x = 1233, y = 408 }
        --   },
        --   properties = {
        --     --["bbox"] = {},
        --     ["collision"] = {},
        --     ["physics"] = {}
        --   }
        -- },
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
          properties = {
            ["bbox"] = {},
            ["collision"] = {groups={"Terrain"}},
            ["physics"] = {}
          }
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
          x = 200,
          y = 45,
          width = 35,
          height = 28,
          rotation = 0,
          visible = true,
          properties = {
            prototype='item.pickup'
          }
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
