class App.UMLMultiplicity

    # CONSTRUCTOR
    constructor: (min = Infinity, max = Infinity) ->
        @min = min
        @max = max

    valToStr: (val) ->
        if val is Infinity
            return "*"
        return "#{val}"

    toString: () ->
        if @min isnt @max
            return "#{@valToStr(@min)}..#{@valToStr(@max)}"
        return "#{@valToStr(@min)}"
