
class App.AbstractView

    # CONSTRUCTOR
    constructor: (model) ->
        @model = model

    # STATIC METHODS
    @appendDataToSVG: (container, data) ->
        element = container.append data.tag

        for attrName, val of data when attrName isnt "tag" and attrName isnt "children"
            if attrName is "class"
                attrName = "classed"

            if attrName isnt "classed"
                element[attrName]?(val) or element.attr(attrName, val)
            else
                element.classed val, true


        if data.children?
            for childData in data.children
                @appendDataToSVG(element, childData)

        return container



    # INSTANCE METHODS

    draw: () ->
        return @

    redraw: (properties) ->
        return @
