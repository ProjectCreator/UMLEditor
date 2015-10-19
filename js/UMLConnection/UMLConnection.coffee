class App.Connections.UMLConnection

    # CONSTRUCTOR
    constructor: (source, target, sourceMultiplicity, targetMultiplicity) ->
        @source = source
        @target = target
        @multiplicities =
            source: sourceMultiplicity or new App.UMLMultiplicity()
            target: targetMultiplicity or new App.UMLMultiplicity()

    getId: () ->
        return "#{@constructor.name}-#{@source}-#{@target}"

    getType: () ->
        return @constructor.name.toLowerCase()

    @getArrowhead: () ->
        throw new Error("Implment me!")
