function timerproc(a)
    if(stopit~=nil) then
        if(stopit==0) then
            if(runtick <= GetTime()) then
                if (channame == "g") then
                    SendChatMessage(am, "GUILD");
                elseif (channame == "s") then
                    SendChatMessage(am, "SAY");
                elseif (channame == "y") then
                    SendChatMessage(am == "YELL");
                elseif (channame == "p") then
                    SendChatMessage(am, "PARTY");
                elseif (channame == "r") then
                    SendChatMessage(am, "RAID");
                elseif (channame == "o") then
                    SendChatMessage(am, "OFFICER");
                elseif (channame == "e") then
                    SendChatMessage(am, "EMOTE");
                elseif (channame == "rw") then
                    SendChatMessage(am, "RAID_WARNING");
                elseif (channame == "bg") then
                    SendChatMessage(am, "BATTLEGROUND");
                elseif (channame == "w") then
                    SendChatMessage(am, "WHISPER",nil,charname);
                elseif (channame == "1") then
                    id = GetChannelName(channame);
                    SendChatMessage(am, "CHANNEL",nil,id);
                elseif (channame == "2") then
                    id = GetChannelName(channame);
                    SendChatMessage(am, "CHANNEL",nil,id);
                elseif (channame == "3") then
                    id = GetChannelName(channame);
                    SendChatMessage(am, "CHANNEL",nil,id);
                elseif (channame == "4") then
                    id = GetChannelName(channame);
                    SendChatMessage(am, "CHANNEL",nil,id);
                elseif (channame == "5") then
                    id = GetChannelName(channame);
                    SendChatMessage(am, "CHANNEL",nil,id);
                elseif (channame == "6") then
                    id = GetChannelName(channame);
                    SendChatMessage(am, "CHANNEL",nil,id);
                elseif (channame == "7") then
                    id = GetChannelName(channame);
                    SendChatMessage(am, "CHANNEL",nil,id);
                elseif (channame == "8") then
                    id = GetChannelName(channame);
                    SendChatMessage(am, "CHANNEL",nil,id);
                elseif (channame == "9") then
                    id = GetChannelName(channame);
                    SendChatMessage(am, "CHANNEL",nil,id);
                elseif (channame == "10") then
                    id = GetChannelName(channame);
                    SendChatMessage(am, "CHANNEL",nil,id);
                elseif (channame == "de") then
                    DoEmote(am);
                elseif (channame == "rs") then
                    RunScript(am);
            end	
            runtick=GetTime()+ticktime
            end
        end
    end
end

function stewRegisterCommand(id,comlist,desc,func)
    if (Satellite) then
        Satellite.registerSlashCommand({
        id = id;
        commands = comlist;
        onExecute = func;
        helpText = desc;
    });
    else
        SlashCmdList[id] = func;
        for i=1, table.getn(comlist) do setglobal("SLASH_"..id..i, comlist[i]); end;
    end
end

function sendhelpmsg(msg)
    DEFAULT_CHAT_FRAME:AddMessage(msg)
end

function initproc()
    stopit=1;
    local id	= "stew";
    local comlist	= {"/autohelp"};
    local desc	= "自动聊天窗发送消息命令";
    local func = function(msg)
        sendhelpmsg("'/auto' - 打开自动发送消息配置窗口");
        sendhelpmsg("'/autostart' - 开始自动发送消息.");
        sendhelpmsg("'/autostop' - 停止自动发送消息.");
        sendhelpmsg("'/autotick <time>' - 设置自动发送消息时间间隔");
        sendhelpmsg("'/autochan <频道名称>' - 设置发送到哪个频道");
        sendhelpmsg("'/automsg' - 设置消息体.");
        sendhelpmsg("'/autochar <角色名称>' - 设置要发送消息的角色。");
        sendhelpmsg("接受到频道: w, rs, de, s, y, e, p, r, rw, g, o, bg, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10");
    end

    stewRegisterCommand(id,comlist,desc,func);

    id="stew0";
    comlist={"/autostart"}
    desc="开始自动发送消息"
    func=function(msg)
        stopit=0;
        runtick=GetTime()
    end
    stewRegisterCommand(id,comlist,desc,func);

    id="stew00";
    comlist={"/autostop"}
    desc="停止自动发送消息"
    func=function(msg)
        stopit=1;
    end
    stewRegisterCommand(id,comlist,desc,func);

    id="stew1";
    comlist={"/autotick"}
    desc="设置自动发送消息的时间间隔"
    func=function(msg)
        ticktime=msg
    end
    stewRegisterCommand(id,comlist,desc,func);

    id="stew2";
    comlist={"/autochan"}
    desc="设置自动发送消息的聊天频道"
    func=function(msg)
        channame=msg;
    end
    stewRegisterCommand(id,comlist,desc,func);

    id="stew3";
    comlist={"/automsg"}
    desc="设置消息"
    func=function(msg)
        am=msg
    end

    stewRegisterCommand(id,comlist,desc,func);

    id="stew4";
    comlist={"/auto"}
    desc="显示自动发送消息的配置"
    func=function(msg)
        autoMessageCFGFrameEditBox1:SetText(am);
        autoMessageCFGFrameEditBox2:SetText(ticktime);
        autoMessageCFGFrameEditBox3:SetText(channame);
        autoMessageCFGFrameEditBox4:SetText(charname);
        ShowUIPanel(autoMessageCFGFrame);
        autoMessageCFGFrameEditBox1:HighlightText();
    end
    stewRegisterCommand(id,comlist,desc,func);
    id="stew5";
    comlist={"/autochar"}
    desc="将玩家名字设置为自动发送密语消息"
    func=function(msg)
        charname=msg;
    end
    stewRegisterCommand(id,comlist,desc,func);
    sendhelpmsg("|cffff0000自动发送聊天消息插件已成功加载，输入/auto进行配置");
end
