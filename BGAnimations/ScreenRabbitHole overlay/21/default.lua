local rh_wheel = setmetatable({}, sick_wheel_mt)
local wheel_item_mt = LoadActor("WheelItemMT.lua")

local wheel_options = {
	{1, "Snowfall"},
	{2, "Unix Timestamps"},
	{3, "Quietly Turning"},
	{4, "Recalling"},
	{5, "Hallways"},
	{6, "Seaside Catchball"},
	{7, "Dragons"},
	{8, "I like our castle."},
	{9, "Gibberish, maybe."},
	{10, "13 Ghosts II"},
	{11, "A Troubled Sea"},
	{12, "Where the Hallway Ends"},
	{13, "Sometimes I Think I Have It Bad"},
	{14, "Connection: Chapter 1"},
	{15, "Connection: Chapter 2"},
	{16, "Connection: Chapter 3"},
	{17, "Connection: Chapter 4"},
	{18, "A Beige Colored Bookmark"},
	{19, "A Walk In the Snow"},
}

if PREFSMAN:GetPreference("ThreeKeyNavigation") then
	wheel_options[#wheel_options+1] = {20, "Exit"}
end

-- - - - - - - - - - - - - - - - - - - - - - - - - - - -

local t = Def.ActorFrame {
	Name="RH_Menu",
	OnCommand=function(self)
		rh_wheel:set_info_set(wheel_options, 1)
	end,
	InputEventCommand=function(self, event)
		if not event.PlayerNumber or not event.button then
			return false
		end

		if event.type == "InputEventType_FirstPress" then
			local overlay = SCREENMAN:GetTopScreen():GetChild("Overlay")

			if event.GameButton == "MenuRight" or event.GameButton=="MenuDown" then
				rh_wheel:scroll_by_amount(1)

			elseif event.GameButton == "MenuLeft" or event.GameButton=="MenuUp" then
				rh_wheel:scroll_by_amount(-1)

			elseif event.GameButton == "Start" then
				local focus = rh_wheel:get_actor_item_at_focus_pos()
				-- set index to persist through reload
				SL.Global.RabbitHole = focus.rh_index
				-- reload
				local topscreen = SCREENMAN:GetTopScreen()
				topscreen:SetNextScreenName("ScreenRabbitHole")
				topscreen:StartTransitioningScreen("SM_GoToNextScreen")

			elseif event.GameButton == "Back" or event.GameButton == "Select" then
				SL.Global.RabbitHole = nil
				local topscreen = SCREENMAN:GetTopScreen()
				topscreen:SetNextScreenName("ScreenAcknowledgmentsMenu")
				topscreen:StartTransitioningScreen("SM_GoToNextScreen")
			end
		end
	end,

	-- this returns an ActorFrame ( see: ./Scripts/Consensual-sick_wheel.lua )
	rh_wheel:create_actors( "rh_wheel", #wheel_options, wheel_item_mt, _screen.cx, 60 )
}

return t