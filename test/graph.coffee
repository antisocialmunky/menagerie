Graph = require '../lib/graph'
should = require('chai').should()

describe 'Graph', ->
  object1 = 
    x:1
    y:2
  object2 = 
    x:3
    y:4
  object3 = 
    x:5
    y:6

  it 'should add vertices and edges', ->
    graph = new Graph()

    graph
      .addVertex(object1)
      .addVertex(object2)
      .addEdge(object1, object2, 1)
      .addEdge(object1, object3, 2) #this shouldn't do anything

    graph.vertexIdRef.val.should.equal 2
    object1._vertexId.should.equal 0
    object2._vertexId.should.equal 1
    should.not.exist object3._vertexId
    
    edges = graph.edges[object1._vertexId]
    edges.length.should.equal 1
    edges[0].targetVertex.should.equal object2._vertexId
    edges[0].weight.should.equal 1

  it 'should add vertices and edges bidirectionally', ->
    graph = new Graph()

    graph
      .addVertex(object1)
      .addVertex(object2)
      .addEdges(object1, object2, 1, 2)

    graph.vertexIdRef.val.should.equal 2
    object1._vertexId.should.equal 0
    object2._vertexId.should.equal 1
    
    edges1 = graph.edges[object1._vertexId]
    edges2 = graph.edges[object2._vertexId]
    edges1.length.should.equal 1
    edges1[0].targetVertex.should.equal object2._vertexId
    edges1[0].weight.should.equal 1
    edges2.length.should.equal 1
    edges2[0].targetVertex.should.equal object1._vertexId
    edges2[0].weight.should.equal 2