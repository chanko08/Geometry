return {
    ["gun"] = {
        -- fire rate, pull trigger, wait until we can fire again
        initial = {
        fire_delay = 1,
        bullets_per_shot = 11,
        accuracy = 0.55,
        hitscan = false,
        max_burst = 1,
        fired=false,
        vibration_duration = 0.25,
        vibration_strength = 0.6,
        },

        bullet = {
            hitscan  = false,
            velocity = 1500,
            size     = 5
        },

        at_rest = {
            fire_delay = {duration=1, type='instant',target=1,start=1} -- Imagine a gun that slowly gets more powerful the longer you don't fire 
        },

        pull_trigger = {
            fire_delay   = {duration=1, type="instant", target=0, start=0},
        },

        fire_bullet = {
            fire_delay = {duration=0.2, type="linear", target=0, start=1}
        },

        release_trigger = {
        },

        bullet_render_tag = "shotgun"
    }
}