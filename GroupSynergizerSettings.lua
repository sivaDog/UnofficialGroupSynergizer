local LAM = LibAddonMenu2

function GROUP_SYNERGIZER.CreateSettingsWindow()
    local panelData = {
        type = "panel",
        name = "Group Synergizer",
        displayName = "Scorps Group Synergizer",
        author = "Scorp",
        version = GROUP_SYNERGIZER.version,
        website = "https://www.esoui.com/downloads/info2286-GroupSynergizer-EnhancedLFGFeaturesAutoAcceptQueBetterNotifications.html",
        slashCommand = "/gs",
        registerForRefresh = true,
        registerForDefaults = true,
    }
    LAM:RegisterAddonPanel("GROUP_SYNERGIZER_Settings", panelData)

    local optionsData = {
        {
            type = "texture",
            image = "GroupSynergizer\\textures\\GroupSynergizerLogo.dds",
            imageWidth = 510,
            imageHeight = 100,
            width = "full",
        },
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
            func = function() MAIN_MENU_KEYBOARD:ShowScene("mailSend") MAIL_SEND:SetReply("@scorpius2k1", GROUP_SYNERGIZER.name) end,
            tooltip = GetString(SI_GROUP_SYNERGIZER_FEEDBACK_TT),
        },
    }
    LAM:RegisterOptionControls("GROUP_SYNERGIZER_Settings", optionsData)
end
