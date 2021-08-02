import "Turbine";
import "Turbine.UI";
import "Turbine.UI.Lotro";

import "GuardioesDeArda.Lupa.LupaItem";

LupaWindow = class( Turbine.UI.Lotro.Window );

function LupaWindow:Constructor()
	Turbine.UI.Lotro.Window.Constructor( self );

	self:SetText( "Lupa" );
	self:SetSize( LockSettings.window.width, LockSettings.window.height );
	self:SetPosition( LockSettings.window.left, LockSettings.window.top );

	self.showAllCheckBox = Turbine.UI.Lotro.CheckBox();
	self.showAllCheckBox:SetParent( self );
	self.showAllCheckBox:SetFont( Turbine.UI.Lotro.Font.TrajanPro14 );
	self.showAllCheckBox:SetText( " Show all" );
	self.showAllCheckBox:SetChecked( false );
	self.showAllCheckBox.checked = false;
	self.showAllCheckBox.CheckedChanged = function( sender, args )
		self:Update();
	end

	self.verticalScrollbar = Turbine.UI.Lotro.ScrollBar();
	self.verticalScrollbar:SetOrientation( Turbine.UI.Orientation.Vertical );
	self.verticalScrollbar:SetParent( self );

	self.lupaList = Turbine.UI.ListBox();
	self.lupaList:SetParent( self );
	self.lupaList:SetPosition( 15, 67 );
	self.lupaList:SetVerticalScrollBar( self.verticalScrollbar );

	self:Update();
end

function LupaWindow:Update()
	-- clean
	while self.lupaList:GetItemCount() > 0 do
		self.lupaList:RemoveItemAt( 1 );
	end

	-- transform hash table in table
	local list = {};
	for k, data in pairs( lffList ) do
		table.insert( list, data );
	end

	-- sort table
	table.sort( list, function (a, b)
		return a.time > b.time;
	end );

	local showAll = self.showAllCheckBox:IsChecked();
	-- re-render
	for k, data in pairs( list ) do
		local isDefault = data.instance == nil or data.instance == instanceEnum.default;
		-- showAll or filter parsed LFF calls to show
		if ( showAll or not isDefault ) then
			local item = LupaItem( data );
			self.lupaList:AddItem( item, 0 );
		end
	end

	self:Layout();
end

function LupaWindow:Layout()
	local width, height = self:GetSize();

	local listWidth = width - 48;
	local listHeight = height - 93;

	self.lupaList:SetSize( listWidth, listHeight );
	
	self.verticalScrollbar:SetPosition( width - 25, 67 );
	self.verticalScrollbar:SetSize( 10, listHeight );

	self.showAllCheckBox:SetPosition( 15, 45 );
	self.showAllCheckBox:SetSize( 90, 24 );

	local i;

	for i = 1, self.lupaList:GetItemCount() do
		local exampleListItem = self.lupaList:GetItem( i );
		exampleListItem:SetSize( listWidth, 20 );
	end
end

function LupaWindow:SizeChanged()
	self:Layout();
end
