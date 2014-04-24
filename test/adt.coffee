ADT = require '../lib/adt'
Rectangle = ADT.Rectangle
Bounds = ADT.Bounds

describe 'Rectangle', ->
  it 'should default construct correctly', ->
    rectangle = new Rectangle()
    rectangle.x.should.equal 0
    rectangle.y.should.equal 0
    rectangle.width.should.equal 0
    rectangle.height.should.equal 0
  it 'should construct correctly', ->
    x = 1
    y = 1
    width = 100
    height = 100
    rectangle = new Rectangle(
      x: x
      y: y
      width: width
      height: height)
    rectangle.x.should.equal x
    rectangle.y.should.equal y
    rectangle.width.should.equal width
    rectangle.height.should.equal height
    
describe 'Bounds', ->
  it 'should construct circles correctly', ->
    bounds = new Bounds(radius: 10)
    bounds.radius.should.equal 10
    bounds.width.should.equal 20
    bounds.height.should.equal 20
  it 'should construct rectangles correctly', ->
    bounds = new Bounds(width: 20, height: 20)
    bounds.radius.should.equal 10
    bounds.width.should.equal 20
    bounds.height.should.equal 20