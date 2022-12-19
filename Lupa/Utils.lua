function StrSplit(str, sep)
    sep = sep or "%s";
    local tbl = {};
    local i = 1;
    for str in string.gmatch(str, "([^" .. sep .. "]+)") do
        tbl[i] = str;
        i = i + 1;
    end
    return tbl;
end

-- @TODO Implement multi instance like:
-- [LFF]   Curl:  1/3   Woe/Ago  T3

-- channel owner  count instance tiers roles       level
-- [LFF]   Curl:  2/3   AM       t2/t4
-- [LFF]   Curl:  2/3   AM       .     tank/healer
-- [LFF]   Curl:  2/3   AM       .     .           100+
-- [LFF]   Curl:  full  AM
function ParseMessage(str)
    local tbl = {};

    -- [LFF] <rgb=#00ff00>Curl</rgb>: '2/3 AM t1'
    -- LFF Curl 2/3 AM t1
    local normalizedMessage = string.gsub(str, "%[(.*)%] %<.*%>(.*)%<.*%>: '(.*)'", "%1 %2 %3");
    local splittedMessage = StrSplit(normalizedMessage);
    
    tbl.channel = splittedMessage[1];
    tbl.owner = splittedMessage[2];
    tbl.full = false;

    local prev;
    for key, value in pairs(splittedMessage) do
        value = string.lower(value);
        if (key > 2) then
            -- find full ie: [full, fulled, fill, filled]
            if (string.match(value, "f[iu]ll[^ed]?")) then
                tbl.full = true;
            -- find tiers ie: [t1, T1/t2, t2/T1/t2]
            elseif (string.match(value, "^[t]%d")) then
                tbl.tiers = value; 
            -- find level ie: [lvl20, level 58+, 130+]
            elseif (string.match(prev, "l[v]?[^eve]?l") or string.match(value, "l[v]?[^eve]?l%d+[+]?")) then
                tbl.level = value;
            -- find count ie: [2/3, 1/12]
            elseif (string.match(value, "%d+/%d+") and not string.match(prev, "l[v]?[^eve]?l")) then
                tbl.count = value;
            -- find role ie: [healer tank dps]
            elseif (
                string.match(value, "heal[^er]?")
                or string.match(value, "tank[^ish]?")
                or string.match(value, "dps")
                or string.match(value, "hunter")
                or string.match(value, "rk")
                or string.match(value, "lm")
            ) then
                tbl.roles = (tbl.roles or "") .. ", " .. value;
                tbl.roles = string.gsub(tbl.roles, "^[,/%s]?(.*)[,/%s]?$", "%1");
            -- find instance ie: [am, foKd, ad, stairs]
            elseif (InstanceEnum[value]) then
                tbl.instance = value;
            end
        end
        prev = value;
    end

    return tbl;
end
