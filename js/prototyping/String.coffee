String::_idSafe = () ->
    return @replace(/([\u0080-\uffff]|\s+)/g, "_")

String::_capitalize = () ->
    return @[0].toUpperCase() + @slice(1)
