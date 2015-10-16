class App.Connections.Generalization extends App.Connections.UMLConnection

    @getArrowhead: () ->
        # '.marker-target': { d: 'M 20 0 L 0 10 L 20 20 z', fill: 'white' }}
        return (parent, id, edge, type) ->
            marker = parent.append("marker")
                .attr("id", id)
                .attr("viewBox", "0 0 10 10")
                .attr("refX", 9)
                .attr("refY", 5)
                .attr("markerUnits", "strokeWidth")
                .attr("markerWidth", 8)
                .attr("markerHeight", 6)
                .attr("orient", "auto")

            path = marker.append("path")
                .attr("d", "M 20 0 L 0 10 L 20 20 z")
                .style("stroke-width", 1)
                # .style("stroke-dasharray", "1,0")
                .style("fill", "#fff")
                .style("stroke", "#333")
            dagreD3.util.applyStyle(path, edge[type + "Style"])
            return parent
