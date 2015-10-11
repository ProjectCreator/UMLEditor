stringifyVisibility = (visibility = "public") ->
    mapper =
        public:     "+"
        protected:  "#"
        package:    "~"
        private:    "-"
    return mapper[visibility.toLowerCase()]

stringifyParameters = (parameters) ->
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


stringifyAttribute = (attribute) ->
    visibility = attribute.visibility or "public"
    if attribute.type?
        suffix = ": #{attribute.type}"
    else
        suffix = ""
    return "#{stringifyVisibility(visibility)} #{attribute.name}#{suffix}".trim()

stringifyMethod = (method) ->
    if method.name?
        if method.type?
            suffix = ": #{method.type}"
        else
            suffix = ""
        return "#{stringifyVisibility(method.visibility)} #{method.name}(#{stringifyParameters(method.parameters)})#{suffix}".trim()
    if method[method.length - 1] is ")"
        return "+ #{method}"
    return "+ #{method}()"

calculateHeight = (name, attributes, methods) ->
    return (attributes.length + methods.length) * 14 + 35

textWidthDummy = null
calculateWidth = (name, stringifiedAttributes = "", stringifiedMethods = "", clss = "text") ->
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



class App.UMLClassView extends App.AbstractView

    # CONSTRUCTOR
    constructor: (model, container) ->
        super(model, container)
        @element = null

    # adjust rectangle size after prop update
    adjustSize: () ->
        # TODO
        return @

    _createElements: (container) ->
        data = {
            tag: "g"
            class: "uml class"
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
                            "font-weight": "bold"
                        }
                        {
                            tag: "text"
                            class: "edit hidden"
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
            ]
        }

        container = App.AbstractView.appendDataToSVG container, data
        # container.select("*").attr "transform", "translate(0,0)"
        # TODO: set @element!
        return container

    _bindEvents: (container) ->
        self = @
        drag = d3.behavior.drag()
            .origin (d, i) ->
                elem = d3.select(@)
                translation = d3.transform(elem.attr("transform")).translate
                return {
                    x: elem.attr("x") + translation[0]
                    y: elem.attr("y") + translation[1]
                }
            .on "drag", () ->
                evt = d3.event
                elem = d3.select(@)
                elem.attr "transform", "translate(#{evt.x}, #{evt.y})"
                return true
        container.select(".uml.class")
            .on "mouseenter", () ->
                container.select(".edit").classed "hidden", false
                return true
            .on "mouseleave", () ->
                container.select(".edit").classed "hidden", true
                return true
            .call(drag)

        container.select(".edit").on "click", () ->
            self.model.enterEditMode()
            return true

        return @


    # @Override
    draw: (x, y) ->
        @_createElements(@container)

        # TODO: put the following lines into adjustSize() and call it here
        stringifiedAttributes = (stringifyAttribute(attribute) for attribute in @model.attributes)
        stringifiedMethods = (stringifyMethod(method) for method in @model.methods)

        w = calculateWidth(@model.name, stringifiedAttributes, stringifiedMethods)
        h = calculateHeight(@model.name, @model.attributes, @model.methods)

        # TODO: create a javascript style file for each "theme"
        y = 0
        height = 20
        lineHeight = 18
        lineSpacing = 3
        offset =
            left: 4
            right: 0

        w += offset.left + offset.right


        @container.selectAll(".part .rect")
            .attr "width", w


        @container.select(".name .rect")
            .attr "height", height
        @container.select(".name .text")
            .text @model.name
            .attr "x", (w - calculateWidth(@model.name)) / 2
            # .attr "y", "1em"
            # .attr "font-weight", "bold"
        @container.select(".name .edit")
            .attr "x", w - 19


        y += height
        height = @model.attributes.length * (lineHeight + lineSpacing)

        @container.select(".attributes")
            .attr "transform", "translate(0, #{y})"
        @container.select(".attributes .rect")
            .attr "height", height
        @container.select(".attributes .text")
            # from http://stackoverflow.com/questions/18571540/html5-svg-text-positioning
            # .attr "y", "1em"
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

        @container.select(".methods")
            .attr "transform", "translate(0, #{y})"
        @container.select(".methods .rect")
            .attr "height", height
        @container.select(".methods .text")
            # .attr "y", "1em"
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

        @_bindEvents(@container)

        return @

    #
    redraw: (properties) ->
        if not properties?
            elem = @container.select(".uml.class")
            translation = d3.transform(elem.attr("transform")).translate
            x = translation[0]
            y = translation[1]
            elem.remove()
            @draw()
            @container.select(".uml.class").attr "transform", "translate(#{x}, #{y})"
            return @

        # redraw only those things that need to be redrawn
        # TODO
        return @
