-- WRONG ADDRESS — P0-02: graybox do mapa.
-- Como usar: executar no datamodel Edit do Studio (via MCP execute_luau ou barra de comandos).
-- Recusa rodar se Workspace.WrongAddress.Map ja tiver conteudo; para refazer, apague os
-- filhos de Map antes. Tudo e ancorado. Mundo plano sobre a Baseplate (topo em y = 0).
-- Dimensoes derivam do ADR-002: van de 8 x 16 studs, raio de curva ~28 a 45 studs/s.

local CHS = game:GetService("ChangeHistoryService")

-- Parametros --------------------------------------------------------------
local HALF_ROAD = 24 -- pista de 48 studs de largura
local FLOOR_TOP = 0.2 -- topo do asfalto
local WALL_HEIGHT = 4
local FENCE_HEIGHT = 6
local WALL_THICKNESS = 2

local DEPOT = { x0 = 230, x1 = 370, z0 = 140, z1 = 260 }
local DEST = { x0 = 588, x1 = 708, z0 = 140, z1 = 260 }
local ROAD1_X, ROAD3_X = 300, 648 -- eixos das retas norte-sul
local ROAD2_Z = -184 -- eixo da reta leste-oeste
local ROAD_NORTH_END = ROAD2_Z + HALF_ROAD -- z onde as retas norte-sul encontram os cantos
local ARENA = { x0 = 400, x1 = 560, z0 = -328, z1 = ROAD2_Z - HALF_ROAD }
local BUMP_X = 470

local COLOR = {
	road = Color3.fromRGB(58, 60, 66),
	pad = Color3.fromRGB(86, 88, 96),
	arena = Color3.fromRGB(84, 122, 78),
	wall = Color3.fromRGB(214, 133, 48),
	fence = Color3.fromRGB(150, 110, 70),
	bump = Color3.fromRGB(240, 205, 60),
	depot = Color3.fromRGB(96, 122, 160),
	house = Color3.fromRGB(176, 84, 72),
	zone = Color3.fromRGB(70, 220, 120),
	beacon = Color3.fromRGB(120, 255, 170),
}

-- Execucao ----------------------------------------------------------------
local container = workspace:FindFirstChild("WrongAddress")
local map = container and container:FindFirstChild("Map")
if not map then
	return "ABORTADO: Workspace.WrongAddress.Map nao existe (rode o P0-01 antes)"
end
if #map:GetChildren() > 0 then
	return "ABORTADO: Map ja tem conteudo; nada foi alterado"
end

