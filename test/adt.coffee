ADT = require '../lib/adt'
Rectangle = ADT.Rectangle
Bounds = ADT.Bounds
Vector2D = ADT.Vector2D

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

float = Math.random()*100
describe 'Vector2D', ->
  it 'should default construct', ->
    v = new Vector2D()
    v.x.should.equal 0
    v.y.should.equal 0
  it 'should construct', ->
    v = new Vector2D
      x: float
      y: float
    v.x.should.equal float
    v.y.should.equal float
  it 'should add to another vector', ->
    v1 = new Vector2D
      x: float
      y: float
    v2 = new Vector2D
      x: float
      y: float
    v3 = v1.add v2
    v3.x.should.equal 2 * float
    v3.y.should.equal 2 * float
  it 'should subtract from another vector', ->
    v1 = new Vector2D
      x: float
      y: float
    v2 = new Vector2D
      x: float
      y: float
    v3 = v1.sub v2
    v3.x.should.equal 0
    v3.y.should.equal 0
  it 'should clone itself', ->
    v1 = new Vector2D
      x: float
      y: float
    v2 = v1.clone()
    v1.should.not.equal v2
    v1.x.should.equal v2.x
    v1.y.should.equal v2.y
  it 'should equal another vector', ->
    v1 = new Vector2D
      x: float
      y: float
    v2 = new Vector2D
    v3 = v1.clone()
    v1.equals(v2).should.equal false
    v1.equals(v3).should.equal true
  it 'should do scalar multiple and divide', ->
    v1 = new Vector2D
      x: float
      y: float
    v2 = v1.flip()
    v2.x.should.equal -float
    v2.y.should.equal -float
    v3 = v1.multiplyByScalar(2)
    v3.x.should.equal float * 2
    v3.y.should.equal float * 2
    v4 = v1.divideByScalar(2)
    v4.x.should.equal float / 2
    v4.y.should.equal float / 2
    v5 = v1.normalize()
    len = Math.sqrt(float * float * 2)
    v5.x.should.equal float / len
    v5.y.should.equal float / len
  it 'should dot correctly', ->
    v = new Vector2D
      x: float
      y: float
    v.dot(v).should.equal float*float*2
  it 'should calculate length and lengthSquared', ->
    v = new Vector2D
      x: float
      y: float
    v.lengthSquared().should.equal float * float * 2
    v.length().should.equal Math.sqrt(v.lengthSquared())