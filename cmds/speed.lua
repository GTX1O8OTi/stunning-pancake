return {
    alias = {},
    func = function(hi:table)
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = tonumber(hi.text)
    end
}