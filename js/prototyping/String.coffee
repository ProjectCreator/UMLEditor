String::_idSafe = () ->
    return @replace(/([\u0080-\uffff]|\s+)/g, "_")

String::_idUnique = () ->
    orig = @
    str = orig
    i = 0
    while document.getElementById(str)
        str = "#{orig}-#{i++}"
    return "#{str}"

String::_capitalize = () ->
    return @[0].toUpperCase() + @slice(1)
