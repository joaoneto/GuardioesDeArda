import "Turbine";
import "Turbine.UI";
import "Turbine.UI.Lotro";
import "GuardioesDeArda.Lupa";
import "GuardioesDeArda.Lupa.Dictionary";

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
        -- update LFF call
        LffList[msgTable.owner] = msgTable;

    -- not parsed properly LFF call
    else
        Turbine.Shell.WriteLine(
            "<rgb=#FF0000>"
            .. string.gsub(normalizedMessage, "%w+ [%w-_]+ (.*)", "%1")
            .. "</rgb>"
    )

        -- update LFF call
        LffList[msgTable.owner] = {
            channel = msgTable.channel,
            owner = msgTable.owner,
            instance = InstanceEnum.default,
            time = Turbine.Engine.GetLocalTime(),
            lffMessage = string.gsub(normalizedMessage, "%w+ [%w-_]+ (.*)", "%1"),
        };
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
-- HandleReceivedMessage(nil, { ChatType = Turbine.ChatType.LFF, Message = "[LFF] <rgb=#00ff00>Rodsin</rgb>: 'LF Storv T2 2/6 tanking/heals/dps'" });
-- HandleReceivedMessage(nil, { ChatType = Turbine.ChatType.LFF, Message = "[LFF] <rgb=#00ff00>User2</rgb>: 'this is not a instance'" });
-- HandleReceivedMessage(nil, { ChatType = Turbine.ChatType.LFF, Message = "[LFF] <rgb=#00ff00>User3</rgb>: 'HH T1 9/12'" });
-- HandleReceivedMessage(nil, { ChatType = Turbine.ChatType.LFF, Message = "[LFF] <rgb=#00ff00>User3</rgb>: 'HoR T3 4/12'" });
-- HandleReceivedMessage(nil, { ChatType = Turbine.ChatType.LFF, Message = "[LFF] <rgb=#00ff00>User4</rgb>: 'Doom T2 7/12'" });

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
