import "Turbine";
import "Turbine.UI";
import "Turbine.UI.Lotro";
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

        -- update LFF call
        lffList[msgTable.owner] = {
            channel = msgTable.channel,
            owner = msgTable.owner,
            instance = instanceEnum.default,
            lffMessage = string.gsub( normalizedMessage, "%w+ %w+ (.*)", "%1" ),
        };

        -- update the Lupa Window items
        lupa:Update();

        return;
    end

    -- update LFF call
    lffList[msgTable.owner] = msgTable;

    -- update the Lupa Window items
    lupa:Update();
end

-- unit Tests
-- nice way to run lua: https://www.tutorialspoint.com/execute_lua_online.php
--
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

lupa:SetVisible( true );

-- destroy Lupa
plugin.Unload = function() 
    Turbine.Shell.WriteLine( "<rgb=#FF9900>Até já!</rgb>" );
end
