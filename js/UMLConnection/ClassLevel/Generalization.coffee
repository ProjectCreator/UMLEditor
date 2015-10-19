class App.Connections.Generalization extends App.Connections.UMLConnection

    @getArrowhead: () ->
        return (parent, id, edge, type) ->
            marker = parent.append("marker")
                .attr("id", id)
                .attr("viewBox", "0 0 10 15")
                .attr("refX", 11)
                .attr("refY", 7.5)
                .attr("markerUnits", "strokeWidth")
                .attr("markerWidth", 12)
                .attr("markerHeight", 15)
                .attr("orient", "auto")

            path = marker.append("path")
                .attr("d", "M 0 0 L 10 7.5 L 0 15 z")
                .style("stroke-width", 1)
                .style("fill", "#fff")
                .style("stroke", "#000")
            dagreD3.util.applyStyle(path, edge[type + "Style"])
            return parent
