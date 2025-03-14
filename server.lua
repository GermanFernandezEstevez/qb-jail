-- Inicializar QBCore
local QBCore = exports['qb-core']:GetCoreObject()

local jailTime = {}

-- Evento para aplicar la condena
RegisterNetEvent('jail:apply')
AddEventHandler('jail:apply', function(targetId, time)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src) -- Obtener los datos del jugador que ejecuta el comando

    -- Verificar si el jugador es policía y está en servicio
    if Player.PlayerData.job.name == 'police' and Player.PlayerData.job.onduty then
        local playerId = GetPlayerIdentifier(targetId, 0)

        if playerId then
            jailTime[playerId] = time * 60 -- Convertir minutos a segundos
            TriggerClientEvent('jail:notify', targetId, '¡Has sido encarcelado por ' .. time .. ' minutos!')

            Citizen.CreateThread(function()
                while jailTime[playerId] > 0 do
                    Citizen.Wait(1000) -- Un segundo
                    jailTime[playerId] = jailTime[playerId] - 1

                    -- Notifica al jugador cada minuto
                    if jailTime[playerId] % 60 == 0 then
                        TriggerClientEvent('jail:timeUpdate', targetId, math.ceil(jailTime[playerId] / 60))
                    end
                end

                jailTime[playerId] = nil
                TriggerClientEvent('jail:release', targetId, Config.ReleaseCoords)
            end)
        else
            TriggerClientEvent('chat:addMessage', src, {
                args = { 'Sistema de Jail', 'Error: No se encontró al jugador con ID ' .. targetId }
            })
        end
    else
        TriggerClientEvent('chat:addMessage', src, {
            args = { 'Sistema de Jail', 'No tienes permiso para usar este comando.' }
        })
    end
end)

-- Comando para abrir el menú
RegisterCommand('jail', function(source)
    local Player = QBCore.Functions.GetPlayer(source) -- Obtener los datos del jugador
    if Player.PlayerData.job.name == 'police' and Player.PlayerData.job.onduty then
        TriggerClientEvent('jail:openMenu', source)
    else
        TriggerClientEvent('chat:addMessage', source, {
            args = { 'Sistema de Jail', 'No tienes permiso para usar este comando.' }
        })
    end
end, false)