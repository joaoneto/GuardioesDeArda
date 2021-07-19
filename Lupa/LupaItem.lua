SPACING = 15;
LINE_HEIGHT = 18;
ICON_SIZE = 48;
ROW_HEIGHT = ICON_SIZE + ( SPACING * 2 );
ROW_WIDTH = 640 - ( SPACING * 2 );

LupaItem = class( Turbine.UI.Control );

function LupaItem:Constructor( data )
	Turbine.UI.Control.Constructor( self );
	
	self.data = {};
	self.data.channel = data.channel;
	self.data.owner = tostring( data.owner );
	self.data.count = data.count;
	self.data.instance = data.instance;
	self.data.instanceName = ( instances[data.instance] and instances[data.instance].name or data.instance );
	self.data.tiers = data.tiers;
	self.data.roles = data.roles;
	self.data.level = data.level;
	self.data.lffMessage = data.lffMessage;

	self:SetBlendMode( Turbine.UI.BlendMode.AlphaBlend );

	self.icon = Turbine.UI.Control();
    self.icon:SetParent( self );
    self.icon:SetSize( ICON_SIZE, ICON_SIZE );
    self.icon:SetPosition( SPACING, SPACING );
	self.icon:SetBlendMode( Turbine.UI.BlendMode.Overlay );
	self.icon:SetZOrder( 2 );
	self.icon:SetBackground(
		( instances[data.instance] and instances[data.instance].thumbnail )
		or "GuardioesDeArda/Lupa/Resources/default_thumb.tga"
	);

	self.nameLabel = Turbine.UI.Label();
	self.nameLabel:SetParent( self );
	self.nameLabel:SetPosition( ICON_SIZE + ( SPACING * 2 ), SPACING );
	self.nameLabel:SetFont( Turbine.UI.Lotro.Font.TrajanPro14 );
	self.nameLabel:SetZOrder( 4 );
	self.nameLabel:SetForeColor( Turbine.UI.Color( 1, 0.92, 0.8 ) );
	self.nameLabel:SetText( self.data.instanceName );

	self.nameLabel2 = Turbine.UI.Label();
	self.nameLabel2:SetParent( self );
	self.nameLabel2:SetPosition( ICON_SIZE + ( SPACING * 2 ), SPACING + LINE_HEIGHT );
	self.nameLabel2:SetFont( Turbine.UI.Lotro.Font.TrajanProBold16 );
	self.nameLabel2:SetZOrder( 4 );
	self.nameLabel2:SetForeColor( Turbine.UI.Color( 0.72, 0.8, 0.68 ) );
	self.nameLabel2:SetText( self.data.owner );

	self.nameLabel3 = Turbine.UI.Label();
	self.nameLabel3:SetParent( self );
	self.nameLabel3:SetPosition( ICON_SIZE + ( SPACING * 2 ), SPACING + ( LINE_HEIGHT * 2 ) );
	self.nameLabel3:SetFont( Turbine.UI.Lotro.Font.TrajanPro14 );
	self.nameLabel3:SetZOrder( 4 );
	if ( self.data.lffMessage ~= nil ) then
		self.nameLabel3:SetText( self.data.lffMessage );
	else
		self.nameLabel3:SetText(
			( ( self.data.count and self.data.count ) or "" )
			.. ( ( self.data.roles and " - " .. self.data.roles ) or "" )
			.. ( ( self.data.level and " - " .. self.data.level ) or "" )
			.. ( ( self.data.tiers and " - " .. self.data.tiers ) or "" )
		);
	end

	self.chatSend = Turbine.UI.Lotro.Quickslot();
	self.chatSend:SetParent( self );
	self.chatSend:SetSize( 180, LINE_HEIGHT + ( SPACING / 2 ) );
	self.chatSend:SetPosition( 300, SPACING );
	self.chatSend:SetAllowDrop( false );
	self.chatSend:SetZOrder( 1 );

	self.chatSendShortcut = Turbine.UI.Lotro.Shortcut( Turbine.UI.Lotro.ShortcutType.Alias, nil );
	self.chatSendShortcut:SetData( "/tell " .. self.data.owner .. " x" );

	self.chatSend:SetShortcut( self.chatSendShortcut );

	self.chatSendButton = Turbine.UI.Label();
	self.chatSendButton:SetParent( self );
	self.chatSendButton:SetSize( 80, LINE_HEIGHT );
	self.chatSendButton:SetPosition( 400, ( ROW_HEIGHT / 2 ) - ( LINE_HEIGHT / 2 )  );
	self.chatSendButton:SetForeColor( Turbine.UI.Color( 1, 1, 0 ) );
	self.chatSendButton:SetFont( Turbine.UI.Lotro.Font.TrajanPro14 );
	self.chatSendButton:SetFontStyle( Turbine.UI.FontStyle.Outline );
	self.chatSendButton:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleCenter );
	self.chatSendButton:SetMouseVisible( false );
	self.chatSendButton:SetZOrder( 2 );
	self.chatSendButton:SetText( "Send Tell" );
	self.chatSendButton:SetBlendMode( Turbine.UI.BlendMode.Overlay );
	self.chatSendButton:SetBackColor( Turbine.UI.Color( 1, 0.1, 0.1, 0.9 ) );

	self.chatSend.MouseEnter = function()
		self.chatSendButton:SetBackColor( Turbine.UI.Color( 1, 0.1, 0.4, 0.9 ) );
	end

	self.chatSend.MouseLeave = function()
		self.chatSendButton:SetBackColor( Turbine.UI.Color( 1, 0.2, 0.2, 0.9 ) );
	end

	self.overlayChatSend = Turbine.UI.Control();
	self.overlayChatSend:SetParent( self );
	self.overlayChatSend:SetSize( 100, LINE_HEIGHT + ( SPACING * 2 ) );
	self.overlayChatSend:SetPosition( 300, ( ROW_HEIGHT / 2 ) - ( LINE_HEIGHT / 2 ) - SPACING );
	self.overlayChatSend:SetBackColor( Turbine.UI.Color( 0.9, 0, 0, 0 ) );
	self.overlayChatSend:SetZOrder( 3 );
	self.overlayChatSend:SetBlendMode( Turbine.UI.BlendMode.AlphaBlend );

	self:Layout();
end

function LupaItem:Layout()
	local width = self:GetWidth();
	
	self:SetSize( ROW_WIDTH, ROW_HEIGHT );
	
	self.nameLabel:SetSize( width - self.nameLabel:GetLeft() - 220, LINE_HEIGHT );
	self.nameLabel2:SetSize( width - self.nameLabel2:GetLeft() - 220, LINE_HEIGHT );
	self.nameLabel3:SetSize( width - self.nameLabel2:GetLeft() - 220, LINE_HEIGHT );
end

function LupaItem:SizeChanged()
	self:Layout();
end
