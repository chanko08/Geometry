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
            ["bbox"] = true,
            ["gruntai"] = {},
            ["collision"] = {
              is_passive=false,
              groups={'grunt'},
              sensors = {
                {name='player_visible', is_passive=false, groups={'sensors'}, shape='circle', width=200, rel_x=0, rel_y=0},
                {name='cliff_left',     is_passive=false, groups={'sensors','actor'}, shape='rectangle', width=1, height=80, rel_x=-15, rel_y=32},
                {name='cliff_right',    is_passive=false, groups={'sensors','actor'}, shape='rectangle', width=1, height=80, rel_x=16, rel_y=32}
              }
            },
            
            ["physics"] = {v={x=0,y=0}, a={x=0,y=0}, gravity=500}
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
            ["bbox"] = true,
            ["collision"] = {is_passive=false, groups={'player','actor'}, shape='circle'},
            ["physics"] = {v={x=0, y=0}, a={x=0, y=0}, gravity=500},
            ["player"] = {},
            ["camera"] = {}
          }
        },
        {
          name = "laser-gun",
          type = "",
          shape = "rectangle",
          x = 65,
          y = 45,
          width = 32,
          height = 8,
          rotation = 0,
          visible = true,
          properties = {
            ["bbox"] = true,
            ["collision"] = {is_passive=false, groups={'gun','actor'}, shape='rectangle'},
            ["physics"] = {v={x=0, y=0}, a={x=0, y=0}, gravity=0},
            ["hitscan_gun"] = {},
            ["gun"] = {
              -- fire rate, pull trigger, wait until we can fire again
              initial = {
                fire_delay = 0,
                --cooldown = 0,
                number_shots = 1,
                accuracy = 0.85,
                projectile_speed = math.huge,
                automatic = false,
                fired=false,
                visibility_delay = 0
              },

              pull_trigger = {
                fire_delay   = {duration=1, type="linear", target=0, start=1},

              },

              fire_bullet = {
                fire_delay = {duration=0.125, type="linear", target=0, start=1},
                visibility_delay = {duration=0.25, type="linear", target=0, start=20 }
              },

              release_trigger = {},
              bullet_render_tag = "laser"

            }
          }
        }
        --[[,
        {
          name = "pistol",
          type = "",
          shape = "rectangle",
          x = 65,
          y = 45,
          width = 32,
          height = 8,
          rotation = 0,
          visible = true,
          properties = {
            ["bbox"] = true,
            ["collision"] = {is_passive=false, groups={'gun','actor'}, shape='rectangle'},
            ["physics"] = {v={x=0, y=0}, a={x=0, y=0}, gravity=0},
            ["hitscan_gun"] = {},
            ["gun"] = {
              -- fire rate, pull trigger, wait until we can fire again
              initial = {
                fire_rate = 1
              },

              pull_trigger = {
                fire_rate = {duration=1, type="linear", target=0, start=1}
              },

              release_trigger = {}
            }
          }
        }
        ]]--
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
            ["bbox"] = true,
            ["collision"] = {},
            ["physics"] = {}
          }
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
          properties = {
            --["bbox"] = true,
            ["collision"] = {},
            ["physics"] = {}
          }
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
          properties = {
            ["bbox"] = true,
            ["collision"] = {},
            ["physics"] = {}
          }
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
          properties = {
            -- ["bbox"] = true,
            ["collision"] = {},
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
