Config = {
    -- Hostile Peds toggle
    HostilePeds = true,
    -- Chaos Toggle
    TotalChaos = false
}

local PED_TASK_DECOR = "_PED_TASK"
DecorRegister(PED_TASK_DECOR, 3)

local PED_WEAPON_DECOR = "_PED_WEAPON"
DecorRegister(PED_WEAPON_DECOR, 3)

PLAYER_GROUP = GetHashKey('PLAYER')

gl_peds = {}

Config.RandomWeapons = {
	"WEAPON_PISTOL", 
	"WEAPON_PISTOL_MK2", 
	"WEAPON_COMBATPISTOL",
	"WEAPON_APPISTOL",
	"WEAPON_STUNGUN",
	"WEAPON_PISTOL50",
	"WEAPON_SNSPISTOL",
	"WEAPON_SNSPISTOL_MK2",
	"WEAPON_HEAVYPISTOL",
	"WEAPON_VINTAGEPISTOL",
	"WEAPON_FLAREGUN",
	"WEAPON_MARKSMANPISTOL",
	"WEAPON_REVOLVER",
	"WEAPON_REVOLVER_MK2",
	"WEAPON_DOUBLEACTION",
	"WEAPON_RAYPISTOL",
	"WEAPON_CERAMICPISTOL",
	"WEAPON_NAVYREVOLVER",
	"WEAPON_MICROSMG", 
	"WEAPON_SMG", 
	"WEAPON_SMG_MK2",
	"WEAPON_ASSAULTSMG",
	"WEAPON_COMBATPDW",
	"WEAPON_MACHINEPISTOL",
	"WEAPON_MINISMG",
	"WEAPON_RAYCARBINE",
	"WEAPON_PUMPSHOTGUN",
	"WEAPON_PUMPSHOTGUN_MK2",
	"WEAPON_SAWNOFFSHOTGUN",
	"WEAPON_ASSAULTSHOTGUN",
	"WEAPON_BULLPUPSHOTGUN",
	"WEAPON_MUSKET",
	"WEAPON_HEAVYSHOTGUN",
	"WEAPON_DBSHOTGUN",
	"WEAPON_AUTOSHOTGUN",
	"WEAPON_ASSAULTRIFLE",
	"WEAPON_ASSAULTRIFLE_MK2", 
	"WEAPON_CARBINERIFLE", 
	"WEAPON_CARBINERIFLE_MK2",
	"WEAPON_ADVANCEDRIFLE",
	"WEAPON_SPECIALCARBINE",
	"WEAPON_SPECIALCARBINE_MK2",
	"WEAPON_BULLPUPRIFLE",
	"WEAPON_BULLPUPRIFLE_MK2",
	"WEAPON_COMPACTRIFLE",
	"WEAPON_MG",
	"WEAPON_COMBATMG",
	"WEAPON_COMBATMG_MK2",
	"WEAPON_GUSENBERG",
	"WEAPON_SNIPERRIFLE",
	"WEAPON_HEAVYSNIPER",
	"WEAPON_HEAVYSNIPER_MK2",
	"WEAPON_MARKSMANRIFLE",
	"WEAPON_MARKSMANRIFLE_MK2",
	"WEAPON_RPG", 
	"WEAPON_GRENADELAUNCHER", 
	"WEAPON_MINIGUN",
	"WEAPON_FIREWORK",
	"WEAPON_RAILGUN",
	"WEAPON_COMPACTLAUNCHER",
	"WEAPON_RAYMINIGUN",
	"WEAPON_DAGGER", 
	"WEAPON_BAT",
	"WEAPON_BOTTLE", 
	"WEAPON_CROWBAR",
	"WEAPON_FLASHLIGHT",
	"WEAPON_GOLFCLUB",
	"WEAPON_HAMMER",
	"WEAPON_HATCHET",
	"WEAPON_KNUCKLE", 
	"WEAPON_KNIFE", 
	"WEAPON_MACHETE",
	"WEAPON_SWITCHBLADE",
	"WEAPON_NIGHTSTICK", 
	"WEAPON_WRENCH",
	"WEAPON_BATTLEAXE",
	"WEAPON_POOLCUE", 
	"WEAPON_STONE_HATCHET",
	"WEAPON_BFG9000", 
	"WEAPON_FLAMETHROWER",
	"WEAPON_bow", 
}

