class Rectangle
  x: 0
  y: 0
  width: 0
  height: 0
  constructor: (options) ->
    if options
      @x = options.x if options.x?
      @y = options.y if options.y?
      @width = options.width if options.width?
      @height = options.height if options.height?
    
module.exports = Rectangle