class App.UMLEditor

    # CONSTRUCTOR
    constructor: () ->
        self = @

        @graph = new dagreD3.graphlib.Graph({multigraph: true})
        @dataCollector = new App.UMLConnectionDataCollector(@)
        @commandPalette = new App.CommandPalette(@)
        @view = "all"

        @svg = null
        @navbar = App.Templates.get("navbar", null, @)
        @connectionModal = App.Templates.get("chooseConnection", null, @)
        @importExportModal = App.Templates.get("importExportModal", null, @)

        $(document.body)
            .append @navbar
            .append @connectionModal
            .append @chooseStatus

        @models = []
        @views = []
        @controllers = []
        # @classes = []
        Object.defineProperty @, "classes", {
            get: () ->
                return @_mapTypeToList(@view)
            set: () ->
                if DEBUG
                    throw new Error("Cannot set UMLEditor.classes!")
                return @
        }

        Mousetrap(document.body).bind "mod+shift+p", () ->
            self.commandPalette.toggle()
            return false

    _mapTypeToList: (type) ->
        return {
            all: @models.concat(@views).concat(@controllers)
            model: @models
            view: @views
            controller: @controllers
            model_controller: @models.concat(@controllers)
            controller_view: @controllers.concat(@views)
        }[type]

    setView: (type) ->
        if @_mapTypeToList(type)?
            @view = type
        else if DEBUG
            throw new Error("UMLEditor::setView: Invalid type given!")
        return @

    resetSvg: () ->
        svg = App.Templates.get("svg")
        if @svg?
            $(@svg.node()).replaceWith svg
        else
            $(document.body).append svg
        @svg = d3.select(svg.find("svg.uml").get(0))
        return @

    addClass: (umlClass) ->
        if umlClass.name not in (clss.name for clss in @classes)
            @_mapTypeToList(umlClass.type).push umlClass
        else
            throw new Error("Class with name '#{umlClass.name}' already exists!")
        return @

    removeClass: (umlClass) ->
        umlClass.delete()
        @_mapTypeToList(umlClass.type).remove umlClass
        return @

    addConnection: (connection) ->
        sourceClass = @getClass(connection.source)
        sourceClass.addConnection connection
        return @

    removeConnection: () ->
        return @

    getClass: (name) ->
        for clss in @classes when clss.name is name
            return clss
        return null

    showConnectionModal: () ->
        @connectionModal.modal("show")
        return @

    hideConnectionModal: () ->
        @connectionModal.modal("hide")
        return @

    showImportExportModal: (value, format) ->
        @importExportModal.data("value", value)
        @importExportModal.data("format", format)
        @importExportModal.modal("show")
        return @

    hideImportExportModal: () ->
        @importExportModal.modal("hide")
        return @

    showClassNamesOnly: () ->
        for clss in @classes
            clss.views.class.showOverlay()
        return @

    showClassData: () ->
        for clss in @classes
            clss.views.class.hideOverlay()
        return @

    draw: () ->
        umlClasses = @classes
        @resetSvg()
        # Create a new directed graph
        @graph = new dagreD3.graphlib.Graph({multigraph: true}).setGraph({})

        if umlClasses.length is 0
            return @

        self = @

        for clss in umlClasses
            # TODO: make draw return a ready template instead of redrawing and using that redrawn element
            clss.views.class.element?.remove()
            clss.views.class.draw()
            @graph.setNode clss.name, {shape: "umlClass", label: "", className: clss.name}

        for clss in umlClasses
            for connection in clss.outConnections
                source = connection.source
                target = connection.target
                type = connection.type
                # draw only those edges that go to classes that are drawn!
                if @getClass(target)?
                    @graph.setEdge(source, target, {arrowhead: type}, "#{type}_from_#{source}_to_#{target}")

        svg = @svg
        inner = svg.select(".zoomer")

        # Set up zoom support
        zoom = d3.behavior.zoom().on "zoom", () ->
            inner.attr("transform", "translate(#{d3.event.translate}) scale(#{d3.event.scale})")
            return true
        svg.call(zoom)

        # bottom to top (mainly for generalizations)
        @graph.graph().rankdir = "BT"

        # Create the renderer
        render = new dagreD3.render()

        render.shapes().umlClass = (parent, bbox, node) ->
            clss = self.getClass(node.className)
            elem = clss.views.class.element
            bbox = elem.node().getBBox()
            w = bbox.width
            h = bbox.height
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

        # REGISTER ARROW HEADS
        for connectionType in Object.keys(App.Connections).without("UMLConnection")
            render.arrows()[connectionType] = App.Connections[connectionType].getArrowhead()

        # Run the renderer. This is what draws the final graph.
        render(inner, @graph)

        bbox = svg.node().getBBox()
        width = bbox.width
        height = bbox.height

        # Center the graph
        initialScale = 1
        zoom
            .translate([(width - @graph.graph().width * initialScale) / 2, 20])
            .scale(initialScale)
            .event(svg)

        return @

    serialize: () ->
        return (clss.serialize() for clss in @classes)

    deserialize: (data) ->
        @classes = (App.UMLClass.fromJSON(@, classData) for classData in data)
        return @

    toJSON: () ->
        return JSON.stringify @serialize()

    fromJSON: (json) ->
        @deserialize JSON.parse(json)
        return @
