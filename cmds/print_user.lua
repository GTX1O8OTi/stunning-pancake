return {
    alias = {},
    func = function(hi:table)
        for key, player: Player in pairs (hi.playerobjects) do
            print(player.Name)
        end
    end
}