GLOBAL.CHEATS_ENABLED = true
GLOBAL.require( 'debugkeys' )



GLOBAL.lazyexplorer = function()
    GLOBAL.shittyexplorer()
end

GLOBAL.shittyexplorer = function()
    print("shittyexplorer called")
    
    local mPlayer = GLOBAL.ConsoleCommandPlayer()
    if mPlayer ~= nil then
        local oldPosx,oldPosy,oldPosz = mPlayer.Transform:GetWorldPosition()
        
        
        local swaptime = 0.1 --lower makes it unreliable but faster
        local stepSize = 8
        local coordX = 0
        local coordY = 0
        local coordMax = GLOBAL.TheWorld.Map:GetSize()
        
        function moveit (ent)
        
            --keep trying to move the player to the next valid position until we tried all or 
            --we find a spot to teleport to and then break the loop waiting for the next frame
            --so dont starve has time to mark the area as discovered
            while true do
                print("x " .. coordX .. " y" .. coordY)
                local midx, midy = GLOBAL.TheWorld.Map:GetTileCoordsAtPoint(0,0,0)
                
                local xpos = (coordX - midx) * GLOBAL.TILE_SCALE
                local zpos = (coordY - midy) * GLOBAL.TILE_SCALE
                
                local isValid = GLOBAL.TheWorld.Map:IsAboveGroundAtPoint(xpos, 0, zpos)
                
                
            
            
                --calculate next coordinates
                coordX = coordX + stepSize
                if(coordX < coordMax) then
                    --just continue
                else
                    --one row is finished go to next column
                    coordX = 0
                    coordY = coordY + stepSize
                end
                
                if(isValid) then
                
                    mPlayer.Transform:SetPosition(xpos, 0, zpos)
                end
                
                
                if(coordY < coordMax) then
                
                    if(isValid) then
                        --we changed the position -> wait til next frame to continue
                        ent:DoTaskInTime(swaptime, moveit)
                        break
                    else
                        --the coordinates are not over max but we didn;t move the player -> do nothing and go into the
                        --next loop to find a valid position
                    end
                else
                    --set back to original position
                    mPlayer.Transform:SetPosition(oldPosx, oldPosy, oldPosz)
                    --cleanup
                    ent:Remove()
                    --stop the loop 
                    break
                end
            end
        end
        
        GLOBAL.CreateEntity():DoTaskInTime(swaptime, moveit)
    end
end

