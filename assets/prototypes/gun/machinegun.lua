return {
    ["bbox"] = {},
    ["collision"] = {is_passive=false, groups={'gun','actor'}, shape='rectangle'},
    ["physics"] = {v={x=0, y=0}, a={x=0, y=0}, gravity=0},
    ["audio"] = {
      fire = 'pew.wav'
    },
    ["gun"] = {

        initial = {
            fire_delay = 1,
            bullets_per_shot = 3,
            accuracy = .20,
            hitscan = false,
            projectile_speed = 1000,
            max_burst = math.huge,
            fired=false,
            vibration_duration = 0.25,
            vibration_strength = 1.0,
            shake_spectrum     = {5,10, 50, 50}
        },

        bullet = {
            hitscan  = false,
            velocity = 1500,
            size     = 10
        },

        at_rest = {
            fire_delay = {duration=1, type='instant',target=1,start=1}
        },

        pull_trigger = {
            fire_delay  = {duration=1, type="instant", target=0, start=1},
            accuracy    = {duration=4, type='outQuad',  target=1.00, start=0.5}
        },

        fire_bullet = {
            fire_delay  = {duration=.1, type="linear", target=0, start=1}
        },

        release_trigger = {
            fire_delay  = {duration=1, type="instant", target=0.5, start=1}
        },

        bullet_render_tag = "laser"
    }
}