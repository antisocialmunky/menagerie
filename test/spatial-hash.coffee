should = require('chai').should()
SpatialHash = require '../lib/spatial-hash'
Rectangle = require '../lib/rectangle'

describe 'SpatialHash', ->
  spatialHash = new SpatialHash(
    width: 100
    height: 100
    pixelWidth: 10
    pixelHeight: 10)
  object = 
    x: 50
    y: 50
  rect = new Rectangle(
    x: 50
    y: 50
    width: 20
    height: 20)
  it 'should construct correctly', ->
    spatialHash.width.should.equal 100
    spatialHash.height.should.equal 100
    spatialHash.pixelWidth.should.equal 10
    spatialHash.pixelHeight.should.equal 10
  it 'should add/get/clear an object correctly',->
    spatialHash.add(object)
    spatialHash.get(spatialHash.hash(55, 55))[0].should.equal object
    spatialHash.get(spatialHash.hash(50, 50))[0].should.equal object
    should.not.exist(spatialHash.get(spatialHash.hash(60, 60)))

    spatialHash.clear()

    should.not.exist(spatialHash.get(spatialHash.hash(55, 55)))
    should.not.exist(spatialHash.get(spatialHash.hash(50, 50)))

  it 'should add/get/clear a rect object correctly',->
    spatialHash.add(rect)
    spatialHash.get(spatialHash.hash(75, 75))[0].should.equal rect
    spatialHash.get(spatialHash.hash(70, 70))[0].should.equal rect
    spatialHash.get(spatialHash.hash(65, 65))[0].should.equal rect
    spatialHash.get(spatialHash.hash(60, 60))[0].should.equal rect
    spatialHash.get(spatialHash.hash(55, 55))[0].should.equal rect
    spatialHash.get(spatialHash.hash(50, 50))[0].should.equal rect
    should.not.exist(spatialHash.get(spatialHash.hash(80, 80)))

    spatialHash.clear()
    
    should.not.exist(spatialHash.get(spatialHash.hash(75, 75)))
    should.not.exist(spatialHash.get(spatialHash.hash(70, 70)))
    should.not.exist(spatialHash.get(spatialHash.hash(65, 65)))
    should.not.exist(spatialHash.get(spatialHash.hash(60, 60)))
    should.not.exist(spatialHash.get(spatialHash.hash(55, 55)))
    should.not.exist(spatialHash.get(spatialHash.hash(50, 50)))
