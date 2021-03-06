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
            bullets_per_shot = 1,
            accuracy = 1.00,
            hitscan = false,
            projectile_speed = 500,
            max_burst = 1,
            fired=false,
            vibration_duration = 0.25,
            vibration_strength = 1.0,
            shake_spectrum     = {75,50, 25, 12}
        },

        bullet = {
            hitscan  = false,
            velocity = 500,
            size     = 50
        },

        at_rest = {
            fire_delay = {duration=1, type='instant',target=1,start=1}
        },

        pull_trigger = {
            fire_delay  = {duration=1, type="linear", target=0, start=1},
        },

        fire_bullet = {
            fire_delay  = {duration=1, type="linear", target=0, start=1}
        },

        release_trigger = {},

        bullet_render_tag = "laser"
    }
}