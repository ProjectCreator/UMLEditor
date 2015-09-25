class App.UMLDiagram

    # CONSTRUCTOR
    constructor: () ->
        @graph          = new joint.dia.Graph()
        @models         = {}
        @controllers    = {}
        @views          = {}



    addModel: (model) ->
        @models[model.name] = model
        return @

    updateModel: (name, prop, value) ->
        @models[name]

    addController: (controller) ->
        @controllers[controller.name] = controller
        return @

    addView: (view) ->
        @views[view.name] = view
        return @
