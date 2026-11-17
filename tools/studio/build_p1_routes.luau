-- WRONG ADDRESS — acrescenta as rotas alternativas e os incidentes do P1 ao graybox do P0.
-- Executar no DataModel Edit com o graybox do P0 presente.

local history = game:GetService("ChangeHistoryService")
local map = workspace.WrongAddress.Map
local road = map.Road
local oldEast = road:FindFirstChild("Wall3East")
local oldWest = road:FindFirstChild("Wall3West")
assert(not map:FindFirstChild("P1Routes") and oldEast and oldWest, "Esperava o graybox original do P0")

local recording = history:TryBeginRecording("WA rotas do P1")
local newRoadWalls = Instance.new("Folder")
newRoadWalls.Name = "P1Entrances"
local routes = Instance.new("Folder")
routes.Name = "P1Routes"

local asphalt = Color3.fromRGB(63, 67, 70)
local rail = Color3.fromRGB(206, 130, 60)
local green = Color3.fromRGB(104, 234, 145)
local gold = Color3.fromRGB(250, 213, 115)

local function part(parent, name, size, frame, color, collide)
	local object = Instance.new("Part")
	object.Name = name
	object.Size = size
	object.CFrame = frame
	object.Color = color
	object.Material = Enum.Material.SmoothPlastic
	object.Anchored = true
	object.CanCollide = collide
	object.CanTouch = collide
	object.Parent = parent
	return object
end

local function wall(parent, name, x1, x2, z1, z2)
	return part(parent, name, Vector3.new(math.max(2,x2-x1),4,math.max(2,z2-z1)),
		CFrame.new((x1+x2)/2,2.2,(z1+z2)/2),rail,true)
end

local function buildZone(parent, name, width, length, px,pz, yaw)
	local pose = CFrame.new(px,4.2,pz) * CFrame.Angles(0,math.rad(yaw),0)
	local hit = part(parent,name,Vector3.new(width,8,length),pose,green,false)
	hit.Transparency = 1
	hit.CanQuery = false
	local paint = part(parent,name.."Paint",Vector3.new(width,0.055,length),
		pose.Rotation+CFrame.new(px,0.234,pz).Position,green,false)
	paint.Transparency = 1
	paint.CanQuery = false
	paint.Material = Enum.Material.Neon
	return hit
end

local function sign(parent, text, position, facing)
	local pose = CFrame.lookAt(position,position+facing)
	part(parent,"SignPost",Vector3.new(1,7,1),CFrame.new(position-Vector3.new(0,2,0)),rail,true)
	local board = part(parent,"Sign",Vector3.new(19,4,0.8),pose,Color3.fromRGB(30,46,47),false)
	for _, face in {Enum.NormalId.Front,Enum.NormalId.Back} do
		local gui = Instance.new("SurfaceGui")
		gui.Face = face
		gui.CanvasSize = Vector2.new(380,80)
		gui.Parent = board
		local label = Instance.new("TextLabel")
		label.BackgroundTransparency = 1
		label.Size = UDim2.fromScale(1,1)
		label.Font = Enum.Font.GothamBold
		label.TextScaled = true
		label.Text = text
		label.TextColor3 = Color3.fromRGB(243,246,231)
		label.Parent = gui
	end
	return board
end

local function lot(data)
	local folder = Instance.new("Folder")
	folder.Name = data.id
	folder.Parent = routes
	local a,b,c,d = data.x1,data.x2,data.z1,data.z2
	part(folder,"Pavement",Vector3.new(b-a,0.2,d-c),CFrame.new((a+b)/2,0.1,(c+d)/2),asphalt,true)
	wall(folder,"NorthRail",a,b,c,c)
	wall(folder,"SouthRail",a,b,d,d)
	local edge = if data.east then b else a
	wall(folder,"BackRail",edge,edge,c,d)
	local structureX = if data.east then b-11 else a+11
	part(folder,"Building",Vector3.new(16,data.height,d-c-14),CFrame.new(structureX,0.2+data.height/2,(c+d)/2),
		data.color,true)
	sign(folder,data.label,Vector3.new(data.signX,10,data.signZ),Vector3.zAxis)
	buildZone(folder,"DeliveryZone",data.w,data.l,data.x,data.z,data.yaw)
	buildZone(folder,"AlternateZone",data.aw,data.al,data.ax,data.az,data.ayaw)
	return folder
end

lot({id="Gas", label="POSTO", east=true, x1=672,x2=822,z1=-127,z2=-48,
	x=761,z=-98,w=42,l=30,yaw=90,ax=761,az=-66,aw=32,al=22,ayaw=90,
	signX=690,signZ=-113,height=13,color=Color3.fromRGB(91,145,157)})
lot({id="Store", label="CONVENIÊNCIA", east=false, x1=495,x2=624,z1=-39,z2=52,
	x=539,z=3,w=16,l=27,yaw=0,ax=574,az=27,aw=23,al=23,ayaw=0,
	signX=607,signZ=-19,height=17,color=Color3.fromRGB(157,101,134)})
lot({id="Depot", label="DEPÓSITO 2", east=true, x1=672,x2=825,z1=60,z2=139,
	x=761,z=110,w=26,l=41,yaw=90,ax=753,az=80,aw=33,al=22,ayaw=90,
	signX=693,signZ=72,height=23,color=Color3.fromRGB(153,126,85)})

buildZone(map.Destination,"AlternateZone",25,25,680,218,0)
map.Destination.Beacon.Transparency = 1
map.Destination.DeliveryZone.Transparency = 1
map.Destination.ZonePaint.Transparency = 1

-- Os vãos deixam a estrada principal intacta e abrem as entradas laterais.
for i, interval in {{-208,-110},{-57,73},{122,140}} do
	wall(newRoadWalls,"East"..i,672,672,interval[1],interval[2])
end
for i, interval in {{-160,-13},{37,140}} do
	wall(newRoadWalls,"West"..i,624,624,interval[1],interval[2])
end

local checkpoints = Instance.new("Folder")
checkpoints.Name = "RouteCheckpoints"
checkpoints.Parent = routes
for i, p in {Vector3.new(300,4.2,-100),Vector3.new(466,4.2,-184),Vector3.new(648,4.2,-140)} do
	local size = if i==2 then Vector3.new(14,8,48) else Vector3.new(48,8,22)
	local hit = part(checkpoints,"Point"..i,size,CFrame.new(p),green,false)
	hit.Transparency = 1
	hit.CanQuery = false
end

local fixtures = Instance.new("Folder")
fixtures.Name = "IncidentFixtures"
fixtures.Parent = routes
local closure = part(fixtures,"Closure",Vector3.new(2,4,20),CFrame.new(552,2.2,-171),gold,false)
local prompt = Instance.new("ProximityPrompt")
prompt.Name = "ClearPrompt"
prompt.ActionText = "Retirar barreira"
prompt.ObjectText = "Obra na pista"
prompt.KeyboardKeyCode = Enum.KeyCode.R
prompt.GamepadKeyCode = Enum.KeyCode.ButtonY
prompt.RequiresLineOfSight = false
prompt.MaxActivationDistance = 13
prompt.HoldDuration = 0.4
prompt.Enabled = false
prompt.Parent = closure
closure.Transparency = 1

local gate = part(fixtures,"StopGate",Vector3.new(2,4,48),CFrame.new(528,2.2,-184),rail,false)
gate.Transparency = 1

oldEast:Destroy()
oldWest:Destroy()
newRoadWalls.Parent = road
routes.Parent = map
if recording then history:FinishRecording(recording, Enum.FinishRecordingOperation.Commit) end
return #routes:GetDescendants()
