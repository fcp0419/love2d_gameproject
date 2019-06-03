-- in which we bridge the game and the baton library

local activeJoystick = 1


-- note that this method is not Object:new, but the constructor of Baton
Input = Baton.new{
	controls = {
		left = {'key:left', 'axis:leftx-', 'button:dpleft'},
		right = {'key:right', 'axis:leftx+', 'button:dpright'},
		up = {'key:up', 'axis:lefty-', 'button:dpup'},
		down = {'key:down', 'axis:lefty+', 'button:dpdown'},
		confirm = {'key:y', 'button:a'},
		cancel = {'key:x', 'button:b'},
		menu = {'key:escape', 'button:start'},
		pause = {'key:backspace', 'key:pause', 'button:select'},
		attack = {'key:g', 'button:x'},
		special = {'key:f', 'button:y'},
		breaker = {'key:b', 'button:b'},
		dash = {'key:s', 'button:lb', 'button:rb'},
		jump = {'key:space', 'button:a'},
		enhance = {'key:v', 'axis:triggerleft', 'axis:triggerright'},
		
		
	},
	pairs = {
		move = {'left', 'right', 'up', 'down'}
	},
	joystick = love.joystick.getJoysticks()[activeJoystick],

}