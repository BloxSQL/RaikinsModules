
local TimeControl = {}

local function toSeconds(package)
    local years = package.years or 0
    local months = package.months or 0
    local days = package.days or 0
    local hours = package.hours or 0
    local minutes = package.minutes or 0
    local seconds = package.seconds or 0
    local milliseconds = package.milliseconds or 0

    local secondsInYear = 31536000
    local secondsInMonth = 2592000
    local secondsInDay = 86400
    local secondsInHour = 3600
    local secondsInMinute = 60
    local secondsInMillisecond = 1 / 1000

    return (years * secondsInYear) +
           (months * secondsInMonth) +
           (days * secondsInDay) +
           (hours * secondsInHour) +
           (minutes * secondsInMinute) +
           (seconds) +
           (milliseconds * secondsInMillisecond)
end

function TimeControl.TimeCreate(package)
    return toSeconds(package)
end

function TimeControl.CreateTimestamp()
    local time = os.date("*t")
    local ampm = time.hour >= 12 and 'P' or 'A'
    local hour = time.hour % 12
    hour = hour == 0 and 12 or hour
    local formattedHour = string.format("%02d", hour)
    local formattedMinute = string.format("%02d", time.min)
    local formattedSecond = string.format("%02d", time.sec)
    local formattedMonth = string.format("%02d", time.month)
    local formattedDay = string.format("%02d", time.day)
    local formattedYear = string.format("%04d", time.year)

    return string.format("T%s%s%s%s%s%s%s%s", ampm, formattedMonth, formattedDay, formattedYear, formattedHour, formattedMinute, formattedSecond)
end

function TimeControl.DecompressTimestamp(timestampString)
    local ampm = timestampString:sub(2, 2)
    local month = tonumber(timestampString:sub(3, 4))
    local day = tonumber(timestampString:sub(5, 6))
    local year = tonumber(timestampString:sub(7, 10))
    local hour = tonumber(timestampString:sub(11, 12))
    local minute = tonumber(timestampString:sub(13, 14))
    local second = tonumber(timestampString:sub(15, 16))

    if ampm == 'P' then
        hour = (hour % 12) + 12
    elseif ampm == 'A' and hour == 12 then
        hour = 0
    end

    return {
        year = year,
        month = month,
        day = day,
        hour = hour,
        minute = minute,
        second = second
    }
end

function TimeControl.TimeStampCompare(timestamp1, timestamp2)
    local time1 = TimeControl.DecompressTimestamp(timestamp1)
    local time2 = TimeControl.DecompressTimestamp(timestamp2)

    local t1 = os.time({
        year = time1.year,
        month = time1.month,
        day = time1.day,
        hour = time1.hour,
        min = time1.minute,
        sec = time1.second
    })

    local t2 = os.time({
        year = time2.year,
        month = time2.month,
        day = time2.day,
        hour = time2.hour,
        min = time2.minute,
        sec = time2.second
    })

    return math.abs(t2 - t1)
end

function TimeControl.TimeCheck(seconds, type)
    local actions = {
        [1] = function() return seconds / 2592000 end,
        [2] = function() return seconds / 31536000 end,
        [3] = function() return seconds / 86400 end,
        [4] = function() return seconds / 3600 end,
        [5] = function() return seconds / 60 end,
        [6] = function() return seconds end,
        [7] = function() return seconds * 1000 end
    }

    local action = actions[type]
    if action then
        return action()
    else
        return "Invalid type"
    end
end

function TimeControl.FutureTimestamp(timeData)
    local currentTime = os.date("*t")

    local futureTime = {
        year = currentTime.year + (timeData.years or 0),
        month = currentTime.month + (timeData.months or 0),
        day = currentTime.day + (timeData.days or 0),
        hour = currentTime.hour + (timeData.hours or 0),
        min = currentTime.min + (timeData.minutes or 0),
        sec = currentTime.sec + (timeData.seconds or 0)
    }

    futureTime.month = futureTime.month % 12
    futureTime.year = futureTime.year + math.floor(futureTime.month / 12)
    futureTime.day = futureTime.day % 31

    local timestamp = os.time({
        year = futureTime.year,
        month = futureTime.month,
        day = futureTime.day,
        hour = futureTime.hour,
        min = futureTime.min,
        sec = futureTime.sec
    })

    return TimeControl.CreateTimestamp()
end

return TimeControl
