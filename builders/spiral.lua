local Guitree = require "awesome-leaved.guitree"

local spiral = {}

function spiral:init() end
function spiral:cleanup() end

function spiral.nextOrder(initLayout, lastFocusNode, requestedOrder)
    local ret
    if initLayout then
        if spiral.lastOrder == Guitree.horiz then
            spiral.lastOrder = Guitree.vert
        else
            spiral.lastOrder = Guitree.horiz
        end
        return spiral.lastOrder
    end

    local lastFocusGeo = lastFocusNode.data.c:geometry()

    local nextOrder = requestedOrder
    if not nextOrder then
        if (lastFocusGeo.width <= lastFocusGeo.height) then
            nextOrder = Guitree.vert
        else
            nextOrder = Guitree.horiz
        end
    elseif nextOrder == Guitree.opp then
        if lastFocusOrder == Guitree.horiz then
            nextOrder = Guitree.vert
        elseif lastFocusOrder== Guitree.vert then
            nextOrder = Guitree.horiz
        else
            nextOrder = lastFocusOrder
        end
    end
    return nextOrder
end

function spiral:handleNew(p, tree, lastFocusNode, initLayout, requestedOrder)
    local top = tree.top

    for i, c in ipairs(p.clients) do
        --maybe unnecessarily slow? could maintain a list of tracked clients
        local possibleChild = top:findWith("window", c.window)
        if not possibleChild then
            local newTip = Guitree:newClient(c)

            if lastFocusNode then
                local lastFocusParent = lastFocusNode.parent
                local lastFocusOrder= lastFocusParent:getOrder()

                local nextOrder = spiral.nextOrder(initLayout, lastFocusNode, requestedOrder)

                if lastFocusOrder ~= nextOrder then
                    lastFocusNode:add(newTip)
                    newTip.parent:setOrder(nextOrder)
                else
                    lastFocusParent:add(newTip)
                end
            else
                top:add(newTip)
            end
            lastFocusNode = newTip
        else
            lastFocusNode = possibleChild
        end
    end
end

spiral.versions = {spiral}
return spiral
