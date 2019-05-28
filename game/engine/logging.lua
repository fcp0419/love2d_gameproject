
GameLog = Object:new{
	logLines = {},
	consoleTargets = {},
	filepath = "",
	filename = "log.txt",
	fileUseTimestamp = false,
	logUseTimestamp = false,
}

LogEvent = Object:new{
	text = "",
	moment = 0,
	category = "Debug",
}

function LogEvent:toText(useTimestamp)
	pref = ""
	txt = self.text
	
	if useTimestamp then
		pref = Util.getTimestamp(self.moment, "timestamp") .. " "
	end
	
	return pref .. txt
end

function GameLog:record(txt)
	local t = os.time()
	local lev = LogEvent:new{text = txt, moment = t}
	self.logLines[#self.logLines + 1] = lev
end

function GameLog:getTarget()
	return self.filepath .. "/" .. self.filename
end

function GameLog:writeToTextFile()
	local target = self:getTarget()
	local filestr = ""
	
	if target then
		for i = 1, #self.logLines do
			local lev = self.logLines[i]
			if lev then
				local txt = lev:toText(self.logUseTimestamp)
				filestr = filestr .. txt .. "\r\n"
			end
		end
		
		love.filesystem.write(target, filestr)
	end
end


GameLogMain = GameLog:new{
	logTarget = "log/",
	filename = "game.txt",
	logUseTimestamp = true,
	fileUseTimestamp = true,
}

TestLog = GameLog:new{
	logTarget = "log/",
	filename = "_tests.txt",
	fileUseTimestamp = true,
}

function TestLog:record(txt, urgent)
	urgent = urgent or false
	if urgent then print(txt) end
	GameLog.record(TestLog, txt)
end


function record(s)
	-- prints args both in console and to the log
	
	GameLogMain:record(s)
	print(s)
	
end