function GROUP_SYNERGIZER.Battlegrounds()
	ZO_PreHookHandler(ZO_DungeonFinder_KeyboardListSection, 'OnEffectivelyShown', function() end)
	ZO_PreHookHandler(ZO_DungeonFinder_KeyboardListSection, 'OnEffectivelyHidden', function() end)
end

-- AUTO RELEASE ON DEATH
function GROUP_SYNERGIZER.OnDeathFragmentStateChange(_, newState)
	if not GROUP_SYNERGIZER.Enable or not GROUP_SYNERGIZER.AutoRelease then return end
	if newState == SCENE_FRAGMENT_SHOWING then
		local _, _, _, _, _, _, isBattleGroundDeath = GetDeathInfo()
		if isBattleGroundDeath then Release() end
	end
end

-- BATTLEGROUND STATES
function GROUP_SYNERGIZER.OnBattlegroundStateChanged(_, previousState, currentState)
	if not GROUP_SYNERGIZER.Enable or not GROUP_SYNERGIZER.AutoRelease then return end
	local battlegroundId = GetCurrentBattlegroundId()
	if previousState == 0 then
		PlaySound(SOUNDS.LOCKPICKING_BREAK)
	end
end
