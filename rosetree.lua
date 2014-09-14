-- rosetree.lua
-- Represents a generic rose tree
local Rosetree = {}

function Rosetree:new(data, children, strong)
    local node
    if not children then
        node = {
            tip = true,
            data = data,
            index = nil,
            parent = nil,
        }
    else
        node = {
            tip = false,
            strong = strong or false,
            data = data,
            children = children,
            index = nil,
            parent = nil,
        }
    end
    self.__index = self
    return setmetatable(node, self)
end

Rosetree.newTip = Rosetree.new
Rosetree.newInner = Rosetree.new

function Rosetree:overwrite(dest)
    dest.data = self.data
    dest.tip = self.tip
    dest.strong = self.strong
    dest.children = self.children
end


function Rosetree:destroy()
end

--Insert and node manipulation functions
function Rosetree:add(child, ind)
    --convert to inner
    if self.tip then
        if #self.parent.children == 1 then
            return self.parent:add(child, ind)
        end
        self:destroy()
        self.tip = false
        local cont = self:newInner()
        self.children = {}
        local child = self:newTip(self.data)
        self.data = cont.data
        self:add(child)
        --local cont = self:newInner()
        --self.children = {}
        --local oldData = self.data
        --self.data = cont.data
        --local child = self:newTip(oldData)
        --self.parent.children[self.index] = cont
        --cont.parent = self.parent
        --cont.index = self.index
        --cont:add(self)
        --cont:add(child)
        --return cont
    end
    --reassign parent
    child.parent = self

    --add child
    if ind and ind <= #self.children then
        table.insert(self.children, ind, child)
        for i=ind,#self.children do
            self.children[i].index = i
        end
    else
        table.insert(self.children, child)
        child.index = #self.children
    end
    child.index = ind or #self.children
end

function Rosetree:detach(begin, ende)
    if self.tip then return end
    ende = ande and math.min(ende, #self.children) or begin
    local detached = {}
    local range = (ende - begin)+1
    for i=begin,ende do
        table.insert(detached, table.remove(self.children, begin))
    end
    for i=begin,#self.children do
        self.children[i].index = i 
    end
    if not self.strong then
        if #self.children == 0 then
            self:destroy() 
            if self.parent then
                self.parent:detach(self.index)
            end
        elseif #self.children == 1 then
            self.children[1]:overwrite(self)
        end
    end
    return (range == 1 and detached[1]) or detached
end

function Rosetree:swap(node)
    local own_par = self.parent
    local node_par = node.parent
    if node == self
        or not own_par
        or not node_par then
        return
    else
        local test = self
        local testee = node
        local caught
        for i = 1,2 do
            while test and test ~= testee do
                test = test.parent
            end
            caught = caught or test == testee
            test = node
            testee = self
        end
        if caught then return end
    end
    local ni = node.index
    local oi = self.index
    node_par.children[ni] = self
    own_par.children[oi] = node
    node.index = oi
    self.index = ni
    node.parent = own_par
    self.parent = node_par
    node:refreshLabel()
    self:refreshLabel()
end

--Search and filter rosetrees
function Rosetree:find(compare)
    if self.tip then
        return compare(self) and self or nil
    else
        for _, c in ipairs(self.children) do
            local res = c:find(compare)
            if res then
                return res
            end
        end
    end
end

function Rosetree:filter(p, once)
    if p(self) then
        self:destroy()
        return nil
    elseif not self.tip then
        local i = 1
        while i <= #self.children do
            local child = self.children[i]
            local res = child:filter(p, once)
            if not res then
                table.remove(self.children, i)
                if once then
                    break
                end
            else
                self.children[i] = res
                i=i+1
            end
        end
        if #self.children == 0 then
            self:destroy()
            return self.strong and self or nil
        elseif #self.children == 1 and not self.strong then
            self.children[1]:overwrite(self)
        end
        return self
    else
        return self
    end
end


--must not be used for destructive updates
function Rosetree:traverse(f, p, level)
    if level == nil then
        level = 0
    end
    if p == nil then
        p = function() return true end
    end
    f(self, level)

    if not self.tip and p(self) then
        for _, c in ipairs(self.children) do
            c:traverse(f, p, level + 1)
        end
    end
end

function Rosetree:show(level)
    local function shower(node, level)
        local name 
        if node.tip then
            name = "Tip["
        else
            name = "Node["
        end
        print(string.rep(" ", level) .. name .. tostring(node.data) .. "]")
    end
    self:traverse(shower, function(o) return true end, level)
end

return Rosetree
