vector = require 'lib/HardonCollider/vector-light'

class SamusCannonRenderer
	new: () =>
		@colors = {}

	draw: (gun, mouse_x, mouse_y) =>
		player_x, player_y = gun.owner\get_center!

		if gun.is_charging
			hover_x, hover_y = vector.mul(gun.hover_distance,vector.normalize(mouse_x - player_x, mouse_y - player_y))
			hover_x += player_x
			hover_y += player_y
			wobble_amount    = 2
			wobble_rate      = 30*gun.charge_state/gun.charge_time
			wobble_radius    = wobble_amount*math.sin(wobble_rate*gun.charge_state)
			wobble_color     = {255*(.75 + .25*math.sin(wobble_rate*gun.charge_state)) , 255, 255}


			r,g,b,a = love.graphics.getColor!
	        
	        love.graphics.setColor wobble_color[1], wobble_color[2], wobble_color[3]
	        love.graphics.circle('fill', hover_x, hover_y, gun\current_radius! + wobble_radius)

	    	love.graphics.setColor r,g,b,a