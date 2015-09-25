uml = joint.shapes.uml


stringifyVisibility = (visibilty = "public") ->
    mapper =
        public:     "+"
        protected:  "#"
        package:    "~"
        private:    "-"
    return mapper[visibilty.toLowerCase()]

stringifyParameters = (parameters) ->
    if not parameters or parameters.length is 0
        return ""
    return ("#{param.name}: #{param.type}" for param in parameters).join(", ")


stringifyAttribute = (attribute) ->
    return "#{stringifyVisibility(attribute.visibilty)} #{attribute.name}: #{attribute.type}".trim()

stringifyMethod = (method) ->
    if method.type?
        suffix = ": #{method.type}"
    else
        suffix = ""
    return "#{stringifyVisibility(method.visibilty)} #{method.name}(#{stringifyParameters(method.parameters)})#{suffix}".trim()

calculateHeight = (name, attributes, methods) ->
    return (attributes.length + methods.length) * 14 + 35

textWidthDummy = null
calculateWidth = (name, stringifiedAttributes, stringifiedMethods, style) ->
    if not style?
        style =
            "font-size":    "12px"
            "font-family":  "Times New Roman"

    style["position"]   = "absolute"
    style["visibility"] = "hidden"

    if not textWidthDummy?
        textWidthDummy = $("<div />")
        $(document.body).append textWidthDummy

    textWidthDummy.css style

    maxWidth = 0
    width = 0

    # name
    textWidthDummy.text name
    if (width = textWidthDummy.width()) > maxWidth
        maxWidth = width

    # attributes
    for attribute in stringifiedAttributes
        textWidthDummy.text attribute
        if (width = textWidthDummy.width()) > maxWidth
            maxWidth = width

    # methods
    for method in stringifiedMethods
        textWidthDummy.text method
        if (width = textWidthDummy.width()) > maxWidth
            maxWidth = width

    return maxWidth + 10

# _commonFunctionality: (data, layout) ->
#     name        = data.name
#     attributes  = data.attributes or []
#     methods     = data.methods or []
#
#     stringifiedAttributes   = (stringifyAttribute(attribute) for attribute in attributes)
#     stringifiedMethods      = (stringifyMethod(method) for method in methods)
#
#     x = layout.x or 10
#     y = layout.y or 10
#     w = layout.width or calculateWidth(name, stringifiedAttributes, stringifiedMethods)
#     h = layout.height or calculateHeight(name, attributes, methods)


App.ShapeFactory =
    # TODO: DRY
    Model: new: (data, layout) ->
        name        = "#{data.name} (Model)"
        attributes  = data.attributes or []
        methods     = data.methods or []

        stringifiedAttributes   = (stringifyAttribute(attribute) for attribute in attributes)
        stringifiedMethods      = (stringifyMethod(method) for method in methods)

        x = layout.x or 10
        y = layout.y or 10
        w = layout.width or calculateWidth(name, stringifiedAttributes, stringifiedMethods)
        h = layout.height or calculateHeight(name, attributes, methods)

        object = new uml.Class({
            position:
                x: x
                y: y
            size:
                width: w
                height: h
            # attrs:
            # fill: "green"
            name:       name
            attributes: stringifiedAttributes
            methods:    stringifiedMethods
        })
        object.mvc =
            name:       name
            attributes: stringifiedAttributes
            methods:    stringifiedMethods
            type:       "model"
        return object
    Controller: new: (data, layout) ->
        name        = "#{data.name} (Controller)"
        attributes  = data.attributes or []
        methods     = data.methods or []

        stringifiedAttributes   = (stringifyAttribute(attribute) for attribute in attributes)
        stringifiedMethods      = (stringifyMethod(method) for method in methods)

        x = layout.x or 10
        y = layout.y or 10
        w = layout.width or calculateWidth(name, stringifiedAttributes, stringifiedMethods)
        h = layout.height or calculateHeight(name, attributes, methods)

        object = new uml.Class({
            position:
                x: x
                y: y
            size:
                width: w
                height: h
            name:       name
            attributes: stringifiedAttributes
            methods:    stringifiedMethods
            # type:       "controller"
        })
        object.mvc =
            name:       name
            attributes: stringifiedAttributes
            methods:    stringifiedMethods
            type:       "controller"
        return object
    View: new: (data, layout) ->
        name        = "#{data.name} (View)"
        attributes  = data.attributes or []
        methods     = data.methods or []

        stringifiedAttributes   = (stringifyAttribute(attribute) for attribute in attributes)
        stringifiedMethods      = (stringifyMethod(method) for method in methods)

        x = layout.x or 10
        y = layout.y or 10
        w = layout.width or calculateWidth(name, stringifiedAttributes, stringifiedMethods)
        h = layout.height or calculateHeight(name, attributes, methods)

        object = new uml.Class({
            position:
                x: x
                y: y
            size:
                width: w
                height: h
            name:       name
            attributes: stringifiedAttributes
            methods:    stringifiedMethods
            type:       "view"
        })
        object.mvc =
            name:       name
            attributes: stringifiedAttributes
            methods:    stringifiedMethods
            type:       "view"
        return object
