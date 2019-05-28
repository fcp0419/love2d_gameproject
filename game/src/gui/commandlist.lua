CommandList = {
	{indent = 0, movename = "Standing", command = {"5"}, moveID = "Stand", isHeader = true},
	{indent = 1, movename = "Right Straight", command = {"5", "P"}, moveID = "RightStraight", displayFrame = 3},
	{indent = 2, movename = "Left Jolt", command = {"5", "P", "5", "P"}, moveID = "LeftJolt", displayFrame = 5},
	{indent = 3, movename = "Right Hook", command = {"5", "P", "5", "P", "5", "P"}, moveID = "RightHookStand", displayFrame = 7},
	{indent = 4, movename = "Left Swing", command = {"5", "P", "5", "P", "5", "P", "5", "P"}, moveID = "LeftSwing", displayFrame = 6},
	{indent = 1, movename = "Heel Kick", command = {"5", "K"}, moveID = "HeelKick", chargeMoveID = "HeelKickCharged", canBeCharged = true, displayFrame = 14},
	{indent = 2, movename = "Front Kick", command = {"5", "K", "5", "K"}, moveID = "FrontKick", chargeMoveID = "FrontKickCharged", canBeCharged = true, displayFrame = 11},
	{indent = 0, movename = "Walk", command = {"6"}, moveID = "Walk", isHeader = true},
	{indent = 0, movename = "Ducking", command = {"2"}, moveID = "Duck", isHeader = true},
	{indent = 1, movename = "Left Hook", command = {"2", "P"}, moveID = "LeftHook", displayFrame = 8},
	{indent = 2, movename = "Right Hook", command = {"2", "P", "2", "P"}, moveID = "RightHookCrouch", displayFrame = 7},
	{indent = 3, movename = "Left Swing", command = {"2", "P", "2", "P", "2", "P"}, moveID = "LeftSwing", displayFrame = 6},
	{indent = 1, movename = "Leg Sweep", command = {"2", "K"}, moveID = "Sweep", chargeMoveID = "SpinningSweep", canBeCharged = true, displayFrame = 10},
	{indent = 0, movename = "Guarding", command = {"8"}, moveID = "Guard", isHeader = true},
	{indent = 1, movename = "Left Uppercut", command = {"8", "P"}, moveID = "LeftUpper", displayFrame = 5},
	{indent = 2, movename = "Shoulder Tackle", command = {"8", "P", "8", "P"}, moveID = "ShoulderTackle", displayFrame = 15},
	{indent = 1, movename = "Hopping Knee", command = {"8", "K"}, moveID = "KneeHop", chargeMoveID = "SplitKickHop", canBeCharged = true, displayFrame = 7},
	
	
	{indent = 0, movename = "Dash", command = {"5", "D"}, moveID = "Dash", isHeader = true},
	{indent = 1, movename = "Dash Left Jolt", command = {"5", "D", "5", "P"}, moveID = "DashLeftJolt"},
	{indent = 2, movename = "Dash Right Straight", command = {"5", "D", "5", "P", "5", "P"}, moveID = "DashRightStraight"},
	{indent = 3, movename = "Left Swing", command = {"5", "D", "5", "P", "5", "P", "5", "P"}, moveID = "LeftSwing"},
	{indent = 1, movename = "Flying Kick", command = {"5", "D", "5", "K"}, moveID = "DashLeftJolt"},
	
	{indent = 0, movename = "Low Dash", command = {"2", "D"}, moveID = "Crouchdash", isHeader = true},
	{indent = 1, movename = "Dash Shoulder Tackle", command = {"2", "D", "2", "P"}, moveID = "CrouchdashShoulderTackle"},
	{indent = 1, movename = "Slide Kick", command = {"2", "D", "2", "K"}, moveID = "CrouchdashSlideKick"},
	
	{indent = 0, movename = "Sway", command = {"5", "E"}, moveID = "SwayShort", isHeader = true},
	{indent = 1, movename = "Backswing Right Hook", command = {"5", "E", "5", "P"}, moveID = "RightHookSway", canBeCharged = true, chargeMoveID = "LeftDownpunch"},
	{indent = 1, movename = "Slide Kick", command = {"5", "E", "5", "K"}, moveID = "CrouchdashSlideKick"},
	
	{indent = 0, movename = "Backflip", command = {"8", "E"}, moveID = "EscapeJump", isHeader = true},
	{indent = 0, movename = "Jump", command = {"5", "J"}, moveID = "Jump", isHeader = true},
	{indent = 1, movename = "Air Left-Right Punches", command = {"J", "5", "P"}, moveID = "JumpLeftRightPunches"},
	{indent = 1, movename = "Air Flying Kick", command = {"J", "5", "K"}, moveID = "JumpFlyingKick"},
	{indent = 2, movename = "Air Heel Kick", command = {"J", "5", "K", "5", "K"}, moveID = "JumpHeelKick"},
	{indent = 1, movename = "Air Sledgehammer", command = {"J", "2", "P"}, moveID = "JumpHammerFist"},
	{indent = 1, movename = "Air Dive Kick", command = {"J", "2", "K"}, moveID = "JumpDiveKick", chargeMoveID = "JumpDiveKickCharge2", canBeCharged = true},
	{indent = 1, movename = "Air Power Punch", command = {"J", "8", "P"}, moveID = "JumpPowerPunch"},
	{indent = 1, movename = "Air Axe Kick", command = {"J", "8", "K"}, moveID = "JumpAxeKick"},
	
	
	{indent = 0, movename = "Special Moves", command = {}, moveID = false, isHeader = true},
	{indent = 1, movename = "Right Uppercut", command = {"6", "P"}, moveID = "RightUpper"},
	{indent = 1, movename = "Axe Kick", command = {"6", "K"}, moveID = "AxeKick"},
	{indent = 1, movename = "Sure-Kill Straight", command = {"2", "3", "6", "P"}, moveID = "DeathFist"},
	{indent = 1, movename = "Spinning Roundhouse", command = {"2", "3", "6", "K"}, moveID = "SpinKick"},
	{indent = 2, movename = "Bootleg Revolver", command = {"6", "K"}, moveID = "KneeRevolver"},
	{indent = 1, movename = "Rising Uppercut", command = {"6", "2", "3", "P"}, moveID = "RisingUpper"},
	{indent = 1, movename = "Double Upkicks", command = {"6", "2", "3", "K"}, moveID = "DoubleUpkicks"},
}


