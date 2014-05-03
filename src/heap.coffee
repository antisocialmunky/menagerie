FLOOR = Math.floor

class Heap
  nodes: null
  length: 0
  constructor: (options)->
    if !options?
      options = {}
    @nodes = options.nodes || []
    @heapify()

  pop: ()->
    if @length > 0
      shift = @nodes.shift()
      @length--
      node = @nodes
      sift = 0
      while sift?
        sift = @siftDown(sift)
      return shift.content
    return null

  insert: (content, value)->
    if content
      length = @length++
      nodes = @nodes
      nodes[length] = 
        content: content
        value: value
      @bubbleUp(length)

  update: (content, value)->
    if content?
      nodes = @nodes
      for i, node of nodes
        if content == node.content
          break

      swap = node
      nodes[i] = nodes[0]
      nodes[0] = swap
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
        nodes[last] = swap
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
          nodes[lesser] = node
          return lesser
      else if node.value > nodes[left].value
        nodes[i] = nodes[left]
        nodes[left] = node
        return left
    return null

  heapify: ()->
    for i in [0..@nodes.length-1]
      @siftDown(i)

module.exports = Heap