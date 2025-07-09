function GROUP_SYNERGIZER.leaveGroup()
	if IsPlayerInGroup(GROUP_SYNERGIZER.playerName) then
		GroupLeave()
		d("You have left the group.")
		zo_callLater(function() CHAT_SYSTEM:Minimize() end, 3000)
	end
end

function GROUP_SYNERGIZER.print(message, ...)
	df("|cb7ff00[%s]|r |cffffff%s|r", GROUP_SYNERGIZER.name, message:format(...))
end

function GROUP_SYNERGIZER.printCenter(message)
	local messageParams = CENTER_SCREEN_ANNOUNCE:CreateMessageParams(CSA_CATEGORY_LARGE_TEXT)
	messageParams:SetText(message)
	messageParams:SetCSAType(CENTER_SCREEN_ANNOUNCE_TYPE_DISPLAY_ANNOUNCEMENT)
	CENTER_SCREEN_ANNOUNCE:AddMessageWithParams(messageParams)
end

function GROUP_SYNERGIZER.printLFGDebug(statusCode)
	local statusText = {
		[ACTIVITY_FINDER_STATUS_NONE] = "ACTIVITY_FINDER_STATUS_NONE",
		[ACTIVITY_FINDER_STATUS_QUEUED] = "ACTIVITY_FINDER_STATUS_QUEUED",
		[ACTIVITY_FINDER_STATUS_IN_PROGRESS] = "ACTIVITY_FINDER_STATUS_IN_PROGRESS",
		[ACTIVITY_FINDER_STATUS_FORMING_GROUP] = "ACTIVITY_FINDER_STATUS_FORMING_GROUP",
		[ACTIVITY_FINDER_STATUS_COMPLETE] = "ACTIVITY_FINDER_STATUS_COMPLETE",
		[ACTIVITY_FINDER_STATUS_READY_CHECK] = "ACTIVITY_FINDER_STATUS_READY_CHECK"
	}
	df("s: %s (%s)", statusCode, statusText[statusCode] or "OTHER")
end

function GROUP_SYNERGIZER.AutoAcceptCheckbox(visible)
	if visible then
		if not GROUP_SYNERGIZER.EnhanceGAF then return end
		local lang = GROUP_SYNERGIZER.Localization.language
		local left = ({en=-42, fr=-18, de=-24, ru=6})[lang] or -42
		local cb = GROUP_SYNERGIZER.CheckBoxSettings(
			"GROUP_SYNERGIZER_AutoAccept",
			ZO_SearchingForGroupStatus,
			{256,28},
			{BOTTOMLEFT,TOPLEFT,left,-8},
			BSTATE_NORMAL,
			GROUP_SYNERGIZER.Localization.Loc("AutoAccept"),
			"ZoFontHeader2",
			{0,0},
			{0.773,0.761,0.62,1},
			nil,
			{0.937,0.922,0.745,1},
			false,
			GROUP_SYNERGIZER.AutoAccept,
			0
		)
		if GROUP_SYNERGIZER.perfectPixelCompat then
			if GROUP_SYNERGIZER.checkAuto.top == 0 then GROUP_SYNERGIZER.checkAuto.top = -64 end
			cb:ClearAnchors()
			cb:SetAnchor(BOTTOM,ZO_SearchingForGroup,BOTTOM,-104,GROUP_SYNERGIZER.checkAuto.top)
		end
	else
		if GROUP_SYNERGIZER_AutoAccept ~= nil then GROUP_SYNERGIZER_AutoAccept:SetHidden(true) end
	end
end

function GROUP_SYNERGIZER.CallLater(name, ms, func, opt1, opt2)
	if ms then
		GROUP_SYNERGIZER.eventManager:RegisterForUpdate("CallLater_"..name, ms, function()
			GROUP_SYNERGIZER.eventManager:UnregisterForUpdate("CallLater_"..name)
			func(opt1, opt2)
		end)
	else
		GROUP_SYNERGIZER.eventManager:UnregisterForUpdate("CallLater_"..name)
	end
end

function GROUP_SYNERGIZER.Chain(object)
	local T = {}
	setmetatable(T, {__index=function(self, func)
		if func == "__END" then return object end
		return function(self, ...)
			assert(object[func], func .. " missing in object")
			object[func](object, ...)
			return self
		end
	end})
	return T
end