CommandExtendedInfo = {
	["Default"] = {"This is the default text. Something went wrong."},
	["Standing"] = {"The usual stance. This is just a regular standing idle, there's nothing worth talking about that I can think of."},
	["Ducking"] = {"A low stance. It avoids high attacks, but since the stance is broader you can get clipped by low attacks more easily."},
	["Guarding"] = {"This is called guarding, but guarding doesn't work yet. As of now it simply moves your hurtbox back a short distance."},
	["Walk"] = {"Walking is not the fastest, but the most precise form of movement. If you do not want to commit to a dash, it is wise to walk. Attacks executed from a walk are the exact same as attacks executed while standing."},
	["Dash"] = {"Dashing is faster than walking, but more committed, and unlike walking it has a very short delay before moving forward, and a recovery period where it has less than top speed. If you jump while dashing, the jump will go farther."},
	["Low Dash"] = {"Low dash has a low profile and can go under a lot of attacks while advancing, but is slightly slower than a normal dash, and you cannot cancel it into almost anything. Furthermore, the low dash passes through enemies for most of its duration, allowing you to switch sides."},
	["Sway"] = {"An evasive maneuver which takes a quick step back, passing through enemies. Any attack done out of a sway will have a lot of forward momentum, allowing you to dodge out of a way then go right back in with a quick counter-punch. Note that it has nearly no invincibility, so to evade enemy attacks you must actually move out of their way. You cannot turn around when attacking or moving out of a sway, so make sure you're dodging in the right direction. \nIf you hold down while pressing Evade, an alternate sway will be executed that steps back a greater distance, but you can't attack as quickly out of a long sway."},
	["Jump"] = {"All jumps have a relatively high profile, making them a prime option for  You can jump at three different, fixed heights by pressing Down, Neutral or Up while pressing Jump. Down goes the lowest but also finishes the fastest, Up goes the highest but has the most airtime. The Up version is the only jump with extra grounded jump startup. Similarily, your forward momentum is also mostly fixed and you cannot turn around while in mid-air."},
	["Backflip"] = {"An evasive maneuver which somersaults backwards. It has significant invincibility on the way up, but doesn't allow for fast counter-attacks so it'll often be only useful for running away. You can take actions when reaching the apex of the jump. When you do a forward backflip, your character will also turn around after reaching the apex of the jump, allowing you to flip over opponents and kick them in the back of their head. However, you cannot otherwise turn around during a backflip, and may be vulnerable on the way down."},
	["Special Moves"] = {"This isn't a stance, it is just a category for all special moves in this game. Special moves can be canceled into off many hits that are otherwise uncancelable and have high damage and powerful hitstuns, but represent large commitments. They can be used from any grounded stance."},
	
	
	["Right Straight"] = {"A very fast right-handed straight punch, the fastest normal attack you have. It does not have high range, but it is powerful and doesn't leave you open for long. Its vertical range is rather poor, so it doesn't hit enemies lying on the ground. \nThis move can be charged by holding Punch during its startup. Doing so will automatically follow up with a Left Jolt if the Right Straight connects with an enemy."},
	["Left Jolt"] = {"A left-handed straight punch that moves you forward a great distance. It serves as a guaranteed followup to the right straight, though maybe not always the optimal followup, as its power is average at best."},
	["Right Hook"] = {"A close-range right-handed hook. Combo filler move with rather low damage and not a lot of special properties, but it does serve well in juggle combos, where it floats opponents for a relatively long time, allowing freeform followups."},
	["Left Swing"] = {"A wide left-handed swinging punch, and a designated combo ender. It launches even grounded opponents and has far more range than it looks like, but is only cancelable into special moves and takes a while to recover."},
	["Left Hook"] = {"A left-handed hook from the ducking stance. While it is slower and weaker than the right straight, it hits closer to the ground and moves forward during startup, making it excellent to pick up enemies from the ground or during certain juggles. It can also serve as an anti-air from certain ranges. Since it is a punch from the ducking stance, it inherits the low profile of the duck. \nThis move can be charged by holding Punch during its startup. Doing so will automatically follow up with a Right Hook if the Left Hook connects with an enemy."},
	["Left Uppercut"] = {"A left-handed uppercut from the guarding stance. Strong and fast, but close-range only. It is your designated anti-air attack and therefore has a lot of vertical range, and is invulnerable above the knees to help with anti-airing. As a side-effect, that also makes it great for counterpunching against chest-level grounded attacks. Be careful not to miss, as the left uppercut does have a lot of recovery if if does miss. \nThis move can be charged by holding Punch during startup. Doing so will make Shoulder Tackle come out even if the Left Uppercut misses."},
	["Shoulder Tackle"] = {"An advancing shoulder tackle, slow but strong and lifts grounded opponents off their feet. It has a very tall hurtbox, even taller than the Left Uppercut's, and inherits the above-knees invulnerability of the left uppercut until well into its recovery."},
	["Heel Kick"] = {"A spinning heel kick with the right foot. Significantly slower than a punch, but with higher power and far greater range. It also moves forward a lot, making it one of your longest-ranged tools. \nThis move can be charged by holding Kick during startup. Doing so will execute an alternative version of the kick, which is even slower, more powerful and brings down the foot in a wide, high crescent arc, giving it better juggle, anti-air and knockdown properties."},
	["Front Kick"] = {"An advancing front kick with the left foot, guaranteed to hit after Heel Kick connects. It has good range, provides additional forward movement and favorable juggles. \nThis move can be charged by holding Kick during startup. Doing so will execute an alternative version of the kick, a massive, crushing push kick which is even slower but has devastating power and blows enemies away."},
	["Leg Sweep"] = {"A sweeping kick from a ducking stance. Very low to the ground, faster than the Heel Kick but still with good range. As it is a sweep, it trips grounded opponents, putting them into a juggle state. The sweep also has a lot of active frames, which helps in reliably tripping up enemies running at you, but also a lot of recovery, so be careful not to miss. \nThis move can be charged by holding Kick during startup. Doing so will give it an additional hit, a full circle spinning sweep that hits both sides, helpful when you're being surrounded."},
	["Hopping Knee"] = {"A hopping knee from a guarding stance. Short range and average speed. It goes over low attacks, but hits all the way to the ground, making it a strong counter to low attacks. It can be canceled into aerial attacks when it hits an enemy. Also very useful for juggles, stabilizing anti-air combos and the like. \nThis move can be charged by holding Kick during startup. Doing so will give it an additional hit, a jumping split kick that hits both sides and blows enemies away, helpful when you're being surrounded."},
	["Dash Shoulder Tackle"] = {"An advancing shoulder tackle, strong and lifts grounded opponents off their feet. It has a very tall hurtbox, even taller than the Left Uppercut's, and inherits the above-knees invulnerability of the low dash until well into its recovery. Being done from a low dash makes this move considerably faster, but cover a bit less ground. You can also low dash through an enemy, then turn around and use the shoulder tackle to switch sides and attack that enemy from behind."},
	["Slide Kick"] = {"A leg slide that covers a great amount of ground. Enemies that are hit by this are swept off their feet. The downside is that it has few followups, takes a long time to finish, and unlike the shoulder tackle you can't turn around before using this attack, so it will always go along with the momentum."},
	["Backswing Right Hook"] = {"A dashing right-handed hook from a sway, intended to be used as a counterpunch. Stronger than the normal right hook, both in damage and in impact, and just as fast. It floats opponents for a relatively long time, allowing freeform followups. \nThis move, unlike the normal right hooks, can be charged by holding Punch during startup. Doing so will automatically follow up with a left downswing if the right hook hits. The left downswing is very powerful and can groundbounce aerial opponents, which allows for powerful juggles, but has very limited cancel options itself. Judge carefully when you can afford to use it."},
	
	["Air Left-Right Punches"] = {"Two fast punches in the air in quick succession, first a quick left gut punch and then a right straight punch. Mostly serve as combo filler to more easily set up followups, and uniquely this move can also chain back into itself. If the first hit connects, the second comes out instantly. This move can be charged to replace the second punch with a slow, but very powerful down-angled straight."},
	["Air Flying Kick"] = {"A left kick that goes straight forward. Both the forward leg and the knee in the back are part of one continuous hitbox, making it the jump-in of choice when jumping over the enemy."},
	["Air Heel Kick"] = {"Basic followup to the flying kick, resets momentum. Not sure if this gets to stay in the game."},
	["Air Sledgehammer"] = {"Two-handed haymaking hammerfist from above. Useful jumpin as it reaches far down and is somewhat disjointed. Knocks down aerial, but not immediately, so you can chain out of it and combo off that. In theory, this would be chargeable to instead transform it to a special-cancelable grab that carries an enemy from the air to the ground, probably a piledriver."},
	["Air Dive Kick"] = {"It's a divekick, everyone loves divekicks. Stalls in the air for a short time and rises a bit before going active and kicking down at great speed. This overwrites whatever momentum or gravity you had before. Knocks down on air hit and has some OTG time. This move is chargeable by holding K during startup, and the charged version is not only stronger, it is also aimable at 3 different angles by pressing forward, neutral or back while charging."},
	["Air Power Punch"] = {"Big air punch that knocks people back and really deserves a better animation. Hits high, making it somewhat bad as a jumpin. Theoretically chargeable to add on a grab that throws enemies far away behind you."},
	["Air Axe Kick"] = {"Two-hit axe kick. The first hit rises quite high, the second stays relatively high up. Not a jumpin, but an air-to-air or air combo ender. If it winds up being chargeable it would modify the second hit to be an actual jumpin though, but that's not finished as design or fixed or programmed or anything."},
	
	
	["Dash Left Jolt"] = {"A left-handed straight punch that moves you forward a great distance. Being used from a dash, it moves forward an even greater distance at has slightly more impact. \nThis move can be charged by holding Punch during startup. Doing so will automatically follow up with a Dash Right Straight if the Dash Left Jolt connects with an enemy."},
	["Dash Right Straight"] = {"A very fast right-handed straight punch. It does not have high range, but it is powerful and doesn't leave you open for long. Its vertical range is rather poor, so it doesn't hit enemies lying on the ground. Being used from a dash has increased its power, though you will transition right into a Left Swing instead of the usual standing mash combo if you press Punch again, and similarily the standing punch will be locked out of the chain."},
	
	["Right Uppercut"] = {"A chain-only move: Can't be used from a stance, only when chaining from a move that has already hit. A very powerful dashing right single-hit uppercut that launches grounded enemies. The launch is high enough to juggle off after Right Upper recovers. The downside is that Right Upper can only be canceled into specials itself, and that it recovers for a long time. Also,  Only use it when it is safe to do so. \nThis move can be charged by holding Punch during startup. Doing so will automatically follow up with a Fisherman's Slam, which grabs any opponent that has been hit by Right Upper and slams them to the ground behind you, switching sides."},
	["Axe Kick"] = {"A chain-only move: Can't be used from a stance, only when chaining from a move that has already hit. A very powerful standing axe kick, with huge damage and hitstun but slow speed and mediocre range. Recovers in time to link a fast punch on ground hit, and on air hit it provides a hard knockdown, allowing you to hit the opponent off the ground after the Axe Kick finishes. Its vertical range is huge and it reliably hits anything that's close and airborne. \nThis move can be charged by holding Kick during startup. Doing so will execute an alternate, stronger version of the axe kick that hits twice and causes a ground bounce on any hit. Its main downfall is that it is so slow it's hard to combo into."},
	
	["Sure-Kill Straight"] = {"Really big and strong punch. Covers a lot of ground, always blows back, no cancels and longish recovery."},
	["Spinning Roundhouse"] = {"Launches at an angle. Favorable hurtboxes for far anti-airs. Blows back. Has followup."},
	["Bootleg Revolver"] = {"This move does not bear resemblance to any already existing fighting game move with a 236K input. Please cease your lies."},
	["Rising Uppercut"] = {"Extremely fast uppercut, always launches. Two hits. Low hurtbox allows this move to win against basically anything that comes from above, and it's capable of juggling off air hits."},
	["Double Upkicks"] = {"Rising kicks. Bicycle kicks or however you want to call them. The total time committed is extremely high, but to compensate you get ezmode juggles and a fairly invincible reversal-esque special."},
	
	
	
}