class App.UMLClass

    # CONSTRUCTOR
    constructor: (name, attributes, methods) ->
        @name       = name
        @attributes = attributes
        @methods    = methods
        @views      =
            class:  new App.UMLClassView(@, d3.select("svg"))
            edit:   new App.UMLClassEditView(@)

        # initial draw for views
        for name, view of @views
            view.draw()

    # update properties and redraw all views
    update: (properties = {}) ->
        for key, val of properties
            @[key] = val

        for name, view of @views
            view.redraw(properties)

        return @



class App.UMLClassView extends App.View

    # CONSTRUCTOR
    constructor: (umlClass, container) ->
        super(umlClass, container)

    # @Override
    draw: () ->
        data = [
            { "rx": 110, "ry": 110, "height": 30, "width": 30, "color" : "blue" }
            { "rx": 160, "ry": 160, "height": 30, "width": 30, "color" : "red" }
        ]
        rectangles = @container.selectAll("rect")
            .data(data)
            .enter()
            .append("rect")

        rectangleAttributes = rectangles
            .attr("x", (d) -> return d.rx)
            .attr("y", (d) -> return d.ry)
            .attr("height", (d) -> return d.height)
            .attr("width", (d) -> return d.width)
            .style("fill", (d) -> return d.color)

        return @

    #
    redraw: (properties) ->
        return @

class App.UMLClassEditView extends App.View

    # CONSTRUCTOR
    constructor: (umlClass, container) ->
        super(umlClass, container)

    draw: () ->
        return @

    redraw: (properties) ->
        return @
