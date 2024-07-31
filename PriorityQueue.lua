--@scott

local PriorityQueue = {}
PriorityQueue.__index = PriorityQueue

local Node = {}
Node.__index = Node

function Node.new(value, priority)
    local self = setmetatable({}, Node)
    self.value = value
    self.priority = priority
    return self
end

function PriorityQueue.new(comparator)
    local self = setmetatable({}, PriorityQueue)
    self._heap = {}
    self._comparator = comparator or function(a, b) return a.priority > b.priority end
    return self
end

local function swap(heap, i, j)
    heap[i], heap[j] = heap[j], heap[i]
end

local function bubbleUp(heap, index, comparator)
    local parentIndex = math.floor(index / 2)
    if index > 1 and comparator(heap[index], heap[parentIndex]) then
        swap(heap, index, parentIndex)
        bubbleUp(heap, parentIndex, comparator)
    end
end

local function bubbleDown(heap, index, comparator)
    local size = #heap
    local leftChild = 2 * index
    local rightChild = 2 * index + 1
    local largest = index

    if leftChild <= size and comparator(heap[leftChild], heap[largest]) then
        largest = leftChild
    end

    if rightChild <= size and comparator(heap[rightChild], heap[largest]) then
        largest = rightChild
    end

    if largest ~= index then
        swap(heap, index, largest)
        bubbleDown(heap, largest, comparator)
    end
end

function PriorityQueue:Insert(value, priority)
    local node = Node.new(value, priority)
    table.insert(self._heap, node)
    bubbleUp(self._heap, #self._heap, self._comparator)
end

function PriorityQueue:BatchInsert(values)
    for _, value in ipairs(values) do
        self:Insert(value[1], value[2])
    end
end

function PriorityQueue:ExtractMax()
    if #self._heap == 0 then
        error("Priority queue is empty")
    end

    local maxNode = self._heap[1]
    local lastNode = table.remove(self._heap)

    if #self._heap > 0 then
        self._heap[1] = lastNode
        bubbleDown(self._heap, 1, self._comparator)
    end

    return maxNode.value
end

function PriorityQueue:Peek()
    if #self._heap == 0 then
        error("Priority queue is empty")
    end
    return self._heap[1].value
end

function PriorityQueue:UpdatePriority(value, newPriority)
    local index = self:_findIndex(value)
    if not index then
        error("Element not found")
    end

    local node = self._heap[index]
    node.priority = newPriority
    bubbleUp(self._heap, index, self._comparator)
    bubbleDown(self._heap, index, self._comparator)
end

function PriorityQueue:_findIndex(value)
    for i, node in ipairs(self._heap) do
        if node.value == value then
            return i
        end
    end
    return nil
end

function PriorityQueue:Remove(value)
    local index = self:_findIndex(value)
    if not index then
        error("Element not found")
    end

    local lastNode = table.remove(self._heap)
    if index <= #self._heap then
        self._heap[index] = lastNode
        bubbleDown(self._heap, index, self._comparator)
    end
end

function PriorityQueue:Size()
    return #self._heap
end

function PriorityQueue:Clear()
    self._heap = {}
end

function PriorityQueue:Print()
    for i, node in ipairs(self._heap) do
        print(string.format("Index: %d, Value: %s, Priority: %d", i, tostring(node.value), node.priority))
    end
end

function PriorityQueue:FilterByThreshold(threshold)
    local result = {}
    for _, node in ipairs(self._heap) do
        if node.priority >= threshold then
            table.insert(result, node.value)
        end
    end
    return result
end

function PriorityQueue:Sort()
    table.sort(self._heap, self._comparator)
end

return PriorityQueue
