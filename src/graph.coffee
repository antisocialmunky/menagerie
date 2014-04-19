class Edge
  weight: 1
  targetVertex: 0
  constructor: (options)->
    if options?
      @weight = options.weight if options.weight?
      @targetVertex = options.targetVertex if options.targetVertex?

class Graph
  vertexIdRef: 
    val: 0
  vertices: null
  edges: null
  constructor: (options)->
    @vertices = {}
    @edges = {}
  #A vertex can be any object so it can support generic property bags
  addVertex: (v)->
    if !v._vertexId?
      v._vertexId = @vertexIdRef.val++
    @vertices[v._vertexId] = v
    return @
  addEdge: (v1, v2, weight)->
    id1 = v1._vertexId
    id2 = v2._vertexId
    if id1? && id2?
      edge = new Edge(
        weight: weight
        targetVertex: id2)
      if !@edges[id1]? 
        @edges[id1] = [edge]
      else 
        @edges[id1].push(edge)
    return @
  addEdges: (v1, v2, weight1, weight2)->
    if !weight2?
      weight2 = weight1
    @addEdge(v1, v2, weight1)
    @addEdge(v2, v1, weight2)
    return @
  clear: ()->
    @vertices = {}
    @edges = {}

Graph.Edge = Edge
module.exports = Graph