local entityEnumerator = {
    __gc = function(enum)
      if enum.destructor and enum.handle then
        enum.destructor(enum.handle)
      end
      enum.destructor = nil
      enum.handle = nil
    end
}

EntityEnum = {}

--[[ ENTITY ITERATION STUFF ]]

local function EnumerateEntities(initFunc, moveFunc, disposeFunc)
    return coroutine.wrap(function()
        local iter, id = initFunc()
        if not id or id == 0 then
          disposeFunc(iter)
          return
        end
        
        local enum = {handle = iter, destructor = disposeFunc}
        setmetatable(enum, entityEnumerator)
        
        local next = true
        repeat
          coroutine.yield(id)
          next, id = moveFunc(iter)
        until not next
        
        enum.destructor, enum.handle = nil, nil
        disposeFunc(iter)
    end)
end

function EntityEnum.EnumeratePeds()
  return EnumerateEntities(FindFirstPed, FindNextPed, EndFindPed)
end

function EntityEnum.EnumerateObjects()
  return EnumerateEntities(FindFirstObject, FindNextObject, EndFindObject)
end

function EntityEnum.EnumerateVehicles()
  return EnumerateEntities(FindFirstVehicle, FindNextVehicle, EndFindVehicle)
end
    
function EntityEnum.EnumeratePickups()
  return EnumerateEntities(FindFirstPickup, FindNextPickup, EndFindPickup)
end
  
