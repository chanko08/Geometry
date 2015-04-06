return {
            ["bbox"] = {},
            ["gruntai"] = {},
            ["collision"] = {
              is_passive=false,
              groups={'grunt', 'actor'},
              sensors = {
                {name='player_visible', is_passive=false, groups={'sensors'}, shape='circle', width=200, rel_x=0, rel_y=0},
                {name='cliff_left',     is_passive=false, groups={'sensors','actor'}, shape='rectangle', width=1, height=80, rel_x=-15, rel_y=32},
                {name='cliff_right',    is_passive=false, groups={'sensors','actor'}, shape='rectangle', width=1, height=80, rel_x=16, rel_y=32}
              }
            },
            
            ["physics"] = {v={x=0,y=0}, a={x=0,y=0}, gravity=500},
            ["hashtag"] = {
              "enemy"
            }
          }