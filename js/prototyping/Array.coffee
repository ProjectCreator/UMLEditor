Array::without = (elem) ->
    return (e for e in @ when e isnt elem)

Array::remove = (elem) ->
    idx = @indexOf elem
    if idx >= 0
        @splice idx, 1
    return @
