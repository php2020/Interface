for _,n in {
    "ActionButton",
    "MultiBarBottomLeftButton",
    "MultiBarBottomRightButton",
    "MultiBarLeftButton",
    "MultiBarRightButton",
    "BonusActionButton"
} do
    for i=1,12 do
        local f = getglobal(n..i.."Name")
        f.Show = function()end
        f:Hide()
    end
end
