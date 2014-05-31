return {
  version = "1.1",
  luaversion = "5.1",
  orientation = "orthogonal",
  width = 20,
  height = 10,
  tilewidth = 70,
  tileheight = 70,
  properties = {},
  tilesets = {
    {
      name = "tiles",
      firstgid = 1,
      tilewidth = 70,
      tileheight = 70,
      spacing = 1,
      margin = 0,
      image = "tilesets/tiles_spritesheet.png",
      imagewidth = 852,
      imageheight = 856,
      properties = {},
      tiles = {}
    }
  },
  layers = {
    {
      type = "tilelayer",
      name = "Level",
      x = 0,
      y = 0,
      width = 20,
      height = 10,
      visible = true,
      opacity = 1,
      properties = {},
      encoding = "lua",
      data = {
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        57, 57, 57, 57, 57, 57, 57, 57, 57, 57, 57, 57, 57, 57, 57, 57, 57, 57, 57, 57,
        9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9,
        9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
      }
    },
    {
      type = "objectgroup",
      name = "Physics",
      visible = true,
      opacity = 1,
      properties = {},
      objects = {
        {
          name = "",
          type = "ground",
          shape = "rectangle",
          x = 0,
          y = 280,
          width = 1400,
          height = 70,
          visible = true,
          properties = {
            ["bodytype"] = "static"
          }
        },
        {
          name = "Player",
          type = "",
          shape = "rectangle",
          x = 70,
          y = 210,
          width = 70,
          height = 70,
          visible = true,
          properties = {
            ["bodytype"] = "dynamic"
          }
        }
      }
    }
  }
}
