class App.Controller extends App.UMLClass

    # CONSTRUCTOR
    constructor: (editor, name, attributes, methods, options = {}) ->
        super(editor, name, attributes, methods, options)
        @type = "controller"
