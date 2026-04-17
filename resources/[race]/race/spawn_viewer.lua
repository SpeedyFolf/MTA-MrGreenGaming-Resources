local spawnObjects = {}
local timer = nil

local function cleanup()
	for _, obj in ipairs(spawnObjects) do
		if isElement(obj) then
			destroyElement(obj)
		end
	end
	spawnObjects = {}
	if timer and isTimer(timer) then
		killTimer(timer)
	end
end

addEvent("onRaceStateChanging", true)
addEventHandler("onRaceStateChanging", root, function(newState)
	if newState == "Running" then
		cleanup()
	end
	if newState == "PreGridCountdown" then
		cleanup()
		local spawnpoints = getElementsByType('spawnpoint',
			getResourceRootElement(exports.mapmanager:getRunningGamemodeMap()))

		for _, sp in ipairs(spawnpoints) do
			local x, y, z = getElementPosition(sp)

			local obj = createObject(1239, x, y, z) -- info sign
			setElementCollisionsEnabled(obj, false)

			table.insert(spawnObjects, obj)
		end

		-- rotation
		timer = setTimer(function()
			for _, obj in ipairs(spawnObjects) do
				if isElement(obj) then
					local rx, ry, rz = getElementRotation(obj)
					setElementRotation(obj, rx, ry, (rz + 5) % 360)
				end
			end
		end, 25, 0)
	end
end)
