local LAM = LibAddonMenu2

function GROUP_SYNERGIZER.CreateSettingsWindow()
    local panelData = {
        type = "panel",
        name = "Group Synergizer",
        displayName = "Group Synergizer",
        author = GROUP_SYNERGIZER.authorDisplay,
        version = GROUP_SYNERGIZER.version,
        website = GROUP_SYNERGIZER.repositoryUrl,
        slashCommand = "/gs",
        registerForRefresh = true,
        registerForDefaults = true,
    }
    LAM:RegisterAddonPanel("GROUP_SYNERGIZER_Settings", panelData)

    local optionsData = {
        { type = "divider", height = 15, alpha = 1.0, width = "full" },
        {
            type = "checkbox",
            name = GetString(SI_GROUP_SYNERGIZER_ENABLE),
            tooltip = GetString(SI_GROUP_SYNERGIZER_ENABLE_TT),
            default = true,
            getFunc = function() return GROUP_SYNERGIZER.savedVariables.Enable end,
            setFunc = function(v) GROUP_SYNERGIZER.savedVariables.Enable = v GROUP_SYNERGIZER.Enable = v end,
        },
        {
            type = "checkbox",
            name = GetString(SI_GROUP_SYNERGIZER_SOUND),
            tooltip = GetString(SI_GROUP_SYNERGIZER_SOUND_TT),
            default = true,
            getFunc = function() return GROUP_SYNERGIZER.savedVariables.SoundNotify end,
            setFunc = function(v) GROUP_SYNERGIZER.savedVariables.SoundNotify = v GROUP_SYNERGIZER.SoundNotify = v end,
        },
        {
            type = "checkbox",
            name = GetString(SI_GROUP_SYNERGIZER_SCREEN),
            tooltip = GetString(SI_GROUP_SYNERGIZER_SCREEN_TT),
            default = true,
            getFunc = function() return GROUP_SYNERGIZER.savedVariables.ScreenNotify end,
            setFunc = function(v) GROUP_SYNERGIZER.savedVariables.ScreenNotify = v GROUP_SYNERGIZER.ScreenNotify = v end,
        },
        {
            type = "checkbox",
            name = GetString(SI_GROUP_SYNERGIZER_ENHANCE),
            tooltip = GetString(SI_GROUP_SYNERGIZER_ENHANCE_TT),
            default = true,
            getFunc = function() return GROUP_SYNERGIZER.savedVariables.EnhanceGAF end,
            setFunc = function(v) GROUP_SYNERGIZER.savedVariables.EnhanceGAF = v GROUP_SYNERGIZER.EnhanceGAF = v end,
        },
        {
            type = "checkbox",
            name = GetString(SI_GROUP_SYNERGIZER_SET_COLLECTION),
            tooltip = GetString(SI_GROUP_SYNERGIZER_SET_COLLECTION_TT),
            default = true,
            disabled = function() return not GROUP_SYNERGIZER.libSetsAvailable end,
            getFunc = function()
                if GROUP_SYNERGIZER.savedVariables.ShowSetCollectionProgress == nil then
                    return GROUP_SYNERGIZER.defaults.ShowSetCollectionProgress
                end
                return GROUP_SYNERGIZER.savedVariables.ShowSetCollectionProgress
            end,
            setFunc = function(v)
                GROUP_SYNERGIZER.savedVariables.ShowSetCollectionProgress = v
                GROUP_SYNERGIZER.ShowSetCollectionProgress = v
                if GROUP_SYNERGIZER.BuildCollectionCache then
                    GROUP_SYNERGIZER.BuildCollectionCache()
                end
                if GROUP_SYNERGIZER.showSpecificDung and GROUP_SYNERGIZER.DecorateDungeonRows then
                    GROUP_SYNERGIZER.DecorateDungeonRows()
                end
            end,
        },
        {
            type = "checkbox",
            name = GetString(SI_GROUP_SYNERGIZER_ACCEPT),
            tooltip = GetString(SI_GROUP_SYNERGIZER_ACCEPT_TT),
            default = false,
            getFunc = function() return GROUP_SYNERGIZER.savedVariables.AutoAccept end,
            setFunc = function(v) GROUP_SYNERGIZER.savedVariables.AutoAccept = v GROUP_SYNERGIZER.AutoAccept = v end,
        },
        {
            type = "checkbox",
            name = GetString(SI_GROUP_SYNERGIZER_RELEASE),
            tooltip = GetString(SI_GROUP_SYNERGIZER_RELEASE_TT),
            default = false,
            getFunc = function() return GROUP_SYNERGIZER.savedVariables.AutoRelease end,
            setFunc = function(v) GROUP_SYNERGIZER.savedVariables.AutoRelease = v GROUP_SYNERGIZER.AutoRelease = v end,
        },
        {
            type = "checkbox",
            name = GetString(SI_GROUP_SYNERGIZER_SLASH),
            tooltip = GetString(SI_GROUP_SYNERGIZER_SLASH_TT),
            default = true,
            warning = SI_GROUP_SYNERGIZER_SLASH_WARN,
            getFunc = function() return GROUP_SYNERGIZER.savedVariables.SlashCommands end,
            setFunc = function(v) GROUP_SYNERGIZER.savedVariables.SlashCommands = v GROUP_SYNERGIZER.SlashCommands = v end,
        },
        {
            type = "slider",
            name = GetString(SI_GROUP_SYNERGIZER_DELAY),
            tooltip = GetString(SI_GROUP_SYNERGIZER_DELAY_TT),
            min = 1, max = 5, step = 1, default = 2,
            getFunc = function() return GROUP_SYNERGIZER.savedVariables.NotifyDelay end,
            setFunc = function(v) GROUP_SYNERGIZER.savedVariables.NotifyDelay = v GROUP_SYNERGIZER.NotifyDelay = v end,
        },
        { type = "divider", height = 15, alpha = 1.0, width = "full" },
        {
            type = "button",
            name = GetString(SI_GROUP_SYNERGIZER_FEEDBACK),
            func = function() MAIN_MENU_KEYBOARD:ShowScene("mailSend") MAIL_SEND:SetReply(GROUP_SYNERGIZER.maintainerAccount, GROUP_SYNERGIZER.name) end,
            tooltip = GetString(SI_GROUP_SYNERGIZER_FEEDBACK_TT),
        },
    }
    LAM:RegisterOptionControls("GROUP_SYNERGIZER_Settings", optionsData)
end