function GROUP_SYNERGIZER.CheckBoxSettings(name, parent, dims, anchor, state, text, font, align, normal, pressed, mouseover, hidden, checked, settings)
	local cb = GROUP_SYNERGIZER.Button(name, parent, {16,16}, {anchor[1],anchor[2],anchor[3],anchor[4]}, state, nil, nil, align, nil, nil, nil, nil)
	local lb = GROUP_SYNERGIZER.Button(name.."_lb", cb, dims, {0,0,20,-4}, state, text, font, align, normal, pressed, mouseover, hidden)
	cb:SetNormalTexture(checked and "esoui/art/buttons/checkbox_checked.dds" or "esoui/art/buttons/checkbox_unchecked.dds")
	local function ControlUpdate(control, settings)
		checked = not checked
		control:SetNormalTexture(checked and "esoui/art/buttons/checkbox_checked.dds" or "esoui/art/buttons/checkbox_unchecked.dds")
		if settings == 0 then
			GROUP_SYNERGIZER.AutoAccept = not GROUP_SYNERGIZER.AutoAccept
			GROUP_SYNERGIZER.savedVariables.AutoAccept = GROUP_SYNERGIZER.AutoAccept
		end
	end
	cb:SetHandler("OnMouseEnter", function(self) lb:SetNormalFontColor(unpack(mouseover)) end)
	cb:SetHandler("OnMouseExit", function(self) lb:SetNormalFontColor(unpack(normal)) end)
	cb:SetHandler("OnClicked", function(self) ControlUpdate(self, settings) end)
	lb:SetHandler("OnClicked", function(self) ControlUpdate(cb, settings) end)
	return cb, lb
end

function GROUP_SYNERGIZER.Label(name, parent, dims, anchor, font, color, align, text, hidden)
	parent = parent or GuiRoot
	if (#anchor~=4 and #anchor~=5) then return end
	font = font or "ZoFontGame"
	color = (color and #color==4) and color or {1,1,1,1}
	align = (align and #align==2) and align or {0,0}
	hidden = hidden or false
	local label = _G[name] or WINDOW_MANAGER:CreateControl(name, parent, CT_LABEL)
	if dims then label:SetDimensions(dims[1], dims[2]) end
	label:ClearAnchors()
	label:SetAnchor(anchor[1], #anchor==5 and anchor[5] or parent, anchor[2], anchor[3], anchor[4])
	label:SetFont(font)
	label:SetColor(unpack(color))
	label:SetHorizontalAlignment(align[1])
	label:SetVerticalAlignment(align[2])
	label:SetText(text)
	label:SetHidden(hidden)
	local fragment = ZO_FadeSceneFragment:New(label)
	KEYBOARD_GROUP_MENU_SCENE:AddFragment(fragment)
	GAMEPAD_ACTIVITY_FINDER_ROOT_SCENE:AddFragment(fragment)
	return label
end

function GROUP_SYNERGIZER.Button(name, parent, dims, anchor, state, text, font, align, normal, pressed, mouseover, hidden)
	if not name or name == "" then return end
	parent = parent or GuiRoot
	if (dims == "inherit" or #dims ~= 2) then dims = {parent:GetWidth(), parent:GetHeight()} end
	if (#anchor ~= 4 and #anchor ~= 5) then return end
	state = state or BSTATE_NORMAL
	font = font or "ZoFontGame"
	align = (align and #align == 2) and align or {1, 1}
	normal = (normal and #normal == 4) and normal or {1, 1, 1, 1}
	pressed = (pressed and #pressed == 4) and pressed or {1, 1, 1, 1}
	mouseover = (mouseover and #mouseover == 4) and mouseover or {1, 1, 1, 1}
	hidden = hidden or false
	local button = _G[name] or WINDOW_MANAGER:CreateControl(name, parent, CT_BUTTON)
	button = GROUP_SYNERGIZER.Chain(button)
		:SetDimensions(dims[1], dims[2])
		:ClearAnchors()
		:SetAnchor(anchor[1], #anchor==5 and anchor[5] or parent, anchor[2], anchor[3], anchor[4])
		:SetState(state)
		:SetFont(font)
		:SetNormalFontColor(normal[1], normal[2], normal[3], normal[4])
		:SetPressedFontColor(pressed[1], pressed[2], pressed[3], pressed[4])
		:SetMouseOverFontColor(mouseover[1], mouseover[2], mouseover[3], mouseover[4])
		:SetHorizontalAlignment(align[1])
		:SetVerticalAlignment(align[2])
		:SetHidden(hidden)
		:SetText(text)
	.__END
	return button
end

function GROUP_SYNERGIZER.groupFinderVisible(oldState, newState)
	GROUP_SYNERGIZER.AutoAcceptCheckbox(newState == SCENE_FRAGMENT_SHOWN)
	if GROUP_SYNERGIZER.BUICompat then BUI_AutoQueue:SetHidden(GROUP_SYNERGIZER.BUICompat) end
end

local function PerfectPixelCheck()
	local am = GetAddOnManager()
	for i = 1, am:GetNumAddOns() do
		local name, _, _, _, enabled, loadable = select(1, am:GetAddOnInfo(i))
		name = name:gsub("|[cC]%x%x%x%x%x%x", ""):gsub("|[rR]", "")
		if name == "PerfectPixel" and enabled and loadable == 2 then return true end
	end
	return false
end

local function BUICheck()
	local am = GetAddOnManager()
	for i = 1, am:GetNumAddOns() do
		local name, _, _, _, enabled, loadable = select(1, am:GetAddOnInfo(i))
		name = name:gsub("|[cC]%x%x%x%x%x%x", ""):gsub("|[rR]", "")
		if name == "BanditsUserInterface" and enabled and loadable == 2 then return true end
	end
	return false
end

GROUP_SYNERGIZER.perfectPixelCompat = PerfectPixelCheck()
GROUP_SYNERGIZER.BUICompat = BUICheck()