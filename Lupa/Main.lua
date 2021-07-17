import "Turbine";

import "GuardioesDeArda.Lupa";
import "GuardioesDeArda.Lupa.Dictionary";

LockSettings = {
    window = {
        left = 840,
        top = 300,
        width = 640,
        height = 400,
    },
};

lffList = {};

lupa = LupaWindow();
lupa:SetVisible( true );


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
-- END Utils ------------------------------------------------------------------------------------------------


function HandleReceivedMessage( sender, args )
    if ( args.ChatType ~= Turbine.ChatType.LFF ) then
		return;
	end

    -- @TODO Implement multi instance like:
    -- [LFF]   Curl:  1/3   Woe/Ago  T3

    -- channel owner  count instance tiers roles       level
    -- [LFF]   Curl:  2/3   AM       t2/t4
    -- [LFF]   Curl:  2/3   AM       .     tank/healer
    -- [LFF]   Curl:  2/3   AM       .     .           100+
    -- [LFF]   Curl:  full  AM

    local parsedString = strsplit( args.Message );
    local owner = parsedString[2] and parsedString[2]:gsub( "%:", "" ) or "n/a";

    -- lupa:Update();

    -- Delete filled LFF call
    if ( parsedString[3] == "full" ) then
        lffList[owner] = nil;
        lupa:Update();

        Turbine.Shell.WriteLine( "<rgb=#FF9900>Full " .. owner .. "</rgb>" );
        return;
    end

    -- Update LFF call
    lffList[owner] = {
        channel = parsedString[1] and parsedString[1]:gsub( "([%.]+)", "n/a" ) or "n/a",
        owner = owner,
        count = parsedString[3] and parsedString[3]:gsub( "([%.]+)", "n/a" ) or parsedString[3],
        instance = parsedString[4] and parsedString[4]:gsub( "([%.]+)", "n/a" ) or parsedString[4],
        tiers = parsedString[5] and parsedString[5]:gsub( "([%.]+)", "n/a" ) or "n/a",
        roles = parsedString[6] and parsedString[6]:gsub( "([%.]+)", "n/a" ) or "n/a",
        level = parsedString[7] and parsedString[7]:gsub( "([%.]+)", "n/a" ) or "n/a",
    };

    -- Update the Lupa Window items
    lupa:Update();
end


-- Unit Tests

HandleReceivedMessage( nil, { ChatType = Turbine.ChatType.LFF, Message = "[LFF] Curl: 1/3 AM t1" });
HandleReceivedMessage( nil, { ChatType = Turbine.ChatType.LFF, Message = "[LFF] Lool: 1/3 AM t1" });
HandleReceivedMessage( nil, { ChatType = Turbine.ChatType.LFF, Message = "[LFF] Lala: 1/3 AM t1" });
-- HandleReceivedMessage( nil, { ChatType = Turbine.ChatType.LFF, Message = "[LFF] Curl: 2/3 AM t1" });
-- HandleReceivedMessage( nil, { ChatType = Turbine.ChatType.LFF, Message = "[LFF] Curl: full" });


-- Events
Turbine.Chat.Received = HandleReceivedMessage;


-- Lupa init
Turbine.Shell.WriteLine( "<rgb=#FF9900>" .. plugin:GetName() .. " " .. plugin:GetVersion() .. " tá on-line!</rgb>" );

plugin.Unload = function() 
    Turbine.Shell.WriteLine( "<rgb=#FF9900>Até já!</rgb>" );
end
