MAX = Math.max

class Rectangle
  x: 0
  y: 0
  width: 0
  height: 0
  constructor: (options) ->
    if options?
      @x = options.x if options.x?
      @y = options.y if options.y?
      @width = options.width if options.width?
      @height = options.height if options.height?

class Bounds
  radius: 0
  width: 0
  height: 0
  constructor: (options) ->
    if options?
      if options.radius
        @radius = options.radius
        @height = @width = @radius * 2
      else if options.width? && options.height?
        @width = options.width
        @height = options.height
        @radius = MAX(@width, @height) / 2

module.exports = 
  Rectangle: Rectangle
  Bounds: Bounds