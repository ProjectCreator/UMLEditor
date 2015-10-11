class App.UMLClass

    # CONSTRUCTOR
    constructor: (name, attributes, methods) ->
        # preprocess data
        for attribute in attributes when not attribute.visibility
            attribute.visibility = "public"
        for method in methods when not method.visibility
            method.visibility = "public"

        @name       = name
        @attributes = attributes
        @methods    = methods

        @views      =
            class:  new App.UMLClassView(@, d3.select("svg"))
            edit:   new App.UMLClassEditView(@)
        Object.defineProperty @views, "all", {
            enumerable: false
            writable: false
            value: ["class", "edit"]
        }

        # initial draw for views
        for name, view of @views
            view.draw()

    # update properties and redraw all views
    update: (attributes, methods, viewsToUpdate = @views.all) ->
        if attributes?
            @attributes = attributes
        if methods?
            @methods = methods

        for viewName in viewsToUpdate
            @views[viewName].redraw()

        return @

    # TODO: controller-like
    enterEditMode: () ->
        @views.edit.show()
        return true

    exitEditMode: () ->
        @views.edit.hide()
        return true
