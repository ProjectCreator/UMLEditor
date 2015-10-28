class App.Model extends App.UMLClass

    # CONSTRUCTOR
    constructor: (editor, name, attributes, methods, options = {}) ->
        super(editor, name, attributes, methods, options)
        @type = "model"
