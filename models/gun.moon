_ = require 'lib/underscore'

class Gun
    new: (owner)=>
        @owner = owner
        @bullets = {}

    pull_trigger: (crosshair) =>

    release_trigger: (crosshair) =>

    special_control: (...) =>

    get_bullets: () =>
    	_.keys(@bullets)

    update: (dt) =>

    on_equip: () => 

    on_dequip: () =>

return Gun