import "Turbine";
import "Turbine.UI";
import "Turbine.UI.Lotro";
import "GuardioesDeArda.Lupa";

local lupa = LupaWindow();

function HandleReceivedMessage(sender, args)
    if (args.ChatType ~= Turbine.ChatType.LFF) then
		return;
	end

    local normalizedMessage = string.gsub(args.Message, "%[(.*)%] %<.*%>(.*)%<.*%>: '(.*)'", "%1 %2 %3");
    local msgTable = ParseMessage(normalizedMessage);

    -- delete filled LFF call
    if (msgTable.full) then
        LffList[msgTable.owner] = nil;
        lupa:Update();

        return;
    end

    -- parsed LFF call
    if (msgTable.instance) then
        -- update LFF call (if is pattern)
        LffList[msgTable.owner] = msgTable;

    -- not parsed properly LFF call
    else
        -- Turbine.Shell.WriteLine(
        --     "<rgb=#FF0000>"
        --     .. string.gsub(normalizedMessage, "%w+ [%w-_]+ (.*)", "%1")
        --     .. "</rgb>"
        -- )

        -- update LFF call (if not pattern)
        if (not LffList[msgTable.owner]) then
            LffList[msgTable.owner] = {
                channel = msgTable.channel,
                owner = msgTable.owner,
                instance = InstanceEnum.default,
                time = Turbine.Engine.GetLocalTime(),
                lffMessage = string.gsub(normalizedMessage, "%w+ [%w-_]+ (.*)", "%1"),
            };
        end
    end

    -- add time of LFF call creation
    if (LffList[msgTable.owner].time == nil) then
        LffList[msgTable.owner].time = Turbine.Engine.GetLocalTime();
    end

    -- update the Lupa Window items
    lupa:Update();
end

-- unit Tests
-- nice way to run lua: https://www.tutorialspoint.com/execute_lua_online.php
--
-- HandleReceivedMessage(nil, { ChatType = Turbine.ChatType.LFF, Message = "[LFF] <rgb=#00ff00>Curl</rgb>: 'this is not a instance'" });
-- HandleReceivedMessage(nil, { ChatType = Turbine.ChatType.LFF, Message = "[LFF] <rgb=#00ff00>Braket</rgb>: 'STORV T2 need tank, dps'" });
-- HandleReceivedMessage(nil, { ChatType = Turbine.ChatType.LFF, Message = "[LFF] <rgb=#00ff00>Neboc</rgb>: '1/x SV t1 heal/hunter any lvl100'" });
-- HandleReceivedMessage(nil, { ChatType = Turbine.ChatType.LFF, Message = "[LFF] <rgb=#00ff00>Rodsin</rgb>: '4/6 hor t3 DPS/HEAL/RCAP'" });
-- HandleReceivedMessage(nil, { ChatType = Turbine.ChatType.LFF, Message = "[LFF] <rgb=#00ff00>Thurl</rgb>: '7/12 hh t2 any lvl140'" });
-- HandleReceivedMessage(nil, { ChatType = Turbine.ChatType.LFF, Message = "[LFF] <rgb=#00ff00>Thupi</rgb>: '2/12 doom t1/t2 heal/dps/lm/burg/hunter lvl140'" });
-- HandleReceivedMessage(nil, { ChatType = Turbine.ChatType.LFF, Message = "[LFF] <rgb=#00ff00>Curl</rgb>: '5/x am t3'" });
-- HandleReceivedMessage(nil, { ChatType = Turbine.ChatType.LFF, Message = "[LFF] <rgb=#00ff00>Curl</rgb>: 'HELLO'" });

-- events
Turbine.Chat.Received = HandleReceivedMessage;

-- init Lupa
OpenLupa = Turbine.ShellCommand();
Turbine.Shell.AddCommand("lupa", OpenLupa);

function OpenLupa:Execute(cmd, args)
    lupa:SetVisible(true);
end

plugin.Load = function()
    lupa:SetVisible(true);
    Turbine.Shell.WriteLine("<rgb=#FF9900>" .. plugin:GetName() .. " " .. plugin:GetVersion() .. " loaded!</rgb>");
end

-- destroy Lupa
plugin.Unload = function()
    Turbine.Shell.WriteLine("<rgb=#FF9900>see you around!</rgb>");
end
