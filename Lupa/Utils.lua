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
-- [LFF]   Curl:  2/3   AM       .     .           lvl140
-- [LFF]   Curl:  full  AM
function ParseMessage(str)
    local tbl = {};

    -- [LFF] <rgb=#00ff00>Curl</rgb>: '2/3 AM t1'
    -- LFF Curl 2/3 AM t1
    local normalizedMessage = str:gsub("%[(.*)%] %<.*%>(.*)%<.*%>: '(.*)'", "%1 %2 %3");
    local splittedMessage = StrSplit(normalizedMessage);
    local isPatternBased = #splittedMessage >= 3
        and splittedMessage[3] and splittedMessage[3]:match("%d+/[x|%d+]")
        and splittedMessage[5] and splittedMessage[5]:match("t%d[/t%d]?")
        and (not splittedMessage[6] or splittedMessage[6] and splittedMessage[6]:match("%a+[/%a+]?$"))
        and (not splittedMessage[7] or splittedMessage[7] and splittedMessage[7]:match("lvl-%d+[+]?$") or splittedMessage[7]:match("^%d+[+]?$"));

    tbl.channel = splittedMessage[1];
    tbl.owner = splittedMessage[2];
    tbl.full = normalizedMessage:match("full");
    tbl.count = splittedMessage[3];
    tbl.instance = isPatternBased and InstanceEnum[splittedMessage[4]];
    tbl.tiers = splittedMessage[5];
    tbl.roles = splittedMessage[6]
        and StrSplit(splittedMessage[6] or "any", "/")
        or { "any" };
    tbl.level = splittedMessage[7] and splittedMessage[7]:gsub("^lvl", "");
    tbl.isPatternBased = isPatternBased;

    return tbl;
end

function Filter(t, filterIter)
    local out = {}

    for k, v in pairs(t) do
        if filterIter(v, k, t) then out[k] = v end
    end

    return out
end
