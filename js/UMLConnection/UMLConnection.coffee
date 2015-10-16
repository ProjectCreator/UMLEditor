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
        # # Add our custom arrow (a hollow-point)
        # return (parent, id, edge, type) ->
        #     marker = parent.append("marker")
        #         .attr("id", id)
        #         .attr("viewBox", "0 0 10 10")
        #         .attr("refX", 9)
        #         .attr("refY", 5)
        #         .attr("markerUnits", "strokeWidth")
        #         .attr("markerWidth", 8)
        #         .attr("markerHeight", 6)
        #         .attr("orient", "auto")
        #
        #     path = marker.append("path")
        #         .attr("d", "M 0 0 L 10 5 L 0 10 z")
        #         .style("stroke-width", 1)
        #         .style("stroke-dasharray", "1,0")
        #         .style("fill", "#fff")
        #         .style("stroke", "#333")
        #     dagreD3.util.applyStyle(path, edge[type + "Style"])
        #     return parent
        return (parent, id, edge, type) ->

###
NOTE: from joint js

joint.shapes.uml.Generalization = joint.dia.Link.extend({
    defaults: {
        type: 'uml.Generalization',
        attrs: { '.marker-target': { d: 'M 20 0 L 0 10 L 20 20 z', fill: 'white' }}
    }
});

joint.shapes.uml.Implementation = joint.dia.Link.extend({
    defaults: {
        type: 'uml.Implementation',
        attrs: {
            '.marker-target': { d: 'M 20 0 L 0 10 L 20 20 z', fill: 'white' },
            '.connection': { 'stroke-dasharray': '3,3' }
        }
    }
});

joint.shapes.uml.Aggregation = joint.dia.Link.extend({
    defaults: {
        type: 'uml.Aggregation',
        attrs: { '.marker-target': { d: 'M 40 10 L 20 20 L 0 10 L 20 0 z', fill: 'white' }}
    }
});

joint.shapes.uml.Composition = joint.dia.Link.extend({
    defaults: {
        type: 'uml.Composition',
        attrs: { '.marker-target': { d: 'M 40 10 L 20 20 L 0 10 L 20 0 z', fill: 'black' }}
    }
});

joint.shapes.uml.Association = joint.dia.Link.extend({
    defaults: { type: 'uml.Association' }
});

###