local rec = CHS:TryBeginRecording("WA P0-02 graybox")
local ok, result = pcall(function()
	local function folder(name, parent)
		local f = Instance.new("Folder")
		f.Name = name
		return f, parent
	end
	local pendingParents = {}
	local function newFolder(name, parent)
		local f = folder(name, parent)
		table.insert(pendingParents, { f, parent })
		return f
	end

	local function part(name, size, cf, color, parent, props)
		local p = Instance.new("Part")
		p.Name = name
		p.Size = size
		p.CFrame = cf
		p.Color = color
		p.Anchored = true
		p.Material = Enum.Material.SmoothPlastic
		p.TopSurface = Enum.SurfaceType.Smooth
		p.BottomSurface = Enum.SurfaceType.Smooth
		if props then
			for key, value in props do
				(p :: any)[key] = value
			end
		end
		p.Parent = parent
		return p
	end

	-- piso retangular entre (x0,z0) e (x1,z1)
	local function floor(name, x0, x1, z0, z1, color, parent)
		return part(name, Vector3.new(math.abs(x1 - x0), FLOOR_TOP, math.abs(z1 - z0)),
			CFrame.new((x0 + x1) / 2, FLOOR_TOP / 2, (z0 + z1) / 2), color, parent)
	end

	-- mureta alinhada a um eixo, de (xa,za) ate (xb,zb)
	local function wall(name, xa, za, xb, zb, parent, height, color)
		local h = height or WALL_HEIGHT
		local sizeX = math.max(math.abs(xb - xa), WALL_THICKNESS)
		local sizeZ = math.max(math.abs(zb - za), WALL_THICKNESS)
		return part(name, Vector3.new(sizeX, h, sizeZ),
			CFrame.new((xa + xb) / 2, FLOOR_TOP + h / 2, (za + zb) / 2), color or COLOR.wall, parent)
	end

	local function marker(name, cf, parent)
		return part(name, Vector3.new(2, 1, 2), cf, Color3.new(1, 1, 1), parent,
			{ Transparency = 1, CanCollide = false, CanTouch = false, CanQuery = false, CastShadow = false })
	end

	local depot = newFolder("Depot", map)
	local road = newFolder("Road", map)
	local arena = newFolder("EscapeArena", map)
	local destination = newFolder("Destination", map)
	local markers = newFolder("Markers", map)

	local r1x0, r1x1 = ROAD1_X - HALF_ROAD, ROAD1_X + HALF_ROAD
	local r3x0, r3x1 = ROAD3_X - HALF_ROAD, ROAD3_X + HALF_ROAD
	local r2z0, r2z1 = ROAD2_Z - HALF_ROAD, ROAD2_Z + HALF_ROAD

	-- Deposito
	floor("Floor", DEPOT.x0, DEPOT.x1, DEPOT.z0, DEPOT.z1, COLOR.pad, depot)
	wall("WallSouth", DEPOT.x0, DEPOT.z1, DEPOT.x1, DEPOT.z1, depot)
	wall("WallWest", DEPOT.x0, DEPOT.z0, DEPOT.x0, DEPOT.z1, depot)
	wall("WallEast", DEPOT.x1, DEPOT.z0, DEPOT.x1, DEPOT.z1, depot)
	wall("WallNorthA", DEPOT.x0, DEPOT.z0, r1x0, DEPOT.z0, depot)
	wall("WallNorthB", r1x1, DEPOT.z0, DEPOT.x1, DEPOT.z0, depot)
	part("Building", Vector3.new(90, 22, 10), CFrame.new(ROAD1_X, FLOOR_TOP + 11, DEPOT.z1 - 7), COLOR.depot, depot)

	-- Pista: reta 1 (norte), canto 1, reta 2 (leste), canto 2, reta 3 (sul)
	floor("Road1", r1x0, r1x1, ROAD_NORTH_END, DEPOT.z0, COLOR.road, road)
	floor("Corner1", r1x0, r1x1, r2z0, r2z1, COLOR.road, road)
	floor("Road2", r1x1, r3x0, r2z0, r2z1, COLOR.road, road)
	floor("Corner2", r3x0, r3x1, r2z0, r2z1, COLOR.road, road)
	floor("Road3", r3x0, r3x1, ROAD_NORTH_END, DEST.z0, COLOR.road, road)
	wall("Wall1West", r1x0, DEPOT.z0, r1x0, r2z0, road)
	wall("Wall1East", r1x1, DEPOT.z0, r1x1, r2z1, road)
	wall("Wall2South", r1x1, r2z1, r3x0, r2z1, road)
	wall("Wall2NorthA", r1x0, r2z0, ARENA.x0, r2z0, road)
	wall("Wall2NorthB", ARENA.x1, r2z0, r3x1, r2z0, road)
	wall("Wall3West", r3x0, r2z1, r3x0, DEST.z0, road)
	wall("Wall3East", r3x1, r2z0, r3x1, DEST.z0, road)
	part("Bump", Vector3.new(HALF_ROAD * 2, 3, 3),
		CFrame.new(BUMP_X, FLOOR_TOP - 1, ROAD2_Z) * CFrame.Angles(0, math.rad(90), 0), COLOR.bump, road,
		{ Shape = Enum.PartType.Cylinder })

	-- Arena de fuga: campo cercado ao norte da reta 2, aberto para a pista
	floor("Floor", ARENA.x0, ARENA.x1, ARENA.z0, ARENA.z1, COLOR.arena, arena)
	local fence = newFolder("Fence", arena)
	wall("FenceWest", ARENA.x0, ARENA.z0, ARENA.x0, ARENA.z1, fence, FENCE_HEIGHT, COLOR.fence)
	wall("FenceEast", ARENA.x1, ARENA.z0, ARENA.x1, ARENA.z1, fence, FENCE_HEIGHT, COLOR.fence)
	wall("FenceNorth", ARENA.x0, ARENA.z0, ARENA.x1, ARENA.z0, fence, FENCE_HEIGHT, COLOR.fence)
	part("Trigger", Vector3.new(6, 8, HALF_ROAD * 2), CFrame.new(BUMP_X + 6, FLOOR_TOP + 4, ROAD2_Z),
		Color3.fromRGB(255, 80, 80), arena, { Transparency = 1, CanCollide = false, CastShadow = false })
	local waypoints = newFolder("Waypoints", arena)
	local arenaMidX, arenaMidZ = (ARENA.x0 + ARENA.x1) / 2, (ARENA.z0 + ARENA.z1) / 2
	local points = {
		{ ARENA.x0 + 20, ARENA.z1 - 22 }, { ARENA.x1 - 20, ARENA.z1 - 22 },
		{ ARENA.x0 + 20, ARENA.z0 + 20 }, { ARENA.x1 - 20, ARENA.z0 + 20 },
		{ arenaMidX, arenaMidZ }, { arenaMidX, ARENA.z0 + 14 },
	}
	for index, point in points do
		marker("W" .. index, CFrame.new(point[1], FLOOR_TOP + 1.5, point[2]), waypoints)
	end
	marker("SafePoint", CFrame.new(arenaMidX, FLOOR_TOP + 1.5, ARENA.z1 - 40), arena)

	-- Destino
	floor("Floor", DEST.x0, DEST.x1, DEST.z0, DEST.z1, COLOR.pad, destination)
	wall("WallSouth", DEST.x0, DEST.z1, DEST.x1, DEST.z1, destination)
	wall("WallWest", DEST.x0, DEST.z0, DEST.x0, DEST.z1, destination)
	wall("WallEast", DEST.x1, DEST.z0, DEST.x1, DEST.z1, destination)
	wall("WallNorthA", DEST.x0, DEST.z0, r3x0, DEST.z0, destination)
	wall("WallNorthB", r3x1, DEST.z0, DEST.x1, DEST.z0, destination)
	part("House", Vector3.new(44, 26, 10), CFrame.new(ROAD3_X, FLOOR_TOP + 13, DEST.z1 - 7), COLOR.house, destination)
	local zoneZ = DEST.z0 + 60
	part("DeliveryZone", Vector3.new(36, 8, 48), CFrame.new(ROAD3_X, FLOOR_TOP + 4, zoneZ), COLOR.zone, destination,
		{ Transparency = 0.82, Material = Enum.Material.ForceField, CanCollide = false, CanTouch = false, CanQuery = false, CastShadow = false })
	part("ZonePaint", Vector3.new(36, 0.06, 48), CFrame.new(ROAD3_X, FLOOR_TOP + 0.03, zoneZ), COLOR.zone, destination,
		{ CanCollide = false, CanTouch = false, CanQuery = false, CastShadow = false })
	part("Beacon", Vector3.new(2, 140, 2), CFrame.new(ROAD3_X, FLOOR_TOP + 96, DEST.z1 - 7), COLOR.beacon, destination,
		{ Material = Enum.Material.Neon, Transparency = 0.35, CanCollide = false, CanTouch = false, CanQuery = false, CastShadow = false })

	-- Marcadores (invisiveis; a frente de cada um e o LookVector)
	local function facing(x, z, dirX, dirZ, y)
		local position = Vector3.new(x, y or (FLOOR_TOP + 0.5), z)
		return CFrame.lookAt(position, position + Vector3.new(dirX, 0, dirZ))
	end
	marker("VanSpawn", facing(ROAD1_X, DEPOT.z0 + 55, 0, -1), markers)
	marker("CargoSpawn", facing(ROAD1_X - 32, DEPOT.z0 + 50, 1, 0, FLOOR_TOP + 1.5), markers)
	local recover = newFolder("RecoverPoints", markers)
	local recoverPoints = {
		{ ROAD1_X, 60, 0, -1 }, { ROAD1_X, -100, 0, -1 },
		{ ARENA.x0 - 30, ROAD2_Z, 1, 0 }, { ARENA.x1 + 30, ROAD2_Z, 1, 0 },
		{ ROAD3_X, -100, 0, 1 }, { ROAD3_X, 60, 0, 1 },
	}
	for index, point in recoverPoints do
		marker("R" .. index, facing(point[1], point[2], point[3], point[4]), recover)
	end

	-- Spawn do jogador: reaproveita o SpawnLocation do template, se existir
	local spawn = workspace:FindFirstChild("SpawnLocation")
	if not (spawn and spawn:IsA("SpawnLocation")) then
		spawn = Instance.new("SpawnLocation")
		spawn.Size = Vector3.new(12, 1, 12)
		spawn.Anchored = true
	end
	spawn.Name = "PlayerSpawn"
	spawn.CFrame = facing(ROAD1_X - 40, DEPOT.z0 + 85, 1, 0, FLOOR_TOP + 0.5)
	spawn.Parent = markers

	-- Pastas entram no DataModel por ultimo, da mais interna para a mais externa
	for index = #pendingParents, 1, -1 do
		pendingParents[index][1].Parent = pendingParents[index][2]
	end
	task.wait()

	local parts, unanchored = 0, 0
	for _, descendant in map:GetDescendants() do
		if descendant:IsA("BasePart") then
			parts += 1
			if not descendant.Anchored then
				unanchored += 1
			end
		end
	end
	local routeLength = (DEPOT.z0 + 55 - ROAD_NORTH_END) + HALF_ROAD * 2 + (r3x0 - r1x1) + (zoneZ - ROAD_NORTH_END)
	return ("OK | BaseParts no Map=%d | nao ancoradas=%d | percurso aproximado=%d studs"):format(parts, unanchored, routeLength)
end)
if rec then
	CHS:FinishRecording(rec, if ok then Enum.FinishRecordingOperation.Commit else Enum.FinishRecordingOperation.Cancel)
end
if not ok then
	return "ERRO: " .. tostring(result)
end
return result
