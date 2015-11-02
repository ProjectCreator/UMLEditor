class App.UMLClassView extends App.AbstractView

    textWidthDummy = null

    # CONSTRUCTOR
    constructor: (model) ->
        super(model)
        @element = null
        @id = @_getId()
        @settings =
            showVisibility: true
            showTypes: true

    delete: () ->
        @element.remove()
        return null

    _calculateWidth: (name, stringifiedAttributes = "", stringifiedMethods = "", clss = "text") ->
        style =
            position: "absolute"
            visibility: "hidden"

        if not textWidthDummy?
            textWidthDummy = $("<div id='textWidthDummy' />")
            $(document.body).append textWidthDummy

        textWidthDummy.css style
        if clss?
            textWidthDummy.addClass clss

        maxWidth = 0
        width = 0

        # name
        textWidthDummy.text name
        if (width = textWidthDummy.width()) > maxWidth
            maxWidth = width

        # attributes
        for attribute in stringifiedAttributes
            textWidthDummy.text attribute
            if (width = textWidthDummy.width()) > maxWidth
                maxWidth = width

        # methods
        for method in stringifiedMethods
            textWidthDummy.text method
            if (width = textWidthDummy.width()) > maxWidth
                maxWidth = width

        return maxWidth + 10

    # adjust rectangle size after prop update
    _adjustSize: () ->
        # TODO
        return @

    _getId: () ->
        return @model.name._idSafe()._idUnique()

    _createElements: (container) ->
        data = {
            tag: "g"
            class: "uml class"
            id: @id
            children: [
                {
                    tag: "g"
                    class: "name part"
                    children: [
                        {
                            tag: "rect"
                            class: "rect"
                        }
                        {
                            tag: "text"
                            class: "text"
                            y: "1em"
                            children: [
                                {
                                    tag: "tspan"
                                    class: "keywords"
                                }
                                {
                                    tag: "tspan"
                                    "font-weight": "bold"
                                    class: "name"
                                    dy: "1.2em"
                                }
                                {
                                    tag: "tspan"
                                    class: "properties"
                                    dy: "1.2em"
                                }
                            ]
                        }
                        {
                            tag: "text"
                            class: "edit"
                            "font-family": "'Glyphicons Halflings'"
                            "font-size": "13px"
                            html: "\u270f"
                            y: 16
                        }
                    ]
                }
                {
                    tag: "g"
                    class: "attributes part"
                    children: [
                        {
                            tag: "rect"
                            class: "rect"
                        }
                        {
                            tag: "text"
                            class: "text"
                            y: "1em"
                        }
                    ]
                }
                {
                    tag: "g"
                    class: "methods part"
                    children: [
                        {
                            tag: "rect"
                            class: "rect"
                        }
                        {
                            tag: "text"
                            class: "text"
                            y: "1em"
                        }
                    ]
                }
                {
                    tag: "g"
                    class: "overlayWrapper"
                    children: [
                        {
                            tag: "rect"
                            class: "overlay"
                        }
                        {
                            tag: "text"
                            class: "text name"
                            # y: "1em"
                        }
                        {
                            tag: "text"
                            class: "text abstract"
                            x: "2"
                        }
                        {
                            tag: "text"
                            class: "text interface"
                        }
                    ]
                }
            ]
        }

        container = App.AbstractView.appendDataToSVG container, data
        return container.select("##{@id}")

    _bindEvents: () ->
        self = @
        element = @element

        @element.select(".edit").on "click", () ->
            self.model.enterEditMode()
            return true

        overlayWrapper = @element.select(".overlayWrapper")
        overlayWrapper.on "click", () ->
            isActive = self.model.editor.dataCollector.toggleData overlayWrapper.select(".text").text()
            overlayWrapper.classed "selected", isActive
            return true

        return @

    _paramsToString: (parameters) ->
        if not parameters or parameters.length is 0
            return ""

        res = []
        for param in parameters
            if param.type?
                suffix = ": #{param.type}"
            else
                suffix = ""
            res.push "#{param.name}#{suffix}"

        return res.join(", ")

    _attributeToString: (attribute) ->
        visibility = attribute.visibility or "public"
        if attribute.type?
            suffix = ": #{attribute.type}"
        else
            suffix = ""
        return "#{@_visibilityToString(visibility)} #{attribute.name}#{suffix}".trim()

    _methodToString: (method) ->
        if method.name?
            if method.type?
                suffix = ": #{method.type}"
            else
                suffix = ""
            return "#{@_visibilityToString(method.visibility)} #{method.name}(#{@_paramsToString(method.parameters)})#{suffix}".trim()
        if method.last is ")"
            return "+ #{method}"
        return "+ #{method}()"

    _visibilityToString: (visibility) ->
        mapper =
            public: "+"
            protected: "#"
            package: "~"
            private: "-"
        return mapper[visibility.toLowerCase()]


    showOverlay: () ->
        @element.select(".overlayWrapper")
            .style "display", "block"
        return @

    hideOverlay: () ->
        @element.select(".overlayWrapper")
            .style "display", "none"
        return @

    # PUBLIC

    # @Override
    draw: (x, y) ->
        @element = @_createElements(@model.editor.svg)

        # TODO: put the following lines into _adjustSize() and call it here
        stringifiedAttributes = (@_attributeToString(attribute) for attribute in @model.attributes)
        stringifiedMethods = (@_methodToString(method) for method in @model.methods)

        name = @model.name
        w = @_calculateWidth(name, stringifiedAttributes, stringifiedMethods)
        # h = calculateHeight(name, @model.attributes, @model.methods)
        totalHeight = 0

        # TODO: create a javascript style file for each "theme"
        lineHeight = 18
        lineSpacing = 3
        offset =
            left: 4
            right: 0
        w += offset.left + offset.right
        y = 0

        isInterface = @model.isInterface
        isAbstract = @model.isAbstract

        height = lineHeight * 3
        totalHeight += height

        @element.classed @model.type, true

        @element.selectAll(".part .rect")
            .attr "width", w


        @element.select(".name .rect")
            .attr "height", height
        if isInterface
            @element.select(".name .text .keywords")
                .text "<<interface>>"
                .attr "x", (w - @_calculateWidth("<<interface>>")) / 2
        @element.select(".name .text .name")
            .text name
            .attr "x", (w - @_calculateWidth(name)) / 2
        if isAbstract
            @element.select(".name .text .properties")
                .text "{abstract}"
                .attr "x", (w - @_calculateWidth("{abstract}")) / 2

        @element.select(".name .edit")
            .attr "x", w - 19

        y += height
        height = @model.attributes.length * (lineHeight + lineSpacing)
        totalHeight += height

        @element.select(".attributes")
            .attr "transform", "translate(0, #{y})"
        @element.select(".attributes .rect")
            .attr "height", height
        @element.select(".attributes .text")
            # from http://stackoverflow.com/questions/18571540/html5-svg-text-positioning
            .selectAll "tspan"
            .data ({text: attribute} for attribute in stringifiedAttributes)
            .enter()
            .append "tspan"
            .text (d) -> return d.text
            .attr "x", offset.left
            .attr "dy", (d, i) ->
                if i > 0
                    return lineHeight + lineSpacing
                return 0


        y += height
        height = @model.methods.length * (lineHeight + lineSpacing)
        totalHeight += height

        @element.select(".methods")
            .attr "transform", "translate(0, #{y})"
        @element.select(".methods .rect")
            .attr "height", height
        @element.select(".methods .text")
            .selectAll "tspan"
            .data ({text: method} for method in stringifiedMethods)
            .enter()
            .append "tspan"
            .text (d) -> return d.text
            .attr "x", offset.left
            .attr "dy", (d, i) ->
                if i > 0
                    return lineHeight + lineSpacing
                return 0

        @element.select(".overlay")
            .attr "width", w
            .attr "height", totalHeight
        @element.select(".overlayWrapper .text.name")
            .text name
            .attr "x", (w - @_calculateWidth(name)) / 2
            .attr "y", totalHeight / 2
        if isAbstract
            @element.select(".overlayWrapper .text.abstract")
                .text "A"
                .attr "y", totalHeight - 2
        if isInterface
            @element.select(".overlayWrapper .text.interface")
                .text "I"
                .attr "x", w - 6
                .attr "y", totalHeight - 2


        @_bindEvents()
        return @

    # redraw: (properties) ->
    #     if not properties?
    #         translation = d3.transform(@element.attr("transform")).translate
    #         x = translation[0]
    #         y = translation[1]
    #         @element.remove()
    #         @draw()
    #         @element.attr "transform", "translate(#{x}, #{y})"
    #         return @
    #
    #     # redraw only those things that need to be redrawn
    #     # TODO
    #     return @
