-- @scott

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

function PriorityQueue.new()
    local self = setmetatable({}, PriorityQueue)
    self._heap = {}
    return self
end

-- Helper function to swap nodes in the heap
local function swap(heap, i, j)
    heap[i], heap[j] = heap[j], heap[i]
end

-- Helper function to bubble up a node in the heap
local function bubbleUp(heap, index)
    local parentIndex = math.floor(index / 2)
    if index > 1 and heap[index].priority > heap[parentIndex].priority then
        swap(heap, index, parentIndex)
        bubbleUp(heap, parentIndex)
    end
end

-- Helper function to bubble down a node in the heap
local function bubbleDown(heap, index)
    local size = #heap
    local leftChild = 2 * index
    local rightChild = 2 * index + 1
    local largest = index

    if leftChild <= size and heap[leftChild].priority > heap[largest].priority then
        largest = leftChild
    end

    if rightChild <= size and heap[rightChild].priority > heap[largest].priority then
        largest = rightChild
    end

    if largest ~= index then
        swap(heap, index, largest)
        bubbleDown(heap, largest)
    end
end

-- Adds a new element to the priority queue
function PriorityQueue:Insert(value, priority)
    local node = Node.new(value, priority)
    table.insert(self._heap, node)
    bubbleUp(self._heap, #self._heap)
end

-- Removes and returns the highest-priority element
function PriorityQueue:ExtractMax()
    if #self._heap == 0 then
        error("Priority queue is empty")
    end

    local maxNode = self._heap[1]
    local lastNode = table.remove(self._heap)

    if #self._heap > 0 then
        self._heap[1] = lastNode
        bubbleDown(self._heap, 1)
    end

    return maxNode.value
end

-- Peeks at the highest-priority element without removing it
function PriorityQueue:Peek()
    if #self._heap == 0 then
        error("Priority queue is empty")
    end
    return self._heap[1].value
end

-- Updates the priority of an existing element
function PriorityQueue:UpdatePriority(value, newPriority)
    local index = self:_findIndex(value)
    if not index then
        error("Element not found")
    end

    local node = self._heap[index]
    node.priority = newPriority
    bubbleUp(self._heap, index)
    bubbleDown(self._heap, index)
end

-- Finds the index of a node with a specific value
function PriorityQueue:_findIndex(value)
    for i, node in ipairs(self._heap) do
        if node.value == value then
            return i
        end
    end
    return nil
end

-- Returns the size of the priority queue
function PriorityQueue:Size()
    return #self._heap
end

-- Clears the priority queue
function PriorityQueue:Clear()
    self._heap = {}
end

-- Prints the priority queue for debugging purposes
function PriorityQueue:Print()
    for i, node in ipairs(self._heap) do
        print(string.format("Index: %d, Value: %s, Priority: %d", i, tostring(node.value), node.priority))
    end
end

return PriorityQueue
