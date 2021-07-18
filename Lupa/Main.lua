-- https://www.tutorialspoint.com/execute_lua_online.php
import "Turbine";

import "GuardioesDeArda.Lupa";
import "GuardioesDeArda.Lupa.Dictionary";

LockSettings = {
    window = {
        left = 840,
        top = 300,
        width = 540,
        height = 400,
    },
};

lffList = {};

lupa = LupaWindow();

-- INI Utils ------------------------------------------------------------------------------------------------
function strsplit( str, sep )
    sep = sep or "%s";
    local tbl = {};
    local i = 1;
    for str in string.gmatch( str, "([^" .. sep .. "]+)" ) do
        tbl[i] = str;
        i = i + 1;
    end
    return tbl;
end

function allmatching( tbl, kvs )
    return function( t, key )
        repeat
            key, row = next( t, key );
            if key == nil then
                return;
            end
            for k, v in pairs(kvs) do
                if row[k] ~= v then
                    row = nil;
                    break;
                end
            end
        until row ~= nil;
        return key, row;
    end, tbl, nil
end

function striptag( str )
    str = str or "";
    return str:gsub( ".+>(.+)<.+", "%1" )
end

-- @TODO Remove message width timieout
-- @TODO Implement multi instance like:
-- [LFF]   Curl:  1/3   Woe/Ago  T3

-- channel owner  count instance tiers roles       level
-- [LFF]   Curl:  2/3   AM       t2/t4
-- [LFF]   Curl:  2/3   AM       .     tank/healer
-- [LFF]   Curl:  2/3   AM       .     .           100+
-- [LFF]   Curl:  full  AM
function parseMessage( str )
    local tbl = {};

    -- [LFF] <rgb=#00ff00>Curl</rgb>: '2/3 AM t1'
    -- LFF Curl 2/3 AM t1
    local normalizedMessage = string.gsub( str, "%[(.*)%] %<.*%>(.*)%<.*%>: '(.*)'", "%1 %2 %3" );
    local splittedMessage = strsplit( normalizedMessage );
    
    tbl.channel = splittedMessage[1];
    tbl.owner = splittedMessage[2];
    tbl.full = false;

    local prev;
    for key, value in pairs(splittedMessage) do
        value = string.lower( value );
        -- and not string.match( value, "l[v]?[^eve]?l" )
        if ( key > 2 ) then
            -- find full ie: [full, fulled, fill, filled]
            if ( string.match( value, "f[iu]ll[^ed]?" ) ) then
                -- print( "find full" );
                tbl.full = true;
            -- find tiers ie: [t1, T1/t2, t2/T1/t2]
            elseif ( string.match( value, "^[t]%d" ) ) then
                -- print( "find tiers " .. value );
                tbl.tiers = value; 
            -- find level ie: [lvl20, level 58+, 130+]
            elseif ( string.match( prev, "l[v]?[^eve]?l" ) or string.match( value, "l[v]?[^eve]?l%d+[+]?" ) ) then
                -- print( "find level " .. value );
                tbl.level = value;
            -- find count ie: [2/3, 1/12]
            elseif ( string.match( value, "%d+/%d+" ) and not string.match( prev, "l[v]?[^eve]?l" ) ) then
                -- print( "find count " .. value );
                tbl.count = value;
            -- find role ie: [healer tank dps]
            elseif (
                string.match( value, "heal[^er]?" )
                or string.match( value, "t[^ank]" )
                or string.match( value, "dps" )
                or string.match( value, "hunter" )
                or string.match( value, "rk" )
                or string.match( value, "lm" )
            ) then
                -- print( "find role " .. value );
                tbl.roles = ( tbl.roles or "" ) .. ", " .. value;
                tbl.roles = string.gsub( tbl.roles, "^[,/%s]?(.*)[,/%s]?$", "%1" );
            -- find instance ie: [am, foKd, ad, stairs]
            elseif ( instanceEnum[value] ) then
                -- print( "find role " .. value );
                tbl.instance = value;
            end
        end
        prev = value;
    end

    return tbl;
end
-- END Utils ------------------------------------------------------------------------------------------------


function HandleReceivedMessage( sender, args )
    if ( args.ChatType ~= Turbine.ChatType.LFF ) then
		return;
	end

    local normalizedMessage = string.gsub( args.Message, "%[(.*)%] %<.*%>(.*)%<.*%>: '(.*)'", "%1 %2 %3" );
    local msgTable = parseMessage( normalizedMessage );

    -- delete filled LFF call
    if ( msgTable.full ) then
        lffList[msgTable.owner] = nil;
        lupa:Update();

        return;
    end

    -- skip instance is not available
    if ( not msgTable.instance ) then
        -- debug ignored LFF instance call
        Turbine.Shell.WriteLine( "<rgb=#FF0000>"
            .. "channel: " .. msgTable.channel
            .. ", owner: " .. msgTable.owner
            .. ", count: " .. (msgTable.count or "")
            .. ", instance: " .. (msgTable.instance or "")
            .. ", tiers: " .. (msgTable.tiers or "")
            .. ", roles: " .. (msgTable.roles or "")
            .. ", level " .. (msgTable.level or "")
            .. ", " .. ((msgTable.full and "FULL") or "IN_PROGRESS")
            .. "</rgb>" );
        return;
    end

    -- update LFF call
    lffList[msgTable.owner] = msgTable;

    -- update the Lupa Window items
    lupa:Update();
end

-- Unit Tests
-- HandleReceivedMessage( nil, { ChatType = Turbine.ChatType.LFF, Message = "[LFF] <rgb=#00ff00>Curl</rgb>: '1/2 Stairs T2/t1/t2 lvl 130/120+/130 pst need run rune keeper  take lm hntr '" });
-- HandleReceivedMessage( nil, { ChatType = Turbine.ChatType.LFF, Message = "[LFF] <rgb=#00ff00>Aaa</rgb>: '1/3 harrow/roost t2 x2'" });
-- HandleReceivedMessage( nil, { ChatType = Turbine.ChatType.LFF, Message = "[LFF] <rgb=#00ff00>Bbb</rgb>: 'Woe T5, 2/3 need DPS, pst'" });
-- HandleReceivedMessage( nil, { ChatType = Turbine.ChatType.LFF, Message = "[LFF] <rgb=#00ff00>Bbb</rgb>: '1/3 Woe/Ago T3 YC/Beorning + Dps pst'" });

-- events
Turbine.Chat.Received = HandleReceivedMessage;

-- init Lupa
OpenLupa = Turbine.ShellCommand();
Turbine.Shell.AddCommand("lupa", OpenLupa);
Turbine.Shell.WriteLine( "<rgb=#FF9900>" .. plugin:GetName() .. " " .. plugin:GetVersion() .. " tá on-line!</rgb>" );

function OpenLupa:Execute(cmd, args)
    lupa:SetVisible( true );
end

-- destroy Lupa
plugin.Unload = function() 
    Turbine.Shell.WriteLine( "<rgb=#FF9900>Até já!</rgb>" );
end
