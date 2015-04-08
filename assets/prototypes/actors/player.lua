return {
            ["bbox"] = {},
            ["collision"] = {is_passive=false, groups={'player','actor'}, shape='circle'},
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
            ["inventory"] = {}
          }