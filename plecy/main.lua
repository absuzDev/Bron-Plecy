ESX = nil

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
end)

local naGraczu = false
local kij = nil
local wGrze = false

RegisterNetEvent('route68_kartazdrowia:wGrze')
AddEventHandler('route68_kartazdrowia:wGrze', function(status)
  wGrze = status
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(500)
		if wGrze == true then
			local playerPed = PlayerPedId()
			local weaponHash = GetHashKey('WEAPON_BAT')
			if HasPedGotWeapon(playerPed, weaponHash, false) then
				if naGraczu and weaponHash == GetSelectedPedWeapon(playerPed) then
					naGraczu = false
					RemoveGear()
				elseif naGraczu == false and weaponHash ~= GetSelectedPedWeapon(playerPed) then
					naGraczu = true
					SetGear()
				end
			end
		end
	end
end)

RegisterNetEvent('esx:removeWeapon')
AddEventHandler('esx:removeWeapon', function(weaponName)
	if weaponName == 'WEAPON_BAT' then
		RemoveGear()
		naGraczu = false
	end
end)

-- Remove only one weapon that's on the ped
function RemoveGear()
	ESX.Game.DeleteObject(kij)
end

-- Add one weapon on the ped
function SetGear()
	local bone       = 24818
	local boneX      = 0.2
	local boneY      = -0.15
	local boneZ      = -0.07
	local boneXRot   = 0.0
	local boneYRot   = -75.0
	local boneZRot   = 0.0
	local playerPed  = PlayerPedId()
	local model      = 'w_me_bat'
	local playerData = ESX.GetPlayerData()

	ESX.Game.SpawnObject(model, {
		x = x,
		y = y,
		z = z
	}, function(object)
		local boneIndex = GetPedBoneIndex(playerPed, bone)
		local bonePos 	= GetWorldPositionOfEntityBone(playerPed, boneIndex)
		AttachEntityToEntity(object, playerPed, boneIndex, boneX, boneY, boneZ, boneXRot, boneYRot, boneZRot, false, false, false, false, 2, true)
		kij = object
	end)
end