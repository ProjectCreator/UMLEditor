class App.UMLClass

    # CONSTRUCTOR
    constructor: (editor, name, attributes, methods, options) ->
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
        @type = null
        @attributes = attributes
        @methods = methods
        @isAbstract = options.isAbstract or false
        @isInterface = options.isInterface or false
        @outConnections = options.outConnections or []

        @views =
            class:  new App.UMLClassView(@)
            edit:   new App.UMLClassEditView(@)
        Object.defineProperty @views, "all", {
            enumerable: false
            writable: false
            value: ["class", "edit"]
        }

    # STATIC METHODS
    @fromJSON: (editor, data) ->
        return new @(
            editor
            data.name
            data.attributes
            data.methods
            {
                isAbstract: data.isAbstract
                isInterface: data.isInterface
                outConnections: (App.Connections.UMLConnection.fromJSON(connection) for connection in data.outConnections)
            }
        )


    # INSTANCE METHODS
    checkConnection: (connection) ->
        return App.UMLConstraints.edge(@editor, @, connection)

    addConnection: (connection) ->
        checkResult = @checkConnection(connection)
        if checkResult is true
            @outConnections.push connection
        else
            @editor.showError """UML constraint for <strong>#{connection.type._capitalize()}</strong> not satisfied!
                                <br /><br />
                                <strong>Error:</strong> #{checkResult}"""
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
            outConnections: (connection.serialize() for connection in @outConnections)
        }

    deserialize: (data) ->
        @name = data.name
        @attributes = data.attributes
        @methods = data.methods
        @isAbstract = data.isAbstract
        @isInterface = data.isInterface
        @outConnections = data.outConnections
        return @
