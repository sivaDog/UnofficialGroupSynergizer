GROUP_SYNERGIZER 					= {}
GROUP_SYNERGIZER.name 				= "GroupSynergizer"
GROUP_SYNERGIZER.version 			= "4.1"
GROUP_SYNERGIZER.variableVersion	= 2
GROUP_SYNERGIZER.savedVariables		= nil
GROUP_SYNERGIZER.eventManager 		= GetEventManager()
GROUP_SYNERGIZER.playerName			= GetDisplayName()
GROUP_SYNERGIZER.activityFinderCode	= -1
GROUP_SYNERGIZER.perfectPixelCompat	= false
GROUP_SYNERGIZER.BUICompat			= false
GROUP_SYNERGIZER.showSpecificDung   = false
GROUP_SYNERGIZER.firstRun   		= false
GROUP_SYNERGIZER.groupTypes = {
	[2] = true, -- normal dungeon
	[3] = true, -- vet dungeon
	[7] = true, -- battlegrounds
	[8] = true,	-- battlegrounds
}
GROUP_SYNERGIZER.coolDownStatus		= {
	--[LFG_COOLDOWN_QUEUE_LEFT] 		= false,
	[LFG_COOLDOWN_ACTIVITY_STARTED] = false,
	[LFG_COOLDOWN_BATTLEGROUND_DESERTED] = false,
}
GROUP_SYNERGIZER.checkAuto			= {
	top		= 0,
	visible = false,
}
GROUP_SYNERGIZER.checkPledges		= {
	button 	= nil,
	state 	= BSTATE_NORMAL,
}
GROUP_SYNERGIZER.defaults 			= {
	AutoAccept		= false,
	AutoRelease		= false,
	Enable 			= true,
	EnhanceGAF		= true,
	NotifyDelay		= 2,
	ScreenNotify	= true,
	SlashCommands	= true,
	SoundNotify		= true,
}
GROUP_SYNERGIZER.Localization = {

	language 		= string.lower(GetCVar("language.2")),

	Translation=GROUP_SYNERGIZER_PLEDGES,
	Loc	=function(var) return GROUP_SYNERGIZER.Localization.Translation[var] or var end
}
-- /script SetCVar("language.2", "en")
-- /script d(GetCompletedQuestInfo(questID))