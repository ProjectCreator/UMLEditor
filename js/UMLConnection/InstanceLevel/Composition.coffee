class App.Connections.Composition extends App.Connections.UMLConnection

    @getArrowhead: () ->
        return (parent, id, edge, type) ->
            marker = parent.append("marker")
                .attr("id", id)
                .attr("viewBox", "0 0 20 15")
                .attr("refX", 21)
                .attr("refY", 7.5)
                .attr("markerUnits", "strokeWidth")
                .attr("markerWidth", 12)
                .attr("markerHeight", 15)
                .attr("orient", "auto")

            path = marker.append("path")
                # .attr("d", "M 0 10 L 20 7.5 L 10 15 L 0 7.5 z")
                .attr("d", "M 10 0 L 20 7.5 L 10 15 L 0 7.5 z")
                .style("stroke-width", 1)
                .style("fill", "#000")
                .style("stroke", "#000")

            dagreD3.util.applyStyle(path, edge[type + "Style"])
            return parent
