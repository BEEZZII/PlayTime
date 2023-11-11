ESX = nil

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000 * 60)
        local playerPed = PlayerPedId()
        TriggerServerEvent('PlayTime:AddTime', 1)
    end
end)

RegisterCommand("playtime", function(source, args, rawCommand)
    ESX.TriggerServerCallback('PlayTime:getTime', function(time)
        timeh = math.floor(time/60)
        timem = time - timeh * 60
        TriggerEvent('PlayTime:Notification', "Deine Spielzeit beträgt ".. timeh .. " Stunden und ".. timem .." Minuten.")
    end)
end)

RegisterNetEvent('PlayTime:Notification')
AddEventHandler('PlayTime:Notification', function(text)
    SetNotificationTextEntry('STRING')
    AddTextComponentString(text)
    DrawNotification(false, true)
end)