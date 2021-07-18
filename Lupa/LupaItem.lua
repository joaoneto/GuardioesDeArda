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
	self.data.instanceName = ( instances[data.instance] and instances[data.instance].name or data.instance );
	self.data.tiers = data.tiers;
	self.data.roles = data.roles;
	self.data.level = data.level;

	self:SetBlendMode( Turbine.UI.BlendMode.Overlay );

	self.icon = Turbine.UI.Control();
    self.icon:SetParent( self );
    self.icon:SetSize( ICON_SIZE, ICON_SIZE );
    self.icon:SetPosition( SPACING, SPACING );
	-- @TODO: add more background images
	self.icon:SetBackground(
		instances[data.instance] and instances[data.instance].thumbnail
		or "GuardioesDeArda/Lupa/Resources/ad_thumb.tga"
	);

	self.nameLabel = Turbine.UI.Label();
	self.nameLabel:SetParent( self );
	self.nameLabel:SetText( self.data.instanceName );
	self.nameLabel:SetPosition( ICON_SIZE + ( SPACING * 2 ), SPACING );

	self.nameLabel2 = Turbine.UI.Label();
	self.nameLabel2:SetParent( self );
	self.nameLabel2:SetText( self.data.owner );
	self.nameLabel2:SetPosition( ICON_SIZE + ( SPACING * 2 ), SPACING + LINE_HEIGHT );

	self.nameLabel3 = Turbine.UI.Label();
	self.nameLabel3:SetParent( self );
	self.nameLabel3:SetText(
		( ( self.data.tiers and self.data.tiers .. " - " ) or "" )
		.. ( ( self.data.roles and self.data.roles .. " - " ) or "" )
		.. ( ( self.data.level and self.data.level .. " - " ) or "" )
		.. ( self.data.count or "" )
	);
	self.nameLabel3:SetPosition( ICON_SIZE + ( SPACING * 2 ), SPACING + ( LINE_HEIGHT * 2 ) );

	self.chatSend = Turbine.UI.Lotro.Quickslot();
	self.chatSend:SetParent( self );
	self.chatSend:SetSize( 180, 18 );
	self.chatSend:SetPosition( 300, SPACING );
	self.chatSend:SetAllowDrop( false );
	self.chatSend:SetZOrder( 1 );

	self.chatSendShortcut = Turbine.UI.Lotro.Shortcut( Turbine.UI.Lotro.ShortcutType.Alias, nil );
	self.chatSendShortcut:SetData( "/tell " .. self.data.owner .. " x" );

	self.chatSend:SetShortcut( self.chatSendShortcut );

	self.chatSendButton = Turbine.UI.Label();
	self.chatSendButton:SetParent( self );
	self.chatSendButton:SetSize( 80, 20 );
	self.chatSendButton:SetPosition( 400, SPACING );
	self.chatSendButton:SetText( "Entrar" );
	self.chatSendButton:SetForeColor( Turbine.UI.Color( 1, 0.7, 0.5 ) );
	self.chatSendButton:SetFont( Turbine.UI.Lotro.Font.BookAntiquaBold );
	self.chatSendButton:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleCenter );
	self.chatSendButton:SetMouseVisible( false );
	self.chatSendButton:SetZOrder( 2 );
	self.chatSendButton:SetBlendMode(Turbine.UI.BlendMode.Overlay);
	self.chatSendButton:SetBackColor( Turbine.UI.Color( 1, 0.2, 0.2, 0.9 ) );

	self.chatSend.MouseEnter = function()
		self.chatSendButton:SetBackColor( Turbine.UI.Color( 1, 0.1, 0.4, 0.9 ) );
	end

	self.chatSend.MouseLeave = function()
		self.chatSendButton:SetBackColor( Turbine.UI.Color( 1, 0.2, 0.2, 0.9 ) );
	end

	self.overlayChatSend = Turbine.UI.Control();
	self.overlayChatSend:SetParent( self );
	self.overlayChatSend:SetSize( 100, 20 );
	self.overlayChatSend:SetPosition( 300, SPACING );
	self.overlayChatSend:SetBackColor( Turbine.UI.Color( 1, 0, 0, 0 ) );
	self.overlayChatSend:SetZOrder( 3 );

	self:Layout();
end

function LupaItem:Layout()
	local width = self:GetWidth();
	
	self:SetSize( ROW_WIDTH, ROW_HEIGHT );
	
	self.nameLabel:SetSize( width - self.nameLabel:GetLeft(), LINE_HEIGHT );
	self.nameLabel2:SetSize( width - self.nameLabel2:GetLeft(), LINE_HEIGHT );
	self.nameLabel3:SetSize( width - self.nameLabel2:GetLeft(), LINE_HEIGHT );
end

function LupaItem:SizeChanged()
	self:Layout();
end
