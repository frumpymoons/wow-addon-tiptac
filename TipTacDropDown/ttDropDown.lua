-- Addon
local modName = ...;
local ttdd = CreateFrame("Frame",modName.."DropDown");

-- Register with TipTac core addon if available
if (TipTac) then
	TipTac:RegisterElement(ttdd,"DropDown");
end

local cfg;
local levels = UIDROPDOWNMENU_MAXLEVELS;
local defaults = {};

--------------------------------------------------------------------------------------------------------
--                                         TipTacDropDown Frame                                       --
--------------------------------------------------------------------------------------------------------

function ttdd:VARIABLES_LOADED(event)
	-- Use TipTac settings if installed
	if (TipTac_Config) then
		cfg = TipTac_Config;
	end

	self:OnApplyConfig();
	self:UnregisterEvent("VARIABLES_LOADED");
end

ttdd:SetScript("OnEvent",function(self,event,...) self[event](self,event,...); end);
ttdd:RegisterEvent("VARIABLES_LOADED");
-- ttdd:RegisterEvent("ADDON_LOADED");

--------------------------------------------------------------------------------------------------------
--                                       HOOK: Dropdown Functions                                     --
--------------------------------------------------------------------------------------------------------

-- Apply Settings
function ttdd:OnApplyConfig()
	if not cfg then return; end
	for i = 1, levels do
		local backdrop;
		backdrop = _G["DropDownList"..i.."MenuBackdrop"];
		if backdrop then
			self:ApplyBackdrop(backdrop);
		end

		backdrop = _G["DropDownList"..i.."Backdrop"];
		if backdrop then
			self:ApplyBackdrop(backdrop);
		end

		backdrop = _G["Lib_DropDownList"..i.."MenuBackdrop"];
		if backdrop then
			self:ApplyBackdrop(backdrop);
		end

		backdrop = _G["Lib_DropDownList"..i.."Backdrop"];
		if backdrop then
			self:ApplyBackdrop(backdrop);
		end
	end
end

-- Applies the backdrop, color and border color.
function ttdd:ApplyBackdrop(dropdown)
	if not cfg or not dropdown or not dropdown.SetBackdrop or dropdown:IsForbidden() then return; end
	local backdrop = {
		bgFile = cfg.tipBackdropBG,
		edgeFile = cfg.tipBackdropEdge,
		tile = false,
		tileEdge = false,
		edgeSize = cfg.backdropEdgeSize,
		insets = { left = cfg.backdropInsets, right = cfg.backdropInsets, top = cfg.backdropInsets, bottom = cfg.backdropInsets },
	};
	-- Store the Blizzard default backdrop, so we can restore it
	if not defaults[dropdown] then
		defaults[dropdown] = dropdown.backdropInfo;
	end

	local bdc, bc = {}, {};
	if cfg.dd_enable then
		bdc.r, bdc.g, bdc.b, bdc.a = unpack(cfg.tipColor);
		bc.r, bc.g, bc.b, bc.a = unpack(cfg.tipBorderColor);
	else
		bdc.r, bdc.g, bdc.b = dropdown.backdropColor:GetRGB();
		bdc.a = dropdown.backdropColorAlpha or 1;
		bc.r, bc.g, bc.b = dropdown.backdropBorderColor:GetRGB();
		bc.a = dropdown.backdropBorderColorAlpha or 1;
	end
	dropdown:SetBackdrop(cfg.dd_enable and backdrop or defaults[dropdown]);
	dropdown:SetBackdropColor(bdc.r, bdc.g, bdc.b, bdc.a);
	dropdown:SetBackdropBorderColor(bc.r, bc.g, bc.b, bc.a);
end