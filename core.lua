local E = ElvUI[1]
local DT = E:GetModule("DataTexts")

local function getChatColorCode(chatType)
    local chatInfo = ChatTypeInfo[chatType]
    local r, g, b = 255, 255, 255
    if chatInfo then
        r = floor(chatInfo.r * 255 + 0.5)
        g = floor(chatInfo.g * 255 + 0.5)
        b = floor(chatInfo.b * 255 + 0.5)
    end
    return string.format("|cff%02x%02x%02x", r, g, b)
end

local function openInput(command)
    local currentText = DEFAULT_CHAT_FRAME.editBox:GetText()
    ChatFrame_OpenChat(command .. " " .. currentText, DEFAULT_CHAT_FRAME)
end

local function makeMenu()
    local channelList = { GetChannelList() }
    for i = #channelList - 2, 1, -3 do
        if channelList[i] >= 1 and channelList[i] <= 10 then
            UIDropDownMenu_AddButton {
                notCheckable = true,
                colorCode = getChatColorCode("CHANNEL" .. channelList[i]),
                text = channelList[i + 1],
                func = function() openInput("/" .. channelList[i]) end
            }
        end
    end
    if UnitInBattleground("Player") then
        UIDropDownMenu_AddButton {
            notCheckable = true,
            colorCode = getChatColorCode("BATTLEGROUND"),
            text = CHAT_MSG_BATTLEGROUND,
            func = function() openInput("/bg") end
        }
    end
    UIDropDownMenu_AddButton {
        notCheckable = true,
        colorCode = getChatColorCode("YELL"),
        text = CHAT_MSG_YELL,
        func = function() openInput("/y") end
    }
    if C_GuildInfo.IsGuildOfficer() then
        UIDropDownMenu_AddButton {
            notCheckable = true,
            colorCode = getChatColorCode("OFFICER"),
            text = CHAT_MSG_OFFICER,
            func = function() openInput("/o") end
        }
    end
    if IsInGuild() then
        UIDropDownMenu_AddButton {
            notCheckable = true,
            colorCode = getChatColorCode("GUILD"),
            text = CHAT_MSG_GUILD,
            func = function() openInput("/g") end
        }
    end
    if IsInRaid() then
        UIDropDownMenu_AddButton {
            notCheckable = true,
            colorCode = getChatColorCode("RAID"),
            text = CHAT_MSG_RAID,
            func = function() openInput("/raid") end
        }
    end
    if IsInGroup() then
        UIDropDownMenu_AddButton {
            notCheckable = true,
            colorCode = getChatColorCode("PARTY"),
            text = CHAT_MSG_PARTY,
            func = function() openInput("/p") end
        }
    end
    UIDropDownMenu_AddButton {
        notCheckable = true,
        colorCode = getChatColorCode("SAY"),
        text = CHAT_MSG_SAY,
        func = function() openInput("/s") end
    }
end

local frame = CreateFrame("Frame", "ElvUI_ChatMenuDTMenu", E.UIParent, "UIDropDownMenuTemplate")
frame:RegisterEvent("PLAYER_ENTERING_WORLD")
frame:SetScript("OnEvent", function(self)
    self.initialize = makeMenu
    self.displayMode = "MENU"
    self:UnregisterEvent("PLAYER_ENTERING_WORLD")
end)

local function onClick(self)
    ToggleDropDownMenu(1, nil, frame, self, 20, 150)
end

local function onEvent(self)
    self.text:SetText(CHAT_MSG_CHANNEL_LIST)
end

DT:RegisterDatatext("pluginChatMenu", nil, nil, onEvent, nil, onClick, nil, nil, "Plugin-" .. CHAT_MSG_CHANNEL_LIST, nil,
    nil)
