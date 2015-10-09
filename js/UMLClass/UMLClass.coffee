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
