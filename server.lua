ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterServerCallback('PlayTime:getGroup', function(src, cb)

    local xPlayer = ESX.GetPlayerFromId(src)
    cb(xPlayer.getGroup())
end)

ESX.RegisterServerCallback('PlayTime:getTime', function(src, cb)

    local xPlayer = ESX.GetPlayerFromId(src)
    local playtime = MySQL.Sync.fetchScalar("SELECT playtime FROM users WHERE identifier = @identifier", {['@identifier'] = xPlayer.getIdentifier()})

    cb(playtime)
end)

RegisterNetEvent('PlayTime:Top')
AddEventHandler('PlayTimeTop', function(src)
    Stats()
end)


RegisterNetEvent('PlayTime:AddTime')
AddEventHandler('PlayTime:AddTime', function(zeit)
    local xPlayer = ESX.GetPlayerFromId(source)
    local realtime = 0
    local nam = "NULL"

    local nam = GetPlayerName(source)
    local playtime = MySQL.Sync.fetchScalar("SELECT playtime FROM users WHERE identifier = @identifier", {['@identifier'] = xPlayer.getIdentifier()})
    realtime = playtime + zeit
    MySQL.Async.execute("UPDATE users SET playtime = @realt WHERE identifier = @identifier", {['@identifier'] = xPlayer.getIdentifier(), ['@realt'] = realtime})
    MySQL.Async.execute("UPDATE users SET name = @name WHERE identifier = @identifier", {['@identifier'] = xPlayer.getIdentifier(), ['@name'] = nam})
end)

function Stats()
    local text = ''
    MySQL.Async.fetchAll('SELECT * FROM users ORDER BY playtime DESC LIMIT 10', {}, function(times)
        for _,  i in pairs(times) do 
            playtimeh = math.floor(i.playtime/60)
            playtimem = i.playtime - playtimeh * 60
            text = ('%s**#%s %s** | %s %s **»** Stunden: %s | Minuten: %s\n'):format(text, _, i.name, i.firstname, i.lastname, playtimeh, playtimem)
        end
        sendDiscord('NAME', 'Top 10 Spielerzeiten', text)
    end)
end

function DDD()
    Stats()
end

function sendDiscord(author, title, text)

    url = Config.WebhookURL

    local embeds = {
        {
            ["title"] = title,
            ["type"] = "rich",
            ["color"] = 16711680,
            ["description"] = text,
            ["footer"] = {
                ["text"] = '' .. os.date('%x %X %p'),
                icon_url = Config.iconUrl
            }
        }
    }

    PerformHttpRequest(url, function(err, text, headers) end, 'POST', json.encode({username = Config.UserName, embeds = embeds}), { ['Content-Type'] = 'application/json'})
end

DDD()