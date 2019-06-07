This game is still in the middle of refactoring. Not all of its current functionality has been restored.
To execute the game, either drag the "game" folder onto love.exe, or run love.exe with the parameter game.
This distribution is windows only, although the LOVE framework supports multiple platforms.

The game should be controllable with either keyboard or controller. By default, the game runs based on keyboard input, with following controls:

* Arrow Keys = Movement
* G = Jump	
* F = Punch
* D = Kick
* S = Dash
* A = Sway
* Tab = Switch controllers

They're rebindable in the file game/buttonconfig.lua, which can be opened with any text editor. The game itself, besides the reasonably fleshed out character controls, is rather barebones though. Much of the effort so far went into this system, and designing the associated animations complete with a debug-accessible in-game animation editor. The function keys are debug keys; an exhaustive explanation of what they do is outside of the scope of this readme.