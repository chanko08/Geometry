return {
            ["bbox"] = {},
            ["gruntai"] = {},
            ["collision"] = {
              is_passive=false,
              groups={'grunt'},
              sensors = {
                {
                  name='player_visible',
                  is_passive=false,
                  groups={'sensors','terrain'},
                  shape='circle',
                  width=200,
                  rel_x=0,
                  rel_y=0,
                  signal=
                    {
                      on = 'grunt_brain',
                      off = 'grunt_brain_off'
                    }
                },
                {
                  name='cliff_left',
                  is_passive=false,
                  groups={'sensors','actor'},
                  shape='rectangle',
                  width=1,
                  height=80,
                  rel_x=-15,
                  rel_y=32,
                  signal=
                    {
                      when_off = 'grunt_brain_turn_right'
                    }

                },
                {
                  name='cliff_right',
                  is_passive=false,
                  groups={'sensors','actor'},
                  shape='rectangle',
                  width=1,
                  height=80,
                  rel_x=16,
                  rel_y=32,
                  signal=
                    {
                      when_off = 'grunt_brain_turn_left'
                    }
                }
              }
            },
            
            ["physics"] = {v={x=0,y=0}, a={x=0,y=0}, gravity=500},
            ["hashtag"] = {
              "enemy",'actor'
            }
          }