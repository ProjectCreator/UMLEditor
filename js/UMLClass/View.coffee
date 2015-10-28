class App.View extends App.UMLClass

    # CONSTRUCTOR
    constructor: (editor, name, attributes, methods, options = {}) ->
        super(editor, name, attributes, methods, options)
        @type = "view"
