App.Templates.svgUMLClass =
    template: """<g class="uml class" id="{{id}}" transform="translate(0, 0)">
                    {{#name}}
                        <g class="name part">
                            <rect class="rect" width="{{width}}" height="{{height}}"></rect>
                            <text class="text" y="1em">
                                <tspan class="keywords" x="86">{{keywords}}</tspan>
                                <tspan font-weight="bold" class="name" dy="1.2em" x="102">{{className}}</tspan>
                                <tspan class="properties" dy="1.2em">{{properties}}</tspan>
                            </text>
                            <text class="edit hidden" font-family="'Glyphicons Halflings'" font-size="13px" y="16" x="249">\u270f</text>
                        </g>
                    {{/name}}
                    {{#attributes}}
                        <g class="attributes part" transform="translate(0, 0)">
                            <rect class="rect" width="{{width}}" height="{{height}}"></rect>
                            <text class="text" y="1em">
                                {{!<tspan x="4" dy="0">- prop1: String</tspan>
                                <tspan x="4" dy="21">+ prop2: String</tspan>}}
                                {{{attributes}}}
                            </text>
                        </g>
                    {{/attributes}}
                    {{#methods}}
                        <g class="methods part" transform="translate(0, 96)">
                            <rect class="rect" width="{{width}}" height="{{height}}"></rect>
                            <text class="text" y="1em">
                                {{!<tspan x="4" dy="0">+ method1(): Int</tspan>
                                <tspan x="4" dy="21">+ method2(a: Integer, b: Boolean): String</tspan>
                                <tspan x="4" dy="21">+ method3(): String</tspan>}}
                                {{{methods}}}
                            </text>
                        </g>
                    {{/methods}}
                    {{#overlay}}
                        <g class="overlayWrapper">
                            <rect class="overlay" width="{{width}}" height="{{height}}"></rect>
                            <text class="text" y="79.5" x="102">{{className}}</text>
                        </g>
                    {{/overlay}}
                </g>"""
    bindEvents: (view) ->
        self = @

        # TODO: make this css
        # @on "mouseenter", () ->
        #         self.select(".edit").classed "hidden", false
        #         return true
        #     .on "mouseleave", () ->
        #         self.select(".edit").classed "hidden", true
        #         return true

        @select(".edit").on "click", () ->
            view.model.enterEditMode()
            return true

        overlayWrapper = @select(".overlayWrapper")
        overlayWrapper.on "click", () ->
            isActive = view.model.editor.dataCollector.toggleData overlayWrapper.select(".text").text()
            overlayWrapper.classed "selected", isActive
            return true

        return @
