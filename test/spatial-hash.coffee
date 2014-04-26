should = require('chai').should()
SpatialHash = require '../lib/spatial-hash'
ADT = require '../lib/adt'
Rectangle = ADT.Rectangle

describe 'SpatialHash', ->
  spatialHash = new SpatialHash(
    width: 100
    height: 100
    pixelWidth: 10
    pixelHeight: 10)
  object = 
    position:
      x: 50
      y: 50
  object2 =
    position: 
      x: 80
      y: 80
  object3 = 
    position:
      x: 0
      y: 0
    bounds:
      width: 1
      height: 20
  rect = 
    position:
      x: 50
      y: 50
    bounds:
      width: 20
      height: 20
  it 'should construct correctly', ->
    spatialHash.width.should.equal 100
    spatialHash.height.should.equal 100
    spatialHash.pixelWidth.should.equal 10
    spatialHash.pixelHeight.should.equal 10
  it 'should add/get/clear an object',->
    spatialHash.add(object)
    spatialHash.get(spatialHash.hash(55, 55))['default'][0].should.equal object
    spatialHash.get(spatialHash.hash(50, 50))['default'][0].should.equal object
    should.not.exist(spatialHash.get(spatialHash.hash(60, 60)))

    spatialHash.clear()

    should.not.exist(spatialHash.get(spatialHash.hash(55, 55)))
    should.not.exist(spatialHash.get(spatialHash.hash(50, 50)))

  it 'should add/get/clear a rect object',->
    spatialHash.add(rect)
    spatialHash.get(spatialHash.hash(65, 65))['default'][0].should.equal rect
    spatialHash.get(spatialHash.hash(60, 60))['default'][0].should.equal rect
    spatialHash.get(spatialHash.hash(55, 55))['default'][0].should.equal rect
    spatialHash.get(spatialHash.hash(50, 50))['default'][0].should.equal rect
    spatialHash.get(spatialHash.hash(45, 45))['default'][0].should.equal rect
    spatialHash.get(spatialHash.hash(40, 40))['default'][0].should.equal rect
    should.not.exist(spatialHash.get(spatialHash.hash(35, 35)))
    should.not.exist(spatialHash.get(spatialHash.hash(70, 70)))

    spatialHash.clear()
    
    should.not.exist(spatialHash.get(spatialHash.hash(70, 70)))
    should.not.exist(spatialHash.get(spatialHash.hash(65, 65)))
    should.not.exist(spatialHash.get(spatialHash.hash(60, 60)))
    should.not.exist(spatialHash.get(spatialHash.hash(55, 55)))
    should.not.exist(spatialHash.get(spatialHash.hash(50, 50)))

  it 'should getRect!',->
    spatialHash.add(object)
    spatialHash.add(object2)
    spatialHash.add(object3)

    objects = spatialHash.filterUsingRect(new Rectangle
      x: 50
      y: 50
      width: 50
      height: 50)

    objects.length.should.equal 2
    objects[0]['default'][0].should.equal object
    objects[1]['default'][0].should.equal object2

    spatialHash.clear()
