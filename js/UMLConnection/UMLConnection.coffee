class App.Connections.UMLConnection

    # CONSTRUCTOR
    constructor: (source, target, sourceMultiplicity, targetMultiplicity) ->
        @source = source
        @target = target
        # @requires not IE
        @type = @constructor.name.toLowerCase()
        @multiplicities =
            source: sourceMultiplicity or new App.UMLMultiplicity()
            target: targetMultiplicity or new App.UMLMultiplicity()

    # STATIC METHODS
    @fromJSON: (data) ->
        return new App.Connections[data.type](
            data.source
            data.target
            App.UMLMultiplicity.fromJSON data.multiplicities.source
            App.UMLMultiplicity.fromJSON data.multiplicities.target
        )

    @getArrowhead: () ->
        throw new Error("Implment me!")

    # INSTANCE METHODS
    getId: () ->
        return "#{@type}-#{@source}-#{@target}"

    serialize: () ->
        return {
            source: @source
            target: @target
            type: @type
            multiplicities:
                source: @multiplicities.source.serialize()
                target: @multiplicities.target.serialize()
        }
