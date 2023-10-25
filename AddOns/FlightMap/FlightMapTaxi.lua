FLIGHTMAP_MAX_TAXIPATHS = 48;
FLIGHTMAP_MAX_TAXINODES = 32;

function FlightMapTaxi_SetContinent(cont)
    local cname = FlightMapUtil.getContinentName(cont); -- 获取大陆名称
    TaxiMerchant:SetText(cname); -- 设置名称
    local tname = "Interface\\TaxiFrame\\TAXIMAP" .. 2-cont;
    TaxiMap:SetTexture(tname);
    FlightMapTaxiFrame_OnEvent(cont);
end

-- 显示飞行点
function FlightMapTaxi_ShowContinent()
    if TaxiFrame:IsVisible() then
        HideUIPanel(TaxiFrame);
        return;
    end

    TaxiPortrait:SetTexture("Interface\\WorldMap\\WorldMap-Icon");
    for i = 1, NUM_TAXI_BUTTONS, 1 do
        local btn = getglobal("TaxiButton" .. i);
        if btn then btn:Hide(); end
    end

    -- Get a (non-instanced) continent number 获取（未实例化的）大陆编号
    local cont = FlightMapUtil.getContinent();
    if cont == 0 then cont = 1; end

    -- Must kill "OnShow" handler briefly 必须短暂终止“OnShow”处理程序
    local onshow = TaxiFrame:GetScript("OnShow");
    TaxiFrame:SetScript("OnShow", function()
        PlaySound("igMainMenuOpen");
    end);
    ShowUIPanel(TaxiFrame, 1);
    TaxiFrame:SetScript("OnShow", onshow);

    -- 切换飞行地图/暴雪的东西
    TaxiRouteMap:Hide(); -- 暴雪的隐藏
    FlightMapTaxiContinents:Show(); -- 插件的显示

    -- 然后设置大陆编号
    FlightMapTaxi_SetContinent(cont);

    UIDropDownMenu_SetSelectedID(FlightMapTaxiContinents, cont);
end

function FlightMapTaxiButton_OnEnter(button)
    GameTooltip:SetOwner(button, "ANCHOR_RIGHT");
    FlightMapUtil.addFlightsForNode(GameTooltip, button.nodeKey, '', FlightMapTaxiFrame.sourceKey);
    if FlightMapTaxiFrame.sourceNode then
        local costs = FlightMapTaxiFrame.sourceNode.Costs;
        if costs[button.nodeKey] and costs[button.nodeKey] > 0 then
            SetTooltipMoney(GameTooltip, costs[button.nodeKey]);
        end
    end
    GameTooltip:Show();
end

function FlightMapTaxiButton_OnLeave(button)
    GameTooltip:Hide();
end

-- 加载时
function FlightMapTaxiFrame_OnLoad()
    this:RegisterEvent("TAXIMAP_OPENED");
    TaxiButtonTypes["UNKNOWN"] = {
        file = "Interface\\TaxiFrame\\UI-Taxi-Icon-Gray"
    };
end

function FlightMapTaxiFrame_OnEvent(event)
    -- Hide any unused lines left over from a previous flight master visit
    -- 隐藏上次飞行管理员访问留下的任何未使用的线路
    for i = 1, FLIGHTMAP_MAX_TAXIPATHS, 1 do
        getglobal("FlightMapTaxiPath" .. i):Hide();
    end

    -- Hide any unused icons too 也隐藏所有未使用的图标
    for i = 1, FLIGHTMAP_MAX_TAXINODES, 1 do
        getglobal("FlightMapTaxiButton" .. i):Hide();
    end

    -- 如果事件不是 "TAXIMAP_OPENED" 那么这就是一张anywhere-display的地图。
    local thiscont = event;
    if event == "TAXIMAP_OPENED" then
        -- 重新打开路线图
        TaxiRouteMap:Show();
        -- 关闭大陆选择
        FlightMapTaxiContinents:Hide();
        -- 检查选项已打开
        if not FlightMap.Opts.fullTaxiMap then
            return;
        end
        thiscont = FlightMapUtil.getContinent();
    end

    local map = FlightMapUtil.getFlightMap();

    -- 重置
    FlightMapTaxiFrame.sourceKey = nil;
    FlightMapTaxiFrame.sourceNode = nil;

    -- 因此，NumTaxiNodes() 始终返回一个值
    local numNodes = NumTaxiNodes();
    if event ~= "TAXIMAP_OPENED" then
        numNodes = 0;
    end

    -- 构建暴雪客户端处理过的节点列表
    local shownNodes = {};
    local dontShow = {};
    FlightMapTaxiFrame.Destinations = {};
    for i = 1, numNodes do
        local tx, ty = TaxiNodePosition(i);
        local node = FlightMapUtil.makeNodeName(thiscont, tx, ty);
        shownNodes[node] = true;
        if TaxiNodeGetType(i) == "CURRENT" then
            FlightMapTaxiFrame.sourceKey = node;
            FlightMapTaxiFrame.sourceNode = map[node];
        end
        if TaxiNodeGetType(i) == "NONE" then
            dontShow[node] = true;
        end
        FlightMapTaxiFrame.Destinations[node] = i;
    end

    -- Show the entire flight map as a faint overlay
    local seen = {};
    local linenum = 1;
    local nodenum = 1;
    for key, node in map do
        -- If it's on this continent, and hasn't been drawn, fill it in
        if not shownNodes[key] and node.Continent == thiscont
        and (FlightMap.Opts.showAllInfo or FlightMapUtil.knownNode(key)) then
            local button = getglobal("FlightMapTaxiButton" .. nodenum);
            if button then
                nodenum = nodenum + 1;
                button:ClearAllPoints();
                button:SetPoint("CENTER", "TaxiMap", "BOTTOMLEFT",
                    node.Location.Taxi.x * TAXI_MAP_WIDTH,
                    node.Location.Taxi.y * TAXI_MAP_HEIGHT);
                button.nodeKey = key;
                button.node    = node;
                if FlightMapUtil.knownNode(key) then
                    button:SetNormalTexture(TaxiButtonTypes["REACHABLE"].file);
                else
                    button:SetNormalTexture(TaxiButtonTypes["UNKNOWN"].file);
                end
                button:Show();
            end
        end
        
        -- Draw all single-hop lines
        for k, v in node.Flights do
            local tex = getglobal("FlightMapTaxiPath" .. linenum);
            if tex and not seen[key .. "-" .. k]
            and node.Continent == thiscont and map[k]
            and not dontShow[k] and not dontShow[key]
            and not (node.Routes and node.Routes[k]) then
                linenum = linenum + 1;
                seen[key .. "-" .. k] = true;
                seen[k .. "-" .. key] = true;
                if FlightMap.Opts.showAllInfo
                or (FlightMapUtil.knownNode(k)
                and FlightMapUtil.knownNode(key)) then
                    FlightMapUtil.drawLine(TaxiMap, tex,
                        node.Location.Taxi.x, 1 - node.Location.Taxi.y,
                        map[k].Location.Taxi.x, 1 - map[k].Location.Taxi.y);
                    tex:SetAlpha(0.5);
                end
            end
        end
    end
end

function FlightMapTaxiContinents_OnLoad()
    UIDropDownMenu_Initialize(this, FlightMapTaxiContinents_Initialize);
    UIDropDownMenu_SetWidth(130);
end

function FlightMapTaxiContinents_Initialize()
    local function init(...)
        local info;
        for i = 1, arg.n, 1 do
            info = {
                text = arg[i],
                func = FlightMapTaxiContinents_OnClick,
            };
            UIDropDownMenu_AddButton(info);
        end
    end
    init(GetMapContinents());
end

function FlightMapTaxiContinents_OnClick()
    UIDropDownMenu_SetSelectedID(FlightMapTaxiContinents, this:GetID());
    FlightMapTaxi_SetContinent(this:GetID());
end
