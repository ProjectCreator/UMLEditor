class App.UMLClass

    # CONSTRUCTOR
    constructor: (editor, name, attributes, methods, options = {}) ->
        # preprocess data
        for attribute in attributes when not attribute.visibility
            attribute.visibility = "public"
        for method in methods
            if not method.visibility
                method.visibility = "public"
            if not method.parameters
                method.parameters = []

        @editor = editor
        @name = name
        @attributes = attributes
        @methods = methods
        @isAbstract = options.abstract or false
        @isInterface = options.interface or false
        @outConnections = []

        @views =
            class:  new App.UMLClassView(@)
            edit:   new App.UMLClassEditView(@)
        Object.defineProperty @views, "all", {
            enumerable: false
            writable: false
            value: ["class", "edit"]
        }

    checkConnection: (connection) ->
        # TODO: for generalization and realization -> prevent cycles!
        id = connection.getId()
        for c in @outConnections when c.getId() is id
            throw new Error("Connection of that type already exists for class '#{@name}'")

        # check other class'es outConnections for generalizations/realizations with 'this' as target
        type = connection.getType()
        if type is "generalization" or type is "realization"
            for c in @editor.getClass(connection.target).outConnections
                type = c.getType()
                if (type is "generalization" or type is "realization") and c.target is @name
                    throw new Error("Cyclic generalization or realization detected!")

        return @

    addConnection: (connection) ->
        try
            @checkConnection connection
            @outConnections.push connection
        catch err
            console.error err
        return @

    drawAll: () ->
        # initial draw for views
        for name, view of @views
            view.draw()
        return @

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

    serialize: () ->
        return {
            name: @name
            attributes: @attributes
            methods: @methods
            isAbstract: @isAbstract
            isInterface: @isInterface
            outConnections: @outConnections
        }
