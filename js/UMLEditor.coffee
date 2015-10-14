class App.UMLEditor

    # CONSTRUCTOR
    constructor: () ->
        self = @
        navbar = $ Mustache.to_html(App.Templates.navbar)
        svg = $ Mustache.to_html(App.Templates.svg)
        d3svg = d3.select svg.find("svg.uml")[0]
        @svg = d3svg

        searchBar = navbar.find(".search")
        closeBtn = searchBar.siblings(".close")
        searchBar.keyup (evt) ->
            if evt.which is 27
                closeBtn.click()
                return true

            val = searchBar.val()
            if val?.length > 0
                closeBtn.fadeIn(100)
            else
                closeBtn.fadeOut(100)

            if val?.length > 2
                d3svg.select(".background").classed "searching", true
                for clss in self.classes when not clss.name.contains(val)
                    clss.views.class.element.classed "searching", true
            else
                d3svg.select(".background").classed "searching", false
                for clss in self.classes
                    clss.views.class.element.classed "searching", false

            return true

        closeBtn.click () ->
            searchBar
                .val ""
                .keyup()

            return true


        $(document.body)
            .append navbar
            .append svg

        @classes = []

    addClass: (umlClass) ->
        if umlClass not in @classes
            @classes.push umlClass
        else
            throw new Error("Class with name '#{umlClass.name}' already exists!")
        return @

    getClass: (name) ->
        for clss in @classes when clss.name is name
            return clss
        return null

    draw: () ->
        self = @
        # Create a new directed graph
        g = new dagreD3.graphlib.Graph().setGraph({})

        for clss in @classes
            g.setNode clss.name, {shape: "umlClass", label: "", className: clss.name}

        # TODO: this is a test only!
        g.setEdge(@classes.first.name, @classes.second.name, {})

        svg = @svg
        inner = svg.select(".zoomer")

        # Set up zoom support
        zoom = d3.behavior.zoom().on "zoom", () ->
            inner.attr("transform", "translate(#{d3.event.translate}) scale(#{d3.event.scale})")
            return true
        svg.call(zoom)

        # Create the renderer
        render = new dagreD3.render()

        render.shapes().umlClass = (parent, bbox, node) ->
            # w = bbox.width
            # h = bbox.height

            elem = clss.views.class.element
            bbox = elem.node().getBBox()
            w = bbox.width
            h = bbox.height
            clss = self.getClass(node.className)
            points = [
                # bottom left
                {x: 0, y: 0}
                # bottom right
                {x: w, y: 0}
                # top right
                {x: w, y: -h}
                # top left
                {x: 0, y: -h}
            ]
            elem.attr "transform", "translate(#{-w * 0.5}, #{-h * 0.5})"

            node.intersect = (point) ->
                return dagreD3.intersect.polygon(node, points, point)

            parent.append () ->
                return elem.node()
            return elem

        # Add our custom shape (a house)
        # render.shapes().house = (parent, bbox, node) ->
        #     w = bbox.width
        #     h = bbox.height
        #     points = [
        #         {x:   0,     y:        0}
        #         {x:   w,     y:        0}
        #         {x:   w,     y:       -h}
        #         {x: w * 0.5, y: -h * 1.5}
        #         {x:   0,     y:       -h}
        #     ]
        #     shapeSvg = parent
        #         .insert("polygon", ":first-child")
        #         .attr "points", ("#{d.x}, #{d.y}" for d in points).join(" ")
        #         .attr "transform", "translate(#{-w * 0.5}, #{h * 0.75})"
        #
        #     node.intersect = (point) ->
        #         return dagreD3.intersect.polygon(node, points, point)
        #
        #     return shapeSvg

        # Add our custom arrow (a hollow-point)
        # render.arrows().hollowPoint = (parent, id, edge, type) ->
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

        # Run the renderer. This is what draws the final graph.
        render(inner, g)

        # Center the graph
        initialScale = 0.75
        zoom
            .translate([(svg.attr("width") - g.graph().width * initialScale) / 2, 20])
            .scale(initialScale)
            .event(svg)
        svg.attr('height', g.graph().height * initialScale + 40)
