-- Min heap implementation in Lua
-- Useful for Dijkstra's shortest path algorithm, for instance
-- Author: Stephen Booher

Heap = {
  heap_table={},
  size=0,
  value_function=function (x)
    if x == nil then
      return math.huge
    end

    return x
  end
}

Heap.__index = Heap

function Heap:new(o)
  o = o or {}
  setmetatable(o, self)
  return o
end

function Heap:insert(x)
  self.size = self.size + 1
  self.heap_table[self.size] = x
  self.heap_table[self.size].index = self.size
  self:sift_up(self.size)
end

function Heap:sift_up(k)
  local v = self.heap_table[k]

  while k > 1 and self.value_function(v) < self.value_function(self.heap_table[math.floor(k / 2)]) do
    self.heap_table[k] = self.heap_table[math.floor(k / 2)]
    self.heap_table[k].index = k
    k = math.floor(k / 2)
  end

  self.heap_table[k] = v
  self.heap_table[k].index = k
end

function Heap:sift_down(k)
  local v = self.heap_table[k]
  if v == nil then
    return
  end

  local my_value = self.value_function(v)

  while true do
    local l = 2 * k
    local r = 2 * k + 1

    if l > self.size then
      -- bottom of tree
      break
    end

    if r > self.size or self.value_function(self.heap_table[l]) < self.value_function(self.heap_table[r]) then
      -- swap with l
      j = l
    else
      -- swap with r
      j = r
    end

    if my_value < self.value_function(self.heap_table[l])
      and my_value < self.value_function(self.heap_table[r]) then
      -- stop
      break
    end

    self.heap_table[k] = self.heap_table[j]
    self.heap_table[k].index = k
    k = j
  end

  self.heap_table[k] = v
  self.heap_table[k].index = k
end

function Heap:remove()
  local v = self.heap_table[1]
  self.heap_table[1] = self.heap_table[self.size]
  self.heap_table[self.size] = nil
  self.size = self.size - 1
  self:sift_down(1)
  return v
end

return Heap
