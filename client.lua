-- Inicializar QBCore
local QBCore = exports['qb-core']:GetCoreObject()

-- Evento que abre el menú
RegisterNetEvent('jail:openMenu')
AddEventHandler('jail:openMenu', function()
    local Player = QBCore.Functions.GetPlayerData() -- Obtener los datos del jugador
    if Player.job.name == 'police' and Player.job.onduty then
        SetNuiFocus(true, true) -- Activa el enfoque para interactuar con la interfaz gráfica
        SendNUIMessage({
            action = 'openMenu' -- Indica a la interfaz que abra el menú
        })
    else
        TriggerEvent('chat:addMessage', {
            args = { 'Sistema de Jail', 'No tienes permiso para usar este comando.' }
        })
    end
end)

-- Evento de cierre del menú
RegisterNUICallback('closeMenu', function(_, cb)
    SetNuiFocus(false, false) -- Desactiva el enfoque del menú
    SendNUIMessage({
        action = 'closeMenu' -- Indica a la interfaz que oculte el menú
    })
    cb('ok') -- Notifica que la acción fue completada
end)

-- Comando para abrir el menú
RegisterCommand('jail', function()
    local Player = QBCore.Functions.GetPlayerData() -- Obtener los datos del jugador
    if Player.job.name == 'police' and Player.job.onduty then
        SetNuiFocus(true, true) -- Activa el enfoque solo al usar el comando
        SendNUIMessage({
            action = 'openMenu'
        })
    else
        TriggerEvent('chat:addMessage', {
            args = { 'Sistema de Jail', 'No tienes permiso para usar este comando.' }
        })
    end
end, false)

-- Manejar los datos enviados desde el menú
RegisterNUICallback('sendJailData', function(data, cb)
    local playerId = tonumber(data.playerId)
    local time = tonumber(data.time)

    if playerId and time then
        TriggerServerEvent('jail:apply', playerId, time)
        TriggerEvent('chat:addMessage', {
            args = { 'Sistema de Jail', 'Jugador encarcelado correctamente.' }
        })
    else
        TriggerEvent('chat:addMessage', {
            args = { 'Sistema de Jail', 'Error: Datos inválidos. Revisa los campos.' }
        })
    end
    SetNuiFocus(false, false) -- Cierra la interfaz después de enviar los datos
    cb('ok')
end)
-- Teletransportar al jugador al vector3 de liberación
RegisterNetEvent('jail:release')
AddEventHandler('jail:release', function(releaseCoords)
    SetEntityCoords(PlayerPedId(), releaseCoords.x, releaseCoords.y, releaseCoords.z, false, false, false, true)
    TriggerEvent('chat:addMessage', {
        args = { 'Sistema de Jail', '¡Has cumplido tu condena!' }
    })
end)

RegisterNetEvent('jail:timeUpdate')
AddEventHandler('jail:timeUpdate', function(minutesLeft)
    TriggerEvent('chat:addMessage', {
        args = { 'Sistema de Jail', 'Te quedan ' .. minutesLeft .. ' minutos de condena.' }
    })
end)