function GetDistanceBetweenCoords(pos1, pos2)
    local distance = GetDistanceBetweenCoords(pos1.x, pos1.y, pos1.z, pos2.x, pos2.y, pos2.z, true)

    return distance
    --return math.abs(#pos1 - #pos2)
end

local RELATIONSHIP_HATE = 5
local RELATIONSHIP_COMPANION = 0

function IsPedaPlayer(Ped)
    local isPlayer = false

    for _, playerId in ipairs(GetActivePlayers()) do
        if GetPlayerPed(playerId) == ped then
            isPlayer = true

            break
        end
    end

    return isPlayer
end

function equipPed(Ped)
	-- Not a human, or the player? Ignore it.
	if (not IsPedHuman(Ped)) or (GetPedRelationshipGroupDefaultHash(Ped)==GetHashKey('PLAYER') or GetPedRelationshipGroupHash(Ped)==GetHashKey('PLAYER')) or (GetBestPedWeapon(Ped,0)~=GetHashKey("WEAPON_UNARMED")) then 
		return
	end
    local randomPedWeapon = Config.RandomWeapons[ math.random( #Config.RandomWeapons ) ]
    
    SetPedCombatAttributes(Ped, 0, false)

	SetPedCombatAttributes(Ped, 5, true)	
	SetPedCombatAttributes(Ped, 16, true)
	SetPedCombatAttributes(Ped, 46, true)
	SetPedCombatAttributes(Ped, 26, true)
	SetPedCombatAttributes(Ped, 2, true)
	SetPedCombatAttributes(Ped, 1, true)
	SetPedCombatAttributes(Ped, 3, false)
	SetPedCombatAttributes(Ped, 52, true)
	SetPedCombatAttributes(Ped, 0, true)
    SetPedCombatAttributes(Ped, 20, true)

	SetPedDiesWhenInjured(Ped, true)
	SetPedAccuracy(Ped, 80)
	GiveWeaponToPed(Ped, GetHashKey(randomPedWeapon), 2800, false, false)
	SetPedInfiniteAmmo(Ped, true, randomPedWeapon)
	SetPedFleeAttributes(Ped, 0, 0)
	SetPedPathAvoidFire(Ped,1)
	SetPedPathCanUseLadders(Ped,1)
	SetPedPathCanDropFromHeight(Ped,1)
	SetPedPathCanUseClimbovers(Ped,1)
	SetPedAlertness(Ped,3)
	SetPedCombatRange(Ped,2)
    SetPedAllowedToDuck(Ped,1)
    
	EnableDispatchService(3, false)
    EnableDispatchService(5, false)
    
	if(randomPedWeapon == 0x42BF8A85) then
		SetPedFiringPattern(Ped, 0x914E786F) --FIRING_PATTERN_BURST_FIRE_HELI
    end
    
	ResetAiWeaponDamageModifier()
	SetAiWeaponDamageModifier(0.3) -- 1.0 == Normal Damage. 
	AddArmourToPed(Ped, 50) --<**is 100 max for npc???**
	SetPedArmour(Ped, 50)
end


Citizen.CreateThread(function()
	if Config.HostilePeds then
        print('Starting Crazy Ped Loop')

        while true do
            Citizen.Wait(250)
            
            local untilPause = 10

            for ped, pedDat in pairs(gl_peds) do
                if not DoesEntityExist(ped) or IsPedDeadOrDying(ped) then
                    gl_peds[ped] = nil
                elseif not IsPedaPlayer(ped) then
                    local PedDec = DecorGetInt(Ped, PED_TASK_DECOR)

                    if not Config.TotalChaos and PedDec ~= 3 then
                        local relationshipGroup = pedDat.RelationshipGroup
                    
                        SetRelationshipBetweenGroups(5, PLAYER_GROUP, relationshipGroup)
                        SetRelationshipBetweenGroups(5, relationshipGroup, PLAYER_GROUP)
                        DecorSetInt(Ped, PED_TASK_DECOR, 3)
                    end
                end
                
                untilPause = untilPause - 1
                if untilPause == 0 then
                    untilPause = 10
        
                    Wait(0)
                end
            end
            
            for Ped in EntityEnum.EnumeratePeds() do
                local isPlayer = relationshipGroup == PLAYER_GROUP
                local relationshipGroup = GetPedRelationshipGroupHash(Ped)

                if not IsPedaPlayer(Ped) then
                    local PedEnumDec = DecorGetInt(Ped, PED_TASK_DECOR)
                    local PedWeapDec = DecorGetInt(Ped, PED_WEAPON_DECOR)

                    local pedType = GetPedType(Ped)

                    if PedWeapDec == 0 then
                        equipPed(Ped)

                        DecorSetInt(Ped, PED_WEAPON_DECOR, 1)
                    elseif not IsPedArmed(Ped, 7) then

                        DecorSetInt(Ped, PED_WEAPON_DECOR, 0)
                    end
                    
                    if PedEnumDec == 0 then
                        for Ped2 in EntityEnum.EnumeratePeds() do
                            local relationshipGroup2 = GetPedRelationshipGroupHash(Ped2)                
                            
                            if Config.TotalChaos then
                                SetRelationshipBetweenGroups(RELATIONSHIP_HATE, relationshipGroup, relationshipGroup2)
                                SetRelationshipBetweenGroups(RELATIONSHIP_HATE, relationshipGroup2, relationshipGroup)
                                DecorSetInt(Ped, PED_TASK_DECOR, 1)                                
                            else
                                SetRelationshipBetweenGroups(RELATIONSHIP_COMPANION, relationshipGroup, relationshipGroup2)
                                SetRelationshipBetweenGroups(RELATIONSHIP_COMPANION, relationshipGroup2, relationshipGroup)
                                DecorSetInt(Ped, PED_TASK_DECOR, 2) 
                            end                
                        end                        
                    end
                end
                
                gl_peds[Ped] = {
                    IsPlayer = isPlayer,
                    RelationshipGroup = relationshipGroup
                }

                untilPause = untilPause - 1
                if untilPause < 0 then
                    untilPause = 10

                    Wait(0)
                end
            end
        end
    end
end)

--Shows a notification on the player's screen 
function ShowNotification( text )
    SetNotificationTextEntry("STRING")
    AddTextComponentSubstringPlayerName(text)
    DrawNotification(false, false)
end

RegisterCommand('chaos', function()
    if Config.TotalChaos then
        Config.TotalChaos = false
        ShowNotification("~g~[Debug] Total Chaos OFF")
	else
        Config.TotalChaos = true
        ShowNotification("~r~[Debug] Total Chaos ON")
	end
end, false)

RegisterCommand('hostile', function()
    if Config.TotalChaos then
        Config.TotalChaos = false
        ShowNotification("~g~[Debug] Hostile Peds OFF")
	else
        Config.TotalChaos = true
        ShowNotification("~r~[Debug] Hostile Peds ON")
	end
end, false)