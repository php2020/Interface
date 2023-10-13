if (GetLocale() == "zhCN" or GetLocale() == "enUS") then
    LFT.allDungeons = {
        ['怒焰裂谷(rfc)'] = { minLevel = 13, maxLevel = 18, code = 'rfc', queued = false, canQueue = true, background =
        'ragefirechasm', myRole = '' },
        ['哀号洞穴(wc)'] = { minLevel = 17, maxLevel = 24, code = 'wc', queued = false, canQueue = true, background =
        'wailingcaverns', myRole = '' },
        ['死亡矿井(dm)'] = { minLevel = 17, maxLevel = 24, code = 'dm', queued = false, canQueue = true, background =
        'deadmines', myRole = '' },
        ['影牙城堡(sfk)'] = { minLevel = 22, maxLevel = 30, code = 'sfk', queued = false, canQueue = true, background =
        'shadowfangkeep', myRole = '' },
        ['暴风城：监狱(stocks)'] = { minLevel = 22, maxLevel = 30, code = 'stocks', queued = false, canQueue = true, background =
        'stormwindstockades', myRole = '' },
        ['黑暗深渊(bfd)'] = { minLevel = 23, maxLevel = 32, code = 'bfd', queued = false, canQueue = true, background =
        'blackfathomdeeps', myRole = '' },
        ['血色修道院墓地(smgy)'] = { minLevel = 27, maxLevel = 36, code = 'smgy', queued = false, canQueue = true, background =
        'scarletmonastery', myRole = '' },
        ['血色修道院图书馆(smlib)'] = { minLevel = 28, maxLevel = 39, code = 'smlib', queued = false, canQueue = true, background =
        'scarletmonastery', myRole = '' },
        ['诺莫瑞根(gnomer)'] = { minLevel = 29, maxLevel = 38, code = 'gnomer', queued = false, canQueue = true, background =
        'gnomeregan', myRole = '' },
        ['剃刀沼泽(rfk)'] = { minLevel = 29, maxLevel = 38, code = 'rfk', queued = false, canQueue = true, background =
        'razorfenkraul', myRole = '' },

        ['新月林地(tcg)'] = { minLevel = 32, maxLevel = 38, code = 'tcg', queued = false, canQueue = true, background =
        'tcg', myRole = '' },

        ['血色修道院军械库(smarmory)'] = { minLevel = 32, maxLevel = 41, code = 'smarmory', queued = false, canQueue = true, background =
        'scarletmonastery', myRole = '' },
        ['血色修道院大教堂(smcath)'] = { minLevel = 35, maxLevel = 45, code = 'smcath', queued = false, canQueue = true, background =
        'scarletmonastery', myRole = '' },
        ['剃刀高地(rfd)'] = { minLevel = 36, maxLevel = 46, code = 'rfd', queued = false, canQueue = true, background =
        'razorfendowns', myRole = '' },
        ['奥达曼(ulda)'] = { minLevel = 40, maxLevel = 51, code = 'ulda', queued = false, canQueue = true, background =
        'uldaman', myRole = '' },

        ['吉尔尼斯城(gilneas)'] = { minLevel = 42, maxLevel = 50, code = 'gilneas', queued = false, canQueue = true, background =
        'gilneas', myRole = '' },

        ['祖尔法拉克(zf)'] = { minLevel = 44, maxLevel = 54, code = 'zf', queued = false, canQueue = true, background =
        'zulfarak', myRole = '' },
        ['玛拉顿橙门(maraorange)'] = { minLevel = 47, maxLevel = 55, code = 'maraorange', queued = false, canQueue = true, background =
        'maraudon', myRole = '' },
        ['玛拉顿紫门(marapurple)'] = { minLevel = 45, maxLevel = 55, code = 'marapurple', queued = false, canQueue = true, background =
        'maraudon', myRole = '' },
        ['玛拉顿公主(maraprincess)'] = { minLevel = 47, maxLevel = 55, code = 'maraprincess', queued = false, canQueue = true, background =
        'maraudon', myRole = '' },
        ['阿卡哈塔神庙(st)'] = { minLevel = 50, maxLevel = 60, code = 'st', queued = false, canQueue = true, background =
        'sunkentemple', myRole = '' },
        ['黑石深渊上层(brd)'] = { minLevel = 52, maxLevel = 60, code = 'brd', queued = false, canQueue = true, background =
        'blackrockdepths', myRole = '' },
        ['黑石深渊竞技场(brdarena)'] = { minLevel = 52, maxLevel = 60, code = 'brdarena', queued = false, canQueue = true, background =
        'blackrockdepths', myRole = '' },
        ['黑石深渊大帝(brdemp)'] = { minLevel = 54, maxLevel = 60, code = 'brdemp', queued = false, canQueue = true, background =
        'blackrockdepths', myRole = '' },
        ['黑石塔下层(lbrs)'] = { minLevel = 55, maxLevel = 60, code = 'lbrs', queued = false, canQueue = true, background =
        'blackrockspire', myRole = '' },
        ['厄运之槌：东(dme)'] = { minLevel = 55, maxLevel = 60, code = 'dme', queued = false, canQueue = true, background =
        'diremaul', myRole = '' },
        ['厄运之槌：北(dmn)'] = { minLevel = 57, maxLevel = 60, code = 'dmn', queued = false, canQueue = true, background =
        'diremaul', myRole = '' },
        ['厄运之槌：西(dmw)'] = { minLevel = 57, maxLevel = 60, code = 'dmw', queued = false, canQueue = true, background =
        'diremaul', myRole = '' },
        ['通灵学院(scholo)'] = { minLevel = 58, maxLevel = 60, code = 'scholo', queued = false, canQueue = true, background =
        'scholomance', myRole = '' },
        ['斯坦索姆：DK区(stratud)'] = { minLevel = 58, maxLevel = 60, code = 'stratud', queued = false, canQueue = true, background =
        'stratholme', myRole = '' },
        ['斯坦索姆：血色区(stratlive)'] = { minLevel = 58, maxLevel = 60, code = 'stratlive', queued = false, canQueue = true, background =
        'stratholme', myRole = '' },

        ['卡拉赞地穴(kc)'] = { minLevel = 58, maxLevel = 60, code = 'kc', queued = false, canQueue = true, background =
        'kc', myRole = '' },
        ['时间之穴：黑色沼泽(cotbm)'] = { minLevel = 60, maxLevel = 60, code = 'cotbm', queued = false, canQueue = true, background =
        'cotbm', myRole = '' },
        ['暴风城：金库(swv)'] = { minLevel = 60, maxLevel = 60, code = 'swv', queued = false, canQueue = true, background =
        'swv', myRole = '' },
        ['仇恨熔炉采矿场(hfq)'] = { minLevel = 50, maxLevel = 60, code = 'hfq', queued = false, canQueue = true, background =
        'hfq', myRole = '' },

        --['GM Test'] = { minLevel = 1, maxLevel = 60, code = 'gmtest', queued = false, canQueue = true, background = 'stratholme', myRole = '' },
    }
    LFT.L = {
        ['Join as Damage'] = '我是输出',
        ['Join as Healer'] = '我是治疗',
        ['Join as Tank'] = '我是坦克',
        ['All Available Dungeons'] = '全部可用地下城',
        ['Suggested Dungeons'] = '推荐地下城',
        ['Dungeons'] = '地下城',
        ['Elite Quests'] = '精英任务',
        ['Browse'] = '浏览',
        ['Average Wait Time: '] = '平均等待时间: ',
        ['Average Wait Time: Unavailable'] = '平均等待时间：不可用',
        ['Time in Queue: '] = '排队时间: ',
        ['Waiting Players ('] = '等待玩家(',
        [' Bosses Defeated'] = ' BOSS已击杀',
        ["Queued for "] = "排队等候 ",
        ['Let\'s do this!'] = '同意',
        [' group just formed. (type "/lft spam" to disable this message)'] = ' 刚刚开组。（键入“/lft spam”屏蔽组队提醒）',
        [' this session, '] = ' this session, ',
        [' total recorded.'] = ' 记录总数。',
        ['Groups formed spam is on'] = '队伍查找器消息已开启',
        ['Groups formed spam is off'] = '队伍查找器消息已关闭',
        ['Please do not type in the LFT channel or add it to your chat frames.'] = '禁止键入LFT频道或将其添加到您的聊天框中。',
        ['LFT channel removed from window '] = 'LFT频道已删除',
        ['Looking For Turtles - LFT'] = '队伍查找器',
        ['Left-click to open LFT.'] = '左键单击打开',
        ['Drag to move.'] = '拖动可移动。',
        ['You are not queued for any dungeons.'] = '你未参加任何地下城查找',
        ['No players are looking for groups at the moment.'] = '目前查找器中没有玩家',
        [' player is looking for groups at the moment.'] = ' 玩家正在寻求组队',
        [' players are looking for groups at the moment.'] = ' 玩家正在查找队列中',
        ['A member of your group has not confirmed his role.'] = '队伍中有一位成员尚未确认。',
        ['A member of your group does not have the '] = '队伍中有人没有',
        ['addon. Looking for more is disabled. (Type '] = '查找器已禁用(类型 ',
        ['Checking people online with the addon (5secs)...'] = '就位确认(5秒)...',
        ['A member of your group has not accepted the invitation. You are rejoining the queue.'] = '队伍中有人未接受邀请。正在重新加入队列',
        ['A role check has been initiated. Your group will be queued when all members have selected a role.'] = '启动职责检查，当所有成员都确认选择后进入排队。',
        ['You have chosen: '] = '您已选定：',
        [' but you already confirmed this role.'] = ' 您已经确认了。',
        ['Queueing aborted.'] = '排队已终止。',
        ['role has already been filled by '] = '职责已由填补',
        ['. Please select a different role to rejoin the queue.'] = '请选择其他职责以重新加入队列。',
        [' has chosen '] = ' 已选择 ',
        [' has chosen: '] = ' 已选择： ',
        ['Healer'] = '治疗 ',
        ['Tank'] = '坦克 ',
        ['Damage'] = '输出',
        [' but the group already has '] = ' 队伍已存在 ',
        ['|cffffffff attempt to print a nil value.'] = '|cffffffff 空值错误。',
        [') has been removed from the queue group.'] = ') 已从该队列组中移除。',
        ['A member of your group does not meet the suggested minimum level requirement for |cff69ccf0'] = '队伍中有人等级不够 |cff69ccf0',
        ['Your group is in the queue for |cff69ccf0'] = '队伍正在排队中 |cff69ccf0',
        ['You are in the queue for |cff69ccf0'] = '您正在排队中 |cff69ccf0',
        ['Your group has left the queue for |cff69ccf0'] = '队伍离开排队 |cff69ccf0',
        ['You have left the queue for |cff69ccf0'] = '您已离开排队中 |cff69ccf0',
        ['Listing formed groups history'] = '队伍信息已保存。',
        ['Formed groups history reset.'] = '重置历史记录。',
        ['LFT.channelIndex = 0, please try again in 10 seconds'] = '频道错误, 请在10秒钟后重试',
        ['There are no recorded formed groups.'] = '没有队伍信息记录。',
        ['There are '] = 'There are ',
        [' recorded formed groups.'] = ' 记录形成的组。',
        ['I am using LFT - Looking For Turtles - LFG Addon for Turtle WoW v'] = '我正在使用乌龟地下城查找器 v',
        ['Get it at: https://github.com/CosminPOP/LFT'] = '获取地址: https://github.com/CosminPOP/LFT',
        [' members. Please select a different role to rejoin the queue.'] = ' 成员。请选择其他职责重新排队。',
        [' as: '] = ' 职责: ',
    }
    LFT.types = {
        [1] = '推荐地下城',
        --    [2] = 'Random Dungeon',
        [3] = '全部可用地下城',
        --[4] =  LFT.L['精英任务']
    }
    LFT.bosses = {
        ['gmtest'] = { --dev only
            '杜洛斯',
            '德拉卡',
        },
        ['rfc'] = {
            '奥格弗林特',
            '饥饿者塔拉加曼',
            '祈求者耶戈什',
            'Bazzala',
        },
        ['wc'] = {
            '考布莱恩',
            '安娜科德拉',
            '克雷什',
            '皮萨斯',
            '斯卡姆',
            '瑟芬迪斯',
            '永生者沃尔丹',
            '吞噬者穆坦努斯',
        },
        ['dm'] = {
            'Rhahk\'zor',
            '斯尼德',
            '基尔尼格',
            '重拳先生',
            '曲奇',
            '绿皮队长',
            '艾德温·范克里夫',
        },
        ['sfk'] = {
            '雷希戈尔',
            '屠夫拉佐克劳',
            '席瓦莱恩男爵',
            '指挥官斯普林瓦尔',
            '盲眼守卫奥杜',
            '吞噬者芬鲁斯',
            '狼王南杜斯',
            '大法师阿鲁高',
        },
        ['bfd'] = {
            '加摩拉',
            '萨利维丝',
            '格里哈斯特',
            '洛古斯·杰特',
            '阿奎尼斯男爵',
            '梦游者克尔里斯',
            'Old Serra\'kis',
            'Aku\'mai',
        },
        ['stocks'] = {
            '可怕的塔格尔',
            '卡姆·深怒',
            '哈姆霍克',
            '巴基尔·斯瑞德',
            '迪克斯特·瓦德',
        },
        ['gnomer'] = {
            '格鲁比斯',
            '粘性辐射尘',
            '电刑器6000型',
            '群体打击者9-60',
            '麦克尼尔·瑟玛普拉格',
        },
        ['rfk'] = {
            '鲁古格',
            '阿格姆',
            '亡语者贾格巴',
            '主宰拉姆塔斯',
            '暴怒的阿迦赛罗斯',
            '卡尔加·刺肋',
        },
        ['smgy'] = {
            '审讯员韦沙斯',
            '血法师萨尔诺斯',
        },
        ['smarmory'] = {
            'Hero',
        },
        ['smcath'] = {
            '大检察官法尔班克斯',
            '血色十字军指挥官莫格莱尼',
            'High Inquisitor Whiteman',
        },
        ['smlib'] = {
            '驯犬者洛克希',
            'Arcanist Doa',
        },
        ['rfd'] = {
            'Tuten\'kash',
            '火眼莫德雷斯',
            '暴食者',
            '拉戈斯诺特',
            '寒冰之王亚门纳尔',
        },
        ['ulda'] = {
            '鲁维罗什',
            '艾隆纳亚',
            '黑曜石哨兵',
            '古代的石头看守者',
            '加加恩·火锤',
            '格瑞姆洛克',
            '阿扎达斯',
        },
        ['gilneas'] = {
            'Matthias Holtz',
            'Judge Sutherland',
            'Dustivan Blackcowl',
            'Marshal Magnus Greystone',
            'Celia Harlow',
            'Mortimer Harlow',
            'Genn Greymane',
        },
        ['zf'] = {
            'Antu\'sul',
            '殉教者塞卡',
            'Witch Doctor Zum\'rah',
            '沙怒刽子手',
            '耐克鲁姆',
            'Shadowpriest Sezz\'ziz',
            '布莱中士',
            '水占师维蕾萨',
            '卢兹鲁',
            '乌克兹·沙顶',
        },
        ['maraorange'] = {
            '诺克赛恩',
            '锐刺鞭笞者',
        },
        ['marapurple'] = {
            '维利塔恩',
            '被诅咒的塞雷布拉斯',
        },
        ['maraprincess'] = {
            '工匠吉兹洛克',
            '兰斯利德',
            '洛特格里普',
            '瑟莱德丝公主',
        },
        ['st'] = {
            'Jammal\'an the Prophet',
            '可悲的奥戈姆',
            '德姆塞卡尔',
            '德拉维沃尔',
            '摩弗拉斯',
            '哈扎斯',
            '伊兰尼库斯的阴影',
            'Atal\'alarion',
        },
        ['brd'] = {
            '洛考尔',
            'Bael\'Gar',
            '审讯官格斯塔恩',
            '驯犬者格雷布玛尔',

            '控火师罗格雷恩',
            '弗诺斯·达克维尔',

            '安格弗将军',
            '傀儡统帅阿格曼奇',

            '伊森迪奥斯',

            '霍尔雷·黑须',
            '普拉格',
            '雷布里·斯库比格特',
            '法拉克斯',

            '典狱官斯迪尔基斯',

            '卫兵杜格瑞普',
            '维雷克',

            '弗莱拉斯大使',
            '玛格姆斯',
            '达格兰·索瑞森大帝',
        },
        ['brdemp'] = {
            '安格弗将军',
            '傀儡统帅阿格曼奇',
            '达格兰·索瑞森大帝',
            '玛格姆斯',
            '弗莱拉斯大使',
        },
        ['brdarena'] = {
            'Anub\'shiah-s',
            'Eviscerator-s',
            'Gorosh the Dervish-s',
            'Grizzle-s',
            'Hedrum the Creeper-s',
            'Ok\'thor the Breaker-s',
        },
        ['lbrs'] = {
            '欧莫克大王',
            'Shadow Hunter Vosh\'gajin',
            '指挥官沃恩',
            '烟网蛛后',
            '军需官兹格雷斯',
            '哈雷肯',
            '奴役者基兹鲁尔',
            '维姆萨拉克',
        },
        ['ubrs'] = {
            '烈焰卫士艾博希尔',
            '大酋长雷德·黑手',
            '比斯巨兽',
            '达基萨斯将军',
        },
        ['dme'] = {
            'Pusilin',
            '瑟雷姆·刺蹄',
            '海多斯博恩',
            '蕾瑟塔蒂丝',
            '奥兹恩',
        },
        ['dmn'] = {
            'Guard Mol\'dar',
            '践踏者克雷格',
            '卫兵芬古斯',
            'Guard Slip\'kik',
            '克罗卡斯',
            '戈多克大王',
        },
        ['dmt'] = {
            '戈多克大王',
        },
        ['dmw'] = {
            '特迪斯·扭木',
            '伊琳娜·暗木',
            '卡雷迪斯镇长',
            'Immol\'thar',
            '托塞德林王子',
        },
        ['scholo'] = {
            '詹迪斯·巴罗夫',
            '血骨傀儡',
            '莱斯·霜语',
            '讲师玛丽希亚',
            '瑟尔林·卡斯迪诺夫教授',
            '博学者普克尔特',
            '拉文尼亚',
            '阿雷克斯·巴罗夫',
            '伊露希亚·巴罗夫',
            '黑暗院长加丁',
        },
        ['stratlive'] = {
            '不可宽恕者',
            '悲惨的提米',
            '狂热的玛洛尔',
            '炮手威利',
            '档案管理员加尔福特',
            '巴纳扎尔',
        },
        ['stratud'] = {
            'Nerub\'enkan',
            '安娜丝塔丽男爵夫人',
            '苍白的玛勒基',
            '巴瑟拉斯镇长',
            '吞咽者拉姆斯登',
            '瑞文戴尔男爵',
        },
        ['cotbm'] = {
            'Chronar',
            'Time-Lord Epochronos',
            'Antnorm',
        },
        ['kc'] = {
            'Marrowspike',
            'Hivaxxis',
            'Corpsemuncher',
            'Archlich Enkhraz',
            'Alaru',
        },
        ['swv'] = {
            'Aszosh Grimflame',
            'Tham\'Grarr',
            'Black Bride',
            'Damian',
            'Volkan Cruelblade',
            'Arc\'tira',
        },
        ['tcg'] = {
            'Grovetender Engryss',
            'Keeper Ranathos',
            'High Priestess A\'lathea',
            'Fenektis the Deceiver',
            'Master Raxxiet',
        },
        ['hfq'] = {
            'High Foreman Bargul Blackhammer',
            'Engineer Figgles',
            'Corrosis',
            'Hatereaver Annihilator',
            'Har\'gesh Doomcalle', }
    }
end
