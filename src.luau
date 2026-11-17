--	Opor nico robin feet script
--	vars

if not game:IsLoaded() then game.Loaded:Wait() end

getgenv().die = true

local ver = "1.0"

local settings = 
	{
		
		["General"] = {
			["Player minimum range"] = 200,
			["Notify if admin joins/leaves"] = true,
			["Fruit spawn notifications"] = true,
			["Auto eat"] = true,
			["Keep nrfm on teleport"] = true,
		},
		
		["Auto Farm"] = {
			["Enabled"] = false,
			["Chests"] = false,
			["Reset For Keys"] = true,
			["Fruits"] = false,
			["Npcs"] = false,
			["Quests"] = false,
			["Ignore Whitelist"] = false,
			["Pause on admin"] = true,
			["Pause on crystal skull"] = true,
			["Delay"] = 0.1,
		},
	}

game.Players.LocalPlayer.OnTeleport:Connect(function()
	if settings["General"]["Keep nrfm on teleport"] == true then
		print("teleporting")
		queueteleport("https://raw.githubusercontent.com/TaterZucks/opor/refs/heads/main/src.luau'))()")
	end
end)

local whitelisteditems = {
	"String String", "Dark Dark", "Rubber Rubber", "Shine Shine", "Flame Flame", "Magma Magma", "Thunder Thunder", "Quake Quake", "Venom Venom", "Buddha Buddha", "Magnet Magnet", "Operation Operation", "Phoenix Phoenix", "Leopard Leopard", "Combat", "Den Den Mushi", "CookBook",
}

local admins = {
	"ImNotFatDad", "andrenyako", "NevermindAllen", "LoveMiraclez", "Flamingo60534", "Ampxtxte", 
}

local player = game:GetService("Players").LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local hrp = character:WaitForChild("HumanoidRootPart")

local chestfolder = workspace.Chests

local locationfolder = workspace.IslandPositions
local playercharacterfolder = workspace.Players

local runservice = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
--	init

local notificationLibrary = loadstring(game:HttpGet("https://raw.githubusercontent.com/laagginq/ui-libraries/main/xaxas-notification/src.lua"))();
local notifications = notificationLibrary.new({            
	NotificationLifetime = 10, 
	NotificationPosition = "Middle",

	TextFont = Enum.Font.Code,
	TextColor = Color3.fromRGB(255, 255, 255),
	TextSize = 15,

	TextStrokeTransparency = 0, 
	TextStrokeColor = Color3.fromRGB(0, 0, 0)
});

notifications:BuildNotificationUI();

local fruits = {}
local chests = {}

local ping = 100	
local lastfound = 0

local target_player = nil
local attacking = false

local sea = "East Blue"

if workspace:FindFirstChild("OutfitShop") then
	sea = "Grand Line"
end

local sealocations = {
	["East Blue"] = {
		["Logue Town"] = Vector3.new(-1081.958740234375, 56.79499816894531, -2419.123046875),
		["Drago"] = Vector3.new(868.479248046875, 30.079486846923828, -2325.840576171875),
		["Orange Town"] = Vector3.new(1370.15869140625, 33, -4352.71630859375),
		["Foosha"] = Vector3.new(2551.781494140625, 37.63321304321289, -1645.3421630859375),
		["Dawn Mountains"] = Vector3.new(3228.751708984375, 81.13296508789062, -1641.831787109375),
		["Goa"] = Vector3.new(3765.541015625, 95.13296508789062, -2145.052001953125),
		["Gray Terminal"] = Vector3.new(3587.48388671875, 25.34085464477539, -1980.4639892578125),
		["Conomi"] = Vector3.new(1938.9384765625, 28.036865234375, 1568.6961669921875),
		["Shells Town"] = Vector3.new(-1128.8580322265625, 137.30801391601562, 2232.428955078125),
		["Grand Line"] = Vector3.new(-2970.8974609375, 54.72252655029297, -1438.263427734375),
		["Baratie"] = Vector3.new(192.77825927734375, 9.434940338134766, -360.0166320800781),
		["Melon Archipelago"] = Vector3.new(2216.15087890625, 25266.220703125, -596.943603515625),
		["Spawn Box"] = Vector3.new(-2068.509765625, 17237.86328125, 3.4534912109375),
	},

	["Grand Line"] = {
		["Sabaody"] = Vector3.new(-8125.8076171875, 96.52044677734375, -679.267578125),
		["MB3"] = Vector3.new(-7892.5986328125, 68.630126953125, -695.2373657226562),
		["Alabasta"] = Vector3.new(-3825.8671875, 30.6904296875, -3493.1240234375),
		["Fuyu"] = Vector3.new(-1144.44580078125, 48.5577392578125, -2558.31298828125),
		["Maglandia"] = Vector3.new(-607.1116943359375, 99.43653106689453, -2893.87255859375),
		["Lighthouse"] = Vector3.new(857.60205078125, 92.8225326538086, -1051.862548828125),
		["Cactus"] = Vector3.new(-632.1568603515625, 71.73650360107422, -393.73297119140625),
		["MarineFord"] = Vector3.new(-4452.00244140625, 128.82644653320312, 3095.023681640625),
		["Ruskaina"] = Vector3.new(-1906.8623046875, 71.135009765625, 5941.50439453125),
		["RedPortEast"] = Vector3.new(-10311.2470703125, 89.07005310058594, -1858.6912841796875),
		["SeaForest"] = Vector3.new(-9876.9130859375, -918.409423828125, 547.738525390625),
		["HolyLand"] = Vector3.new(-11667.0380859375, 1433.20849609375, -1970.5953369140625),
		["FlowerRoom"] = Vector3.new(-11619.55078125, 1350.6383056640625, -1040.0023193359375),
		["RedPortWest"] = Vector3.new(-13486.861328125, 97.83900451660156, -2442.27490234375),
		["Wano"] = Vector3.new(-20008.580078125, 22.060752868652344, -2414.201171875),
		["HabuPort"] = Vector3.new(-20035.33203125, 20.196189880371094, -1981.67138671875),
		["Kibi"] = Vector3.new(-19699.421875, 7.496427536010742, -2208.056640625),
		["Hakumai"] = Vector3.new(-20211.47265625, 38.583740234375, -2250.68212890625),
		["FlowerCapital"] = Vector3.new(-19816.37890625, 20.789287567138672, -2409.82275390625),
		["Kuri"] = Vector3.new(-20012.576171875, 8.349692344665527, -2558.646484375),
		["Ebisu"] = Vector3.new(-19809.6171875, 27.794170379638672, -2579.35400390625),
		["Onigashima"] = Vector3.new(-19504.25390625, 7.7888875007629395, -3136.30859375),
		["MtFuji"] = Vector3.new(-19710.03125, 140.6366424560547, -2519.12451171875),
		["Zou"] = Vector3.new(-18708.2578125, 710.8309936523438, 2109.39599609375),
		["Hachinosu"] = Vector3.new(-15809.658203125, 54.27044677734375, 1780.712646484375),
		["Jungle"] = Vector3.new(-17692.7109375, 84.6201400756836, -209.9803466796875),
		["Dressrosa"] = Vector3.new(-14571.384765625, 151.86273193359375, -565.81201171875),
		["MB6"] = Vector3.new(-14380.1884765625, 153.81887817382812, -428.65692138671875),
		["DressrosaRoyalPalace"] = Vector3.new(-14586.5927734375, 328.8143310546875, -401.83233642578125),
		["NewWorld"] = Vector3.new(-11771.123046875, 28.172260284423828, -219.47265625),
		["Balsa"] = Vector3.new(-14750.896484375, 150.09320068359375, -544.159423828125),
		["Carta"] = Vector3.new(-14768.517578125, 53.61907958984375, -869.031494140625),
		["GreenBit"] = Vector3.new(-15216.830078125, 42.11810302734375, -312.68829345703125),
		["ImpelDown"] = Vector3.new(-15501.0771484375, -1129.520751953125, -3004.2529296875),
		["WholeCake"] = Vector3.new(-17465.9921875, 66.13818359375, -3316.000732421875),
		["Skypiea"] = Vector3.new(-4928.0234375, 4988.65185546875, -939.64306640625),
		["UpperYard"] = Vector3.new(-3864.46875, 5675.5966796875, 2033.22509765625),
		["Shandora"] = Vector3.new(-3864.46875, 5377.3974609375, 2208.525390625),
	},
}

player.CharacterAdded:Connect(function(char)
	character = char
	hrp = char:FindFirstChild("HumanoidRootPart")
end)

runservice.Heartbeat:Connect(function()
	ping = player:GetNetworkPing()
end)

game.Players.PlayerAdded:Connect(function(plr)
	if table.find(admins, plr.Name) then
		notifications:Notify("Admin joined: " .. plr.Name)
	end
end)

game.Players.PlayerRemoving:Connect(function(plr)
	if table.find(admins, plr.Name) then
		notifications:Notify("Admin left: " .. plr.Name)
	end
end)

--	functions

local function getDistance(p1, p2)
	return (p1 - p2).Magnitude
end

local function teleportClient(target:Vector3)
	if not hrp then return end
	hrp.CFrame = CFrame.new(target)
end

local function getClientPosition()
	if not hrp then return end
	return hrp.Position
end

local function loadmap()
	local a = sealocations[sea]
	local origin = getClientPosition()
	for i, v:Vector3 in pairs(a) do
		
		local modif = 300
		if i == "UpperYard" then
			modif = 1100
		end
		task.wait(ping)
		teleportClient(Vector3.new(v.X, v.Y - modif, v.Z))
	end
	teleportClient(origin)
end

local function collectChest(chest:Object, teleportBack:boolean)

	local origin = getClientPosition()
	local pos = chest:GetPivot().Position
	
	local chestsToOpen = {}
	for _, c in chests do
		if not table.find(chestsToOpen, c) then
			if getDistance(pos, c:GetPivot().Position) <= 5 then
				table.insert(chestsToOpen, c)
			end
		end
	end
	
	teleportClient(pos)
	task.wait(ping)
	local Main = chest:FindFirstChild("Main")
	if Main then
		local clickdetector = Main:FindFirstChild("ClickDetector")
		if clickdetector then
			local clickcd = chest:FindFirstChild("ClickCD")
			local active = chest:FindFirstChild("Active").value
			while not clickcd and active == true do
				task.wait(0.05)
				teleportClient(pos)
				fireclickdetector(clickdetector)
				clickcd = chest:FindFirstChild("ClickCD")
				active = chest:FindFirstChild("Active").value
				
				for _, c in chestsToOpen do
					local Main = c:FindFirstChild("Main")
					local clickdetector = Main:FindFirstChildOfClass("ClickDetector")
					if clickdetector then
						fireclickdetector(clickdetector)
						print("yea")
						clickcd = c:FindFirstChild("ClickCD")
						if clickcd then
							table.remove(chests, table.find(chests, c))
						end
					end
				end
			end
		end
	end
	if teleportBack == true then
		teleportClient(origin)
	end
end

local function collectFruit(fruit:Object, teleportBack:boolean)
	if teleportBack == nil then
		teleportBack = true
	end
	local origin = getClientPosition()
	local pos = fruit:GetPivot().Position
	teleportClient(pos)
	task.wait(ping)
	local handle = fruit:FindFirstChild("Handle")
	if handle then
		local clickdetector = handle:FindFirstChildOfClass("ClickDetector")
		if clickdetector then
			while handle do
				task.wait(0.05)
				teleportClient(pos) 
				fireclickdetector(clickdetector)
				handle = fruit:FindFirstChild("Handle")
			end
		end
	end
	local index = table.find(fruits, fruit)
	table.remove(fruits, index)
	if teleportBack then
		teleportClient(origin)
	end
end

local function getNearestIslandToPosition(pos:Vector3)
	local nearest = nil
	local nearestisland = nil
	local nearestDistance = math.huge
	for island,location:Vector3 in pairs(sealocations[sea]) do
		local distance = (location - pos).Magnitude
		if distance < nearestDistance then
			nearest = location
			nearestDistance = distance
			nearestisland = island
		end
	end
	return nearestisland
end

local searchblacklist = {
	"FlashDial",
}

local function updateFruitList()
	table.clear(fruits)
	for _,v in pairs(workspace:GetChildren()) do
		if v:IsA("Model") and not v:IsA("Tool") then

			local index = table.find(searchblacklist, v.Name)

			if v.Name ~= searchblacklist[index] then

				local instaweld = v:FindFirstChild("InstaWeld")
				if instaweld then

					local fruit = nil
					for name,value in v:GetAttributes() do
						fruit = value
					end

					if v.Name ~= fruit and fruit ~= nil then
						print("Found " .. fruit)
						v.Name = fruit

						if lastfound >= 1 then
							local nearestisland = getNearestIslandToPosition(v:GetPivot().Position)
							notifications:Notify("Found " .. fruit .. " in " .. lastfound .. " seconds at " .. nearestisland .. "!");
						end
						print("found " .. fruit .. " in " .. lastfound .. " seconds")
						lastfound = 0
					end

					table.insert(fruits, v)

				end 
			end
		end
	end
end

local function getPlayerKeys()
	local keys = {}
	for _, key in pairs(player.Backpack:GetChildren()) do
		if key.Name == "Key" then
			table.insert(keys, key)
		end
	end
	return keys
end

local function updateChestList()
	table.clear(chests)
	local chestwhitelist = {"Chest_Golden", "Chest_Emerald"}
	if #getPlayerKeys() > 0 then
		table.insert("Chest_Golden_Locked")
	end
	for _,v in pairs(chestfolder:GetChildren()) do
		if table.find(chestwhitelist, v.Name) then
			
			local requiresstring = v:FindFirstChild("RequiresString")
			local cooldown = v:FindFirstChild("ClickCD")
			local active = v:FindFirstChild("Active")
			if not cooldown and not requiresstring and active.Value == true then
				table.insert(chests, v)
			end
		end
	end
end

local function getNearestInTable(t, pos:Vector3)
	local nearest = nil
	local nearestDistance = math.huge
	for _,v in pairs(t) do
		local distance = (v:GetPivot().Position - pos).Magnitude
		if distance < nearestDistance then
			nearest = v
			nearestDistance = distance
		end
	end
	return nearest
end

local function getNearestPlayerToPosition(pos:Vector3, maxrange:number)
	local nearest = nil
	local nearestDistance = math.huge
	for _,v in pairs(game.Players:GetPlayers()) do
		if v ~= player then
			local character = v.Character
			if character and character:FindFirstChild("HumanoidRootPart") then
				local distance = (v.Character.HumanoidRootPart.Position - pos).Magnitude
				if distance < nearestDistance then
					nearest = v
					nearestDistance = distance
				end
			end
		end
	end
	if nearest and nearestDistance < maxrange then
		return nearest
	end
	return nil
end

local function dropTool(tool:Tool)
	tool.Parent = character
	task.wait(0.05)
	tool.Parent = workspace
end

local function dropUnwantedTools()
	for _,v in pairs(player.Backpack:GetChildren()) do
		if not table.find(whitelisteditems, v.Name) then
			dropTool(v)
		end
	end
end

local function getNearestUnanchoredTool()
	local nearest = nil
	local nearestDistance = math.huge
	for _,v in pairs(workspace:GetChildren()) do
		if v:IsA("Tool") then
			local handle = v:FindFirstChild("Handle")
			if handle and handle.Anchored == false then
				local distance = (handle.Position - character.HumanoidRootPart.Position).Magnitude
				if distance < nearestDistance then
					nearest = v
					nearestDistance = distance
				end
			end
		end
	end
	return nearest
end

local formatMoney = function(value)
	value = tostring(value)
	return value:reverse():gsub("%d%d%d", "%1,"):reverse():gsub("^,", "")
end

local function getDoorPuzzleChests()
	local island = workspace:FindFirstChild("Cactus Island")
	local puzzledoor = island:FindFirstChild("Puzzle Door")
	local isopen = puzzledoor:FindFirstChild("IsOpen").Value

	if not isopen then

		for _, v in pairs(island:GetChildren()) do
			if v:IsA("Tool") and v.Name == "DoorPuzzle" then

				local touchinterest = v:FindFirstChild("Handle"):FindFirstChild("TouchInterest")
				if touchinterest then
					local head = player.Character:FindFirstChild("Head")
					firetouchinterest(head, touchinterest.Parent, false)
				end

			end
		end

		for _, puzzletool in pairs(player.Backpack:GetChildren()) do
			if puzzletool:IsA("Tool") and puzzletool.Name == "DoorPuzzle" then

				local ordervalue = puzzletool:FindFirstChild("OrderVal").Value
				local humanoid = player.Character:FindFirstChild("Humanoid")

				if humanoid then
					-- solve le puzzle
					humanoid:EquipTool(puzzletool)
					task.wait(ping)

					local searchstring = "Slot_" .. ordervalue
					local slot = puzzledoor:FindFirstChild(searchstring)
				
					local event:RemoteEvent = puzzletool:FindFirstChild("LocalScript"):FindFirstChild("RemoteEvent")
					print(event.Name)
					event:FireServer(slot)

				end

			end
		end

	end
	
	-- open le chests
	local puzzlechests = {}
	for _, chest in ipairs(workspace:GetChildren("Chests")) do
		if chest:FindFirstChild("RequiresString") then
			collectChest(chest, false)
		end
	end


end

local function autoEat()
	
	local apple = player.Backpack:FindFirstChild("Apple")	
	if not apple then
		local tree = nil
		if sea == "East Blue" then
			tree = workspace["Dawn Island"]:FindFirstChild("Apple Tree")
		else
			tree = workspace.Skypiea
		end
		
		for _, apple in tree:GetChildren() do
			if apple.Name == "Apple" and apple:FindFirstChild("ClickDetector") and apple.Transparency == 0 then
				fireclickdetector(apple:FindFirstChild("ClickDetector"))
				break
			end
		end
		
	end
	
	
	--workspace.Players[player.Name].StomachV
	if character then
		if apple then
			local humanoid = character:FindFirstChild("Humanoid")
			humanoid:EquipTool(apple)
			task.wait(ping)
			
			while character:FindFirstChild("Apple") do
				local args = {
					"Eat"
				}
				game:GetService("Players").LocalPlayer.Character:WaitForChild("Apple"):WaitForChild("EatFoodItem"):FireServer(unpack(args))
				task.wait(1.5)	
			end
			
		end
	end

end

updateFruitList()
updateChestList()



print("loading ui...")
local Iris = loadstring(game:HttpGet("https://raw.githubusercontent.com/Bac0nHck/iris/refs/heads/main/Iris.luau"))()

local enabled = Iris.State(false)
local selected = Iris.State("First")
local infoenabled = Iris.State(false)
local infoselection = nil
local SelImageContent = 1
local SelImageSize = Enum.ThumbnailSize.Size420x420
local SelImageType = Enum.ThumbnailType.HeadShot

local settingstates = {}
for groupName, _ in settings do
	print(groupName)
	for key, value in settings[groupName] do
		settingstates[groupName .. "_" .. key] = Iris.State(value)
	end
end

local function buildsettings(setting)
	for key, value in pairs(settings[setting]) do
		local state = settingstates[setting .. "_" .. key]
		if type(value) == "boolean" then
			if Iris.Checkbox({ key }, { isChecked = state }).state.isChecked then
				settings[setting][key] = state.value
			end
		elseif type(value) == "number" then
			if Iris.SliderNum({ key, 0.01, 0, value*2 }, { number = state }).numberChanged() then
				settings[setting][key] = state.value
			end
		end
	end
end


Iris:Connect(function()
	local windowSize = Iris.State(Vector2.new(300, 400))

	Iris.Window({"Nrfm By Drippleton"}, {size = windowSize})
	Iris.Text({"Version: " .. ver})
	Iris.Text({"Ping: " .. math.round(ping * 1000)})
	Iris.Separator()
	
	Iris.CollapsingHeader({ "Farming" })
	do
	Iris.Text({ "Fruits: " .. #fruits })
	Iris.Text({ "Chests: " .. #chests })
	
	if Iris.Button( "Load map" ).clicked() then
		task.spawn(function()
			loadmap()
		end)
	end
	
	if Iris.Button( "puzzle" ).clicked() then
		task.spawn(function()
			getDoorPuzzleChests()
		end)
	end

	
	Iris.SeparatorText({"Settings"})
		
	buildsettings("Auto Farm")	
	
	Iris.CollapsingHeader({ "Whitelist" })
	do
		
		
		local whitelistinput = Iris.InputText({"Whitelist", "Input a item name here"})
		
		--InputText.text.value
		
		Iris.SameLine()
		do
			if Iris.Button({" Add "}).clicked() then
				table.insert(whitelisteditems, whitelistinput.text.value)
			end
			
			if Iris.Button({" Remove "}).clicked() then
				table.remove(whitelisteditems, table.find(whitelisteditems, whitelistinput.text.value))
			end
			
			if Iris.Button({" Clear "}).clicked() then
				table.clear(whitelisteditems)
			end
			
		end
		Iris.End()
		
		if Iris.Button({" Drop unwhitelisted "}).clicked() then
			coroutine.wrap(dropUnwantedTools)()
		end
		
		Iris.Tree({ "Whitelisted Items" })
		
		for _,v in pairs(whitelisteditems) do
			Iris.Text({ v })
		end
		
		Iris.End()
			
		end
		Iris.End()
	end
	Iris.End()
	
	Iris.CollapsingHeader({ "Targeting" })
	do
		Iris.Tree({ "Players" })
		for _,plr in pairs(game.Players:GetPlayers()) do
			Iris.Text({ plr.Name })
			
			Iris.SameLine()
			do
				if Iris.Button( "Teleport" ).clicked() then
					local character = plr.Character
					if character and character:FindFirstChild("HumanoidRootPart") then
						local lookvector = character.HumanoidRootPart.CFrame.LookVector
						local pos = character.HumanoidRootPart.Position + (lookvector * 2) + Vector3.new(0, 5, 0)
						teleportClient(pos)
					end
				end
				
				if Iris.Button( "Select" ).clicked() then
					target_player = plr.Name
					notifications:Notify("Selected "..plr.Name);
				end

				if Iris.Button( "Info" ).clicked() then
					
					if plr == infoselection then
						infoselection = nil
						infoenabled:set(false)
						print("closed")
					else
						infoselection = plr
						SelImageContent = game.Players:GetUserThumbnailAsync(infoselection.UserId, SelImageType, SelImageSize)
						infoenabled:set(true)
						print("opened")
					end
					
				end
			end
			Iris.End()
			
		end
		Iris.End()
		
		if Iris.Button( "Teleport nearest tool to target" ).clicked() then
			if target_player then
				local character = workspace.Players:FindFirstChild(target_player)
				
				if character and character:FindFirstChild("HumanoidRootPart") then
					local lookvector = character.HumanoidRootPart.CFrame.LookVector
					local pos = character.HumanoidRootPart.Position + (lookvector * 2) + Vector3.new(0, 5, 0)
					local nearest = getNearestUnanchoredTool(pos, 10)
					if nearest then
						local handle = nearest:FindFirstChild("Handle")
						local isnetowner = isnetworkowner(handle)
						local timeout = 0
						while not isnetowner and timeout < 100 do
							isnetowner = isnetworkowner(handle)
							task.wait(0.01)
							timeout += 1
						end
						if isnetowner then
							handle.CFrame = CFrame.new(pos)
							notifications:Notify("Teleported " .. nearest.Name .. " To " .. target_player)
						else
							notifications:Notify("Failed to teleport " .. nearest.Name .. " To " .. target_player.Name)
						end
					end
				end		
			end
		end
	end
	Iris.End()
	
	Iris.CollapsingHeader({ "Teleporting" })
	do
		Iris.Tree({ "Devil Fruits" })
		for _, df:Model in fruits do
			local nearestisland = getNearestIslandToPosition(df:GetPivot().Position)
			local str = df.Name .. " (" .. tostring(nearestisland) .. ")"
			if Iris.Button({str}).clicked() then
				print("teleport " .. df.Name)
				teleportClient(df:GetPivot().Position)
			end
		end
		Iris.End()

		Iris.Tree({ "Islands" })
		Iris.Text({ sea })
		for island, position:Vector3 in pairs(sealocations[sea]) do
			if Iris.Button({island}).clicked() then
				print("teleport " .. island)
				teleportClient(position)
			end
		end
		Iris.End()
	end
	Iris.End()
	
	Iris.End()
end)

Iris:Connect(function()
	if infoenabled:get() then
		Iris.Window({"Data for: " .. infoselection.Name}, {size = Vector2.new(175, 200)})
		
		local race = 	"unknown"
		local role =	"unknown"
		local faction = "unknown"
		local df = 		"unknown"
		local style =	"unknown"
		
		local char = playercharacterfolder:FindFirstChild(infoselection.Name)
		if char then
			race = char:FindFirstChild("Race").Value
			role = char:FindFirstChild("Role").Value
			faction = char:FindFirstChild("Faction").Value
			
			local humanoid = char:FindFirstChild("Humanoid")
			if humanoid then
				df = humanoid:FindFirstChild("DF")
				if df then
					df = df:FindFirstChild("DFType").Value
				else
					df = "None"
				end
				style = humanoid:FindFirstChild("Style").Value
			end
		end
		
		Iris.Group()
		do
			Iris.Image({
				SelImageContent,
				UDim2.fromOffset(48, 48),
			})
			
			Iris.Text({"DF: " .. df})
			Iris.Text({"Style: " .. style})
			Iris.Text({"Race: " .. race})
			Iris.Text({"Faction: " .. faction})
		end
		Iris.End()
		
		local rep = infoselection:FindFirstChild("Reputation").Value
		
		if rep then
			rep = formatMoney(rep)
		else
			rep = "unknown"
		end
		
		local value = infoselection:FindFirstChild("CurrentInventoryVal").Value
		if not value then
			value = "unknown"
		end
		
		local playtime = infoselection:FindFirstChild("PlayTime").Value
		if not playtime then
			playtime = "unknown"
		end
		
		Iris.Separator()
		Iris.Text({"Rep: " .. rep})
		Iris.Text({"Inventory: " .. value .. " items"})
		Iris.Text({"Serv playtime: " .. playtime .. " minutes"})
		
		Iris.Separator()
		
		Iris.Tree({ "Extra" })
		for _, v in ipairs(char:GetDescendants()) do
			
			if v:IsA("NumberValue") then
				Iris.Text({v.Name .. ": " .. v.Value})
			end
			
			if v:IsA("StringValue") then
				Iris.Text({v.Name .. ": " .. v.Value})
			end
			
			if v:IsA("BoolValue") then
				Iris.Text({v.Name .. ": " .. tostring(v.Value)})
			end
			
			if v:IsA("IntValue") then
				Iris.Text({v.Name .. ": " .. v.Value})
			end
			
		end
		Iris.End()
		
		Iris.End()
	end
end)

--[[

-- observation focus
function getNil(name,class) for _,v in next, getnilinstances()do if v.ClassName==class and v.Name==name then return v;end end end

local args = {
	vector.create(3344.46533203125, 73.03472137451172, -1593.021484375),
	Instance.new("Part", nil)
}
Instance.new("RemoteEvent", nil):FireServer(unpack(args))

game:GetService("Players").LocalPlayer:WaitForChild("Dash_Keyboard")
game:GetService("Players").LocalPlayer:WaitForChild("RemoteEvent")
-- crasher
local args = {
	"Forward",
	"Dash",
	CFrame.new(3403.466796875, 83.85737609863281, -1501.88232421875, -0.7980515360832214, -0.07251249253749847, 0.5982103943824768, -0.05307016894221306, 0.9973335266113281, 0.05009343475103378, -0.6002476811408997, 0.008230017498135567, -0.7997718453407288),
	8.278173446655273,
	0.5,
	false
}
game:GetService("Players").LocalPlayer:WaitForChild("Backpack"):WaitForChild("Dash_Mobile"):WaitForChild("RemoteEvent"):FireServer(unpack(args))

game:GetService("Players").LocalPlayer:WaitForChild("M1")
local args = {
	"Combo",
	[3] = {
		HoldingRMB = false,
		DbgSeq = 29,
		DbgTime = 1794623696.744453
	}
}
game:GetService("Players").LocalPlayer:WaitForChild("Backpack"):WaitForChild("Combat"):WaitForChild("CombatHandler"):WaitForChild("M1"):FireServer(unpack(args))


]]

function autoAttack(npc:Model)
	attacking = true
	local humanoid:Humanoid = npc:FindFirstChild("Humanoid")
	local clienthumanoid = character:FindFirstChild("Humanoid")
	
	while humanoid and humanoid.Health > 0 and attacking do
		
		task.wait(0.01)
		local pos = npc.HumanoidRootPart.Position
		local back = pos - (npc.HumanoidRootPart.CFrame.LookVector * 2)
		local finalpos = CFrame.new(back, pos)
		
		local combat = character:FindFirstChild("Combat")
		if not combat then
			combat = player.Backpack:FindFirstChild("Combat")
			clienthumanoid:EquipTool(combat)
		end
		
		if combat then
			local event = combat:FindFirstChild("CombatHandler"):FindFirstChild("M1")
			if event and hrp then
				
				hrp.CFrame = finalpos
				
				local partialinvincibility = npc:FindFirstChild("PartialInvincibility")
				if not partialinvincibility then
					local args = {
						"Combo",
						[3] = {
							HoldingRMB = false,
							DbgSeq = 29,
							DbgTime = 1794623696.744453
						}
					}
					event:FireServer(unpack(args))
				end
			end
		else
			print("no combat tool")
			attacking = false
		end
	end
	attacking = false
end

-- Loop
getgenv().die = false
notifications:Notify("Nrfm loaded");

while task.wait(0.1) do
	updateFruitList()
	updateChestList()
	
	if settings["Auto Farm"].Enabled == false then
		attacking = false
	end

	lastfound += 1

	if die then
		print("dead")
		settings["Auto Farm"].Enabled = false
		script:Destroy()
		break
	end

	-- farm stuff
	
	local plrs = game.Players:GetPlayers()
	local continue = true
	
	for _, plr in plrs do
		if plr ~= player then
			if table.find(admins, plr.Name) then
				continue = false
				print("admin")
			end
			-- check backpacks and characters for crystal skull
			local char = plr.Character
			local backpack = plr.Backpack

			for _, item in backpack:GetChildren() do
				if item.Name == "CrystalSkull" then
					continue = false
					print("skull")
				end
			end

			if char then
				for _, item in char:GetChildren() do
					if item.Name == "CrystalSkull" then
						continue = false
						print("skull")
					end
				end
			end
		end
	end
	
	if not character:FindFirstChild("Combat") then
		if settings["General"]["Auto eat"] then
			if character:FindFirstChild("StomachV").Value < 90 then
				autoEat()
			end
		end
	end
	
	
	if settings["Auto Farm"].Enabled == true and continue == true then

		-- Make sure a player is not near the target
		local origin:Vector3 = getClientPosition()
		local tp = false

		-- make sure there isnt a enemy player near us

		local nearest = getNearestPlayerToPosition(origin, settings.General["Player minimum range"])
		if nearest then
			print("player nearby")
		else
			if settings["Auto Farm"].Fruits then

				for _,v in pairs(fruits) do
					
					local conti = false
					if whitelisteditems[v.Name] then
						conti = true
					end
					
					if settings["Auto Farm"]["Ignore Whitelist"] then
						conti = true
					end
					
					if conti then
						local target:Model = getNearestInTable(fruits, origin)
						local targetpos = target:GetPivot().Position
						local nearestPlayer = getNearestPlayerToPosition(targetpos, settings.General["Player minimum range"])
						if nearestPlayer then
							print("player near fruit: ".. nearestPlayer.Name)
						else
							collectFruit(target, false)
							tp = true
						end
					end
				end
			end

			if settings["Auto Farm"].Chests then

				for _, v in pairs(chests) do
					if table.find(chests, v) then
						local target:Model = getNearestInTable(chests, origin)
						local targetpos = target:GetPivot().Position
						local nearestPlayer = getNearestPlayerToPosition(targetpos, settings.General["Player minimum range"])
						if nearestPlayer then
							print("player near chest: ".. nearestPlayer.Name)
							table.remove(chests, table.find(chests, v))
							continue
						else
							collectChest(target, false)
							tp = true
						end
					end
				end
				if tp then
					teleportClient(origin)
				end
			end
		end
	end
	
	if settings["Auto Farm"].Npcs then
		
		if attacking == false then
			local npc = workspace:FindFirstChild("Players"):FindFirstChild("Bandit")
			if npc then
				autoAttack(npc)
			end
		end
	else
		attacking = false
	end
end
