QuadTree = require '../lib/quad-tree'
Rectangle = require '../lib/rectangle'
should = require('chai').should()

float = Math.random() * 100

describe 'QuadTreeNode', ->
  it 'should default construct', ->
    quadtree = new QuadTree.QuadTreeNode()

    quadtree.isLeaf.should.be.true
    quadtree.x.should.be.equal 0
    quadtree.y.should.be.equal 0
    quadtree.width.should.be.equal 0
    quadtree.height.should.be.equal 0
    quadtree.children.should.be.empty
    quadtree.depth.should.be.equal 0
    quadtree.maxDepth.should.be.equal 0
    quadtree.maxChildren.should.be.equal 1000

  it 'should be constructed with input', ->
    quadtree = new QuadTree.QuadTreeNode
      isLeaf: false, #not configurable
      x: float,
      y: float,
      width: float,
      height: float,
      children: [float, float], #not configurable
      depth: float,
      maxDepth: float,
      maxChildren: float

    quadtree.isLeaf.should.be.true
    quadtree.x.should.equal float
    quadtree.y.should.equal float
    quadtree.width.should.be.equal float
    quadtree.height.should.equal float
    quadtree.children.should.be.empty
    quadtree.depth.should.equal parseInt(float, 10)
    quadtree.maxDepth.should.equal parseInt(float, 10)
    quadtree.maxChildren.should.equal parseInt(float, 10)

  quadTreeWithPositionable = 0
  object = 0
  objectToAdd = 0
  beforeEach ->
      quadTreeWithPositionable = new QuadTree.QuadTreeNode(
        x:0,
        y:0,
        width: 256,
        height: 256,
        maxDepth: 2,
        maxChildren: 1)
      object =
        x: 1
        y: 1
        width: 1
        height: 1
      quadTreeWithPositionable.add(object)
      objectToAdd =
        x: 128
        y: 128
        width: 1
        height: 1

  it 'should add objects correctly', ->
    quadTreeWithPositionable.children.length.should.equal 1
    quadTreeWithPositionable.children[0].should.be.equal object
    object._quad.should.equal quadTreeWithPositionable
    object.should.equal quadTreeWithPositionable.children[object._quadIndex]

  it 'should remove objects correctly', ->
    quadTreeWithPositionable.remove(object)

    quadTreeWithPositionable.children.length.should.be.empty
    should.not.exist(object._quad)
    object._quadIndex.should.equal -1

  it 'should subdivide correctly', ->
    quadTreeWithPositionable.add(objectToAdd)
    quadTreeWithPositionable.children.length.should.equal 4
    quadTreeWithPositionable.children[QuadTree.UpperLeft].children.length.should.equal 1
    quadTreeWithPositionable.children[QuadTree.UpperLeft].children[0].should.equal object
    quadTreeWithPositionable.children[QuadTree.BottomRight].children.length.should.equal 1
    quadTreeWithPositionable.children[QuadTree.BottomRight].children[0].should.equal objectToAdd

  it 'should unsubdivide correctly', ->
    quadTreeWithPositionable.add(objectToAdd)
    quadTreeWithPositionable.remove(object)
    quadTreeWithPositionable.remove(objectToAdd)

    quadTreeWithPositionable.children.length.should.equal 0

  it 'should filter correctly', ->
    quadTreeWithPositionable.add(objectToAdd)
    rect = new Rectangle({x: 0, y: 0, width: 127, height: 127})
    results = quadTreeWithPositionable.filterUsingRect(rect)
    results.length.should.equal 1
    results[0].should.equal object

    rect = new Rectangle({x: 0, y: 0, width: 128, height: 128})
    results = quadTreeWithPositionable.filterUsingRect(rect)
    results.length.should.equal 2
    results[0].should.equal object
    results[1].should.equal objectToAdd

    rect = new Rectangle({x: 128, y: 128, width: 128, height: 128})
    results = quadTreeWithPositionable.filterUsingRect(rect)
    results.length.should.equal 1
    results[0].should.equal objectToAdd