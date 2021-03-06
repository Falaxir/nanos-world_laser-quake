-- __          ___           _______. _______ .______           ______      __    __       ___       __  ___  _______
--|  |        /   \         /       ||   ____||   _  \         /  __  \    |  |  |  |     /   \     |  |/  / |   ____|
--|  |       /  ^  \       |   (----`|  |__   |  |_)  |       |  |  |  |   |  |  |  |    /  ^  \    |  '  /  |  |__
--|  |      /  /_\  \       \   \    |   __|  |      /        |  |  |  |   |  |  |  |   /  /_\  \   |    <   |   __|
--|  `----./  _____  \  .----)   |   |  |____ |  |\  \----.   |  `--'  '--.|  `--'  |  /  _____  \  |  .  \  |  |____
--|_______/__/     \__\ |_______/    |_______|| _| `._____|    \_____\_____\\______/  /__/     \__\ |__|\__\ |_______|
--
--.______   ____    ____     _______    ___       __          ___      ___   ___  __  .______
--|   _  \  \   \  /   /    |   ____|  /   \     |  |        /   \     \  \ /  / |  | |   _  \
--|  |_)  |  \   \/   /     |  |__    /  ^  \    |  |       /  ^  \     \  V  /  |  | |  |_)  |
--|   _  <    \_    _/      |   __|  /  /_\  \   |  |      /  /_\  \     >   <   |  | |      /
--|  |_)  |     |  |        |  |    /  _____  \  |  `----./  _____  \   /  .  \  |  | |  |\  \----.
--|______/      |__|        |__|   /__/     \__\ |_______/__/     \__\ /__/ \__\ |__| | _| `._____|

function GetCharacterLookingAt()
    local viewport_2D_center = Render.GetViewportSize() / 2
    local viewport_3D = Render.Deproject(viewport_2D_center)
    local start_location = viewport_3D.Position + viewport_3D.Direction * 100

    -- Gets the end location of the trace (5000 units ahead)
    local trace_max_distance = 20000
    local end_location = viewport_3D.Position + viewport_3D.Direction * trace_max_distance

    -- Determine at which object we will be tracing for (WorldStatic - StaticMeshes - PhysicsBody - Props)
    local collision_trace = CollisionChannel.WorldStatic | CollisionChannel.WorldDynamic | CollisionChannel.PhysicsBody | CollisionChannel.Vehicle | CollisionChannel.Pawn | CollisionChannel.Mesh

    -- Do the Trace
    local trace_result = Client.Trace(start_location, end_location, collision_trace, false, true)

    -- If hit something and hit an Entity
    if (trace_result.Success and trace_result.Entity) then
        if (NanosUtils.IsA(trace_result.Entity, Character)) then
            if trace_result.Entity:IsInvulnerable() then
                return trace_result.Location
            end
            --Client.DrawDebugLine(start_location, trace_result.Entity:GetRotation():RotateVector(trace_result.Entity:GetLocation() - trace_result.Location), Color(0, 1, 1), 2, 10)
            return trace_result.Entity
        end
        return trace_result.Location
    --else
    --    Client.DrawDebugLine(start_location, end_location, Color(0, 1, 1), 2, 10)
    end
    return end_location
end

function GetPositionBlocked()
    local viewport_2D_center = Render.GetViewportSize() / 2
    local viewport_3D = Render.Deproject(viewport_2D_center)
    local start_location = viewport_3D.Position + viewport_3D.Direction * 100

    -- Gets the end location of the trace (5000 units ahead)
    local trace_max_distance = 20000
    local end_location = viewport_3D.Position + viewport_3D.Direction * trace_max_distance

    -- Determine at which object we will be tracing for (WorldStatic - StaticMeshes - PhysicsBody - Props)
    local collision_trace = CollisionChannel.WorldStatic | CollisionChannel.WorldDynamic | CollisionChannel.PhysicsBody | CollisionChannel.Vehicle | CollisionChannel.Pawn | CollisionChannel.Mesh

    -- Do the Trace
    local trace_result = Client.Trace(start_location, end_location, collision_trace, false, true)

    -- If hit something and hit an Entity
    if (trace_result.Success) then
        return trace_result.Location
    else
        return end_location
    end
    return end_location -- THIS IS NOT CORRECT gl to understand why... fucking particles that bend...
end

function GetCoordinatesLookingAt()
    local viewport_2D_center = Render.GetViewportSize() / 2
    local viewport_3D = Render.Deproject(viewport_2D_center)

    -- Gets the end location of the trace (5000 units ahead)
    local trace_max_distance = 20000
    return viewport_3D.Position + viewport_3D.Direction
end