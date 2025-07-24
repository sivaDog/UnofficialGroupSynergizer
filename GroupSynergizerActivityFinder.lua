local bNotifyActive = false

function GROUP_SYNERGIZER.OnActivityFinderStatusUpdate(_, statusCode)
    if not GROUP_SYNERGIZER.Enable then return end

    -- stop multiple checks of the same statusCode in succession
    if GROUP_SYNERGIZER.activityFinderCode == statusCode then
        if statusCode == ACTIVITY_FINDER_STATUS_READY_CHECK and not HasLFGReadyCheckNotification() then bNotifyActive = false end -- already had ready check and confirmed, disable loop(s)
        return
    end
    GROUP_SYNERGIZER.activityFinderCode = statusCode

    local function LoopSoundNotify()
        if not GROUP_SYNERGIZER.Enable or not HasLFGReadyCheckNotification() or not bNotifyActive then return end
        PlaySound(SOUNDS.QUEST_SHARE_SENT)
        PlaySound(SOUNDS.QUEST_SHARE_SENT)
        zo_callLater(function() PlaySound(SOUNDS.QUEST_STEP_FAILED) end, 333)
        zo_callLater(LoopSoundNotify, GROUP_SYNERGIZER.NotifyDelay * 1000)
    end

    local function LoopScreenNotify(messageText)
        if not GROUP_SYNERGIZER.Enable or not HasLFGReadyCheckNotification() or not bNotifyActive then return end
        GROUP_SYNERGIZER.printCenter(messageText)
        zo_callLater(function() LoopScreenNotify(messageText) end, 5000)
    end

    if GROUP_SYNERGIZER.EnhanceGAF then
        -- checkbox
        if GROUP_SYNERGIZER_AutoAccept ~= nil then
            GROUP_SYNERGIZER.checkAuto.top = 0
            if GROUP_SYNERGIZER.perfectPixelCompat then
                if	statusCode == ACTIVITY_FINDER_STATUS_QUEUED or
                    statusCode == ACTIVITY_FINDER_STATUS_IN_PROGRESS or
                    statusCode == ACTIVITY_FINDER_STATUS_FORMING_GROUP or
                    statusCode == ACTIVITY_FINDER_STATUS_READY_CHECK
                then
                    GROUP_SYNERGIZER.checkAuto.top = -88
                else
                    GROUP_SYNERGIZER.checkAuto.top = -64
                end
            end
            GROUP_SYNERGIZER.AutoAcceptCheckbox(true)
        end

        -- button
        local btn = GROUP_SYNERGIZER.checkPledges and GROUP_SYNERGIZER.checkPledges.button
        if btn ~= nil then
            if	statusCode == ACTIVITY_FINDER_STATUS_QUEUED or
                statusCode == ACTIVITY_FINDER_STATUS_IN_PROGRESS or
                statusCode == ACTIVITY_FINDER_STATUS_FORMING_GROUP or
                statusCode == ACTIVITY_FINDER_STATUS_READY_CHECK
            then
                if GROUP_SYNERGIZER.perfectPixelCompat then
                    btn:SetHidden(true)
                else
                    btn:SetState(BSTATE_DISABLED)
                    GROUP_SYNERGIZER.checkPledges.state = BSTATE_DISABLED
                end
            else
                btn:SetState(BSTATE_NORMAL)
                GROUP_SYNERGIZER.checkPledges.state = BSTATE_NORMAL
            end
        end
    end

    if GROUP_SYNERGIZER.perfectPixelCompat and GROUP_SYNERGIZER_PledgesCheck ~= nil then
        local btn = GROUP_SYNERGIZER.checkPledges and GROUP_SYNERGIZER.checkPledges.button
        if btn then
            if not GROUP_SYNERGIZER.showSpecificDung or statusCode == ACTIVITY_FINDER_STATUS_QUEUED then
                btn:SetHidden(true)
            else
                btn:SetHidden(false)
            end
        end
    end

    -- lfg not qued, qued, in progress, forming, or complete
    if statusCode ~= ACTIVITY_FINDER_STATUS_READY_CHECK or not HasLFGReadyCheckNotification() then
        bNotifyActive = false
        return
    end

    -- lfg ready check
    if not bNotifyActive then
        bNotifyActive = true
        if GROUP_SYNERGIZER.AutoAccept then
            if GROUP_SYNERGIZER.ScreenNotify then
                GROUP_SYNERGIZER.print(GetString(SI_GROUP_SYNERGIZER_LFG_CHAT_A))
                GROUP_SYNERGIZER.printCenter(GetString(SI_GROUP_SYNERGIZER_LFG_SCREEN))
            end
            if GROUP_SYNERGIZER.SoundNotify then
                PlaySound(SOUNDS.QUEST_SHARE_SENT)
                PlaySound(SOUNDS.QUEST_SHARE_SENT)
            end
            -- brief delay to allow lfg check to show before accept
            zo_callLater(AcceptLFGReadyCheckNotification, 3000)
        else
            if GROUP_SYNERGIZER.ScreenNotify then
                GROUP_SYNERGIZER.print(GetString(SI_GROUP_SYNERGIZER_LFG_CHAT))
                LoopScreenNotify(GetString(SI_GROUP_SYNERGIZER_LFG_SCREEN))
            end
            if GROUP_SYNERGIZER.SoundNotify then LoopSoundNotify() end
        end
    end
end

function GROUP_SYNERGIZER.OnCooldownsUpdate()
    local cooldownType = {
        a = LFG_COOLDOWN_ACTIVITY_STARTED, -- left dungeon group early (15 minute cooldown)
        b = LFG_COOLDOWN_BATTLEGROUND_DESERTED, -- left battleground group early (5 minute cooldown)
        c = LFG_COOLDOWN_BATTLEGROUND_REWARD_GRANTED,
        d = LFG_COOLDOWN_DUNGEON_LEFT,
        e = LFG_COOLDOWN_DUNGEON_REWARD_GRANTED,
        f = LFG_COOLDOWN_INVALID,
        g = LFG_COOLDOWN_QUEUE_LEFT, -- declined ready check (30s cooldown)
        h = LFG_COOLDOWN_TRIAL_LEFT,
    }
    for k, cooldown in pairs(cooldownType) do
        local timeRemaining = GetLFGCooldownTimeRemainingSeconds(cooldown)
        local isOnCooldown = timeRemaining > 0
        if GROUP_SYNERGIZER.coolDownStatus[cooldown] ~= nil then
            GROUP_SYNERGIZER.coolDownStatus[cooldown] = isOnCooldown
        end
    end
end
