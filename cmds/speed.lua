return {
    alias = {},
    func = function(imtable:table)
        LOCALPLAYER.Character.Humanoid.WalkSpeed = tonumber(imtable.text)
    end
}