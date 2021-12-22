local functions = {}
repeat task.wait() until game:IsLoaded()

local supported = {
    [1] = "5901346231",
    [2] = "1340132428",
    
}

function functions.checkifSupported(placeid)
    for _,games in next, supported do
        if placeid == games then
            return true
        else
            return false
        end
    end
end
