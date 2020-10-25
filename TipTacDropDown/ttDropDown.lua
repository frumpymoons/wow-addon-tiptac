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
	-- Store the Blizzard default backdrop, so we can restore it
	if not defaults[dropdown] then
		defaults[dropdown] = dropdown.backdropInfo;
	end
	if not cfg.if_enable then
		dropdown:SetBackdrop(defaults[dropdown]);
		do
			local r, g, b = 1, 1, 1;
			if dropdown.backdropColor then
				r, g, b = dropdown.backdropColor:GetRGB();
			end
			local a = dropdown.backdropColorAlpha or 1;
			dropdown:SetBackdropColor(r, g, b, a);
		end
		do
			local r, g, b = 1, 1, 1;
			if dropdown.backdropBorderColor then
				r, g, b = dropdown.backdropBorderColor:GetRGB();
			end
			local a = dropdown.backdropBorderColorAlpha or 1;
			dropdown:SetBackdropBorderColor(r, g, b, a);
		end
		return;
	end
	dropdown:SetBackdrop({
		bgFile = cfg.tipBackdropBG,
		edgeFile = cfg.tipBackdropEdge,
		tile = false,
		tileEdge = false,
		edgeSize = cfg.backdropEdgeSize,
		insets = { left = cfg.backdropInsets, right = cfg.backdropInsets, top = cfg.backdropInsets, bottom = cfg.backdropInsets },
	});
	dropdown:SetBackdropColor(unpack(cfg.tipColor));
	dropdown:SetBackdropBorderColor(unpack(cfg.tipBorderColor));
end