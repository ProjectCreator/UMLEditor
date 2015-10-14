Array::without = (elem) ->
    return (e for e in @ when e isnt elem)

Array::remove = (elem) ->
    idx = @indexOf elem
    if idx >= 0
        @splice idx, 1
    return @
    
Object.defineProperties Array::, {
    first:
        get: () ->
            return @[0]
        set: (v) ->
            @[0] = v
            return @
    second:
        get: () ->
            return @[1]
        set: (v) ->
            @[1] = v
            return @
    last:
        get: () ->
            return @[@length - 1]
        set: (v) ->
            @[@length - 1] = v
            return @
}
