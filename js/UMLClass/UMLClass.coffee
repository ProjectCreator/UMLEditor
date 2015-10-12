class App.UMLClass

    # CONSTRUCTOR
    constructor: (name, attributes, methods, options) ->
        # preprocess data
        for attribute in attributes when not attribute.visibility
            attribute.visibility = "public"
        for method in methods
            if not method.visibility
                method.visibility = "public"
            if not method.parameters
                method.parameters = []

        @name = name
        @attributes = attributes
        @methods = methods
        @isAbstract = options.abstract or false
        @isInterface = options.interface or false

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
    update: (attributes, methods, options, viewsToUpdate = @views.all) ->
        if attributes?
            @attributes = attributes
        if methods?
            @methods = methods

        @isAbstract = options.isAbstract
        @isInterface = options.isInterface

        for viewName in viewsToUpdate
            @views[viewName].redraw()

        return @

    delete: () ->
        for name, view of @views
            view.delete()
        return null

    # TODO: controller-like
    enterEditMode: () ->
        @views.edit.show()
        return true

    exitEditMode: () ->
        @views.edit.hide()
        return true
