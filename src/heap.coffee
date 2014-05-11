FLOOR = Math.floor

class Heap
  nodes: null
  length: 0
  constructor: (options)->
    #if !options?
      #options = {}
    #@nodes = options.nodes || []
    #@heapify()
    @nodes = []

  pop: ()->
    if @length > 0
      shift = @nodes.shift()
      @length--
      sift = 0
      while sift?
        sift = @siftDown(sift)
      return shift.content
    return null

  insert: (content, value)->
    if content
      length = @length++
      nodes = @nodes
      #objects can onyl be part of one heap at a time, bad things happen otherwise
      content._heapNode = nodes[length] = 
        content: content
        value: value
        index: length
      @bubbleUp(length)

  update: (content, value)->
    if content? && content._heapNode?
      nodes = @nodes
      swap = content._heapNode

      i = swap.index
      nodes[i] = nodes[0]
      nodes[i].index = i
      nodes[0] = swap
      nodes[0].index = 0
      swap.value = value

      sift = 0
      while sift?
        sift = @siftDown(sift)

  bubbleUp: (i)->
    nodes = @nodes

    last = i
    parent = last
    while parent != 0
      parent = FLOOR(parent/2)
      if nodes[parent].value > nodes[last].value
        swap = nodes[parent]
        nodes[parent] = nodes[last]
        nodes[parent].index = parent
        nodes[last] = swap
        nodes[last].index = last
      last = parent

  siftDown: (i)->
    i2 = i * 2

    nodes = @nodes
    node = nodes[i]
    left = i2 + 1
    right = i2 + 2

    if nodes[left]?
      if nodes[right]?
        lesser = if nodes[left].value > nodes[right].value then right else left
        if node.value > nodes[lesser].value
          nodes[i] = nodes[lesser]
          nodes[i].index = i
          nodes[lesser] = node
          nodes[lesser].index = lesser
          return lesser
      else if node.value > nodes[left].value
        nodes[i] = nodes[left]
        nodes[i].index = i
        nodes[left] = node
        nodes[left].index = left
        return left
    return null

#  heapify: ()->
#    for i in [0..@nodes.length-1]
#      @siftDown(i)

module.exports = Heap