FLOOR = Math.floor

heapId = 0

class Heap
  idIndexMap: null
  nodes: null
  length: 0
  constructor: (options)->
    if !options?
      options = {}
    @nodes = options.nodes || []
    @idIndexMap = {}
    @heapify()

  pop: ()->
    if @length > 0
      shift = @nodes.shift()
      @length--
      node = @nodes
      idIndexMap = @idIndexMap
      for i, node of @nodes
        idIndexMap[node.content._heapId] = i
      sift = 0
      while sift?
        sift = @siftDown(sift)
      return shift.content
    return null

  insert: (content, value)->
    if content? && !content._heapId?
      content._heapId = heapId
      length = @length++
      nodes = @nodes
      nodes[length] = 
        content: content
        value: value
      @idIndexMap[heapId] = length
      @bubbleUp(length)
      heapId++

  update: (content, value)->
    idIndexMap = @idIndexMap
    if content? && content._heapId? && idIndexMap[content._heapId]?
      nodes = @nodes

      i = idIndexMap[content._heapId]
      swap = nodes[i]
      idIndexMap[nodes[0].content._heapId] = i
      idIndexMap[nodes[i].content._heapId] = 0
      nodes[i] = nodes[0]
      nodes[0] = swap
      swap.value = value

      sift = 0
      while sift?
        sift = @siftDown(sift)

  bubbleUp: (i)->
    idIndexMap = @idIndexMap
    nodes = @nodes

    last = i
    parent = last
    while parent != 0
      parent = FLOOR(parent/2)
      if nodes[parent].value > nodes[last].value
        swap = nodes[parent]
        idIndexMap[nodes[parent].content._heapId] = last
        idIndexMap[nodes[last].content._heapId] = parent
        nodes[parent] = nodes[last]
        nodes[last] = swap
      last = parent

  siftDown: (i)->
    idIndexMap = @idIndexMap

    i2 = i * 2

    nodes = @nodes
    node = nodes[i]
    left = i2 + 1
    right = i2 + 2

    if nodes[left]?
      if nodes[right]?
        lesser = if nodes[left].value > nodes[right].value then right else left
        if node.value > nodes[lesser].value
          idIndexMap[nodes[i].content._heapId] = lesser
          idIndexMap[nodes[lesser].content._heapId] = i
          nodes[i] = nodes[lesser]
          nodes[lesser] = node
          return lesser
      else if node.value > nodes[left].value
        idIndexMap[nodes[i].content._heapId] = left
        idIndexMap[nodes[left].content._heapId] = i
        nodes[i] = nodes[left]
        nodes[left] = node
        return left
    return null

  heapify: ()->
    for i in [0..@nodes.length-1]
      @siftDown(i)

module.exports = Heap