SQRT = Math.sqrt

class Vector2D
  x: 0
  y: 0
  constructor: (options)->
    if options
      @x = options.x if options.x
      @y = options.y if options.y
  lengthSquared: ()->
    return @x * @x + @y * @y
  length: ()->
    SQRT(@lengthSquared())
  add: (v)->
    that = @
    return new Vector2D
      x: that.x + v.x
      y: that.y + v.y
  sub: (v)->
    that = @
    return new Vector2D
      x: that.x - v.x
      y: that.y - v.y
  multiplyByVector: (v)->
    that = @
    return new Vector2D
      x: that.x * v.x
      y: that.y * v.y 
  divideByVector: (v)->
    that = @
    return new Vector2D
      x: that.x / v.x
      y: that.y / v.y 
  dot: (v)->
    return @x * v.x + @y * v.y
  clone: ()->
    that = @
    return new Vector2D
      x: that.x
      y: that.y
  equals: (v)->
    return @x == v.x && @y == v.y
  normalize: ()->
    length = @length()
    if length != 0
      return @divideByScalar(length)
    else
      return new Vector2D()
  flip: ()->
    @multiplyByScalar(-1)
  multiplyByScalar: (s)->
    that = @
    return new Vector2D
      x: s * that.x
      y: s * that.y
  divideByScalar: (s)->
    that = @
    return new Vector2D
      x: that.x / s
      y: that.y / s

module.exports = Vector2D