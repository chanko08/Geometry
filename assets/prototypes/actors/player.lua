return {
            ["bbox"] = {},
            ["collision"] = {is_passive=false, groups={'player','actor'}, shape='circle',
                sensors = {
                    {
                        name='item',
                        is_passive=false,
                        groups={'sensors','actors','terrain'},
                        shape='circle',
                        width=50, rel_x=0, rel_y=0,
                        signal = 'player_brain'
                    }
                }
            },
            ["physics"] = {v={x=0, y=0}, a={x=0, y=0}, gravity=500},
            ["player"] = {},
            ["camera"] = {},
            -- ["inventory"] = {
            --   -- Think Deus Ex (the first one)
            --   -- as where this could go next?
            --   -- For now, we'll just get the functionality in place.
            --   items = {}
            -- },
            ["audio"]  = {
              jump = 'jump.wav',
              land = 'hit.wav'
            },
            ["inventory"] = {},
            ['hashtag'] = {'actor'}
          }