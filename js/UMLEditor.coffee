class App.UMLEditor

    # CONSTRUCTOR
    constructor: () ->
        self = @
        navbar = $ Mustache.to_html(App.Templates.navbar)
        svg = $ Mustache.to_html(App.Templates.svg)
        d3svg = d3.select svg[0]

        searchBar = navbar.find(".search")
        closeBtn = searchBar.siblings(".close")
        searchBar.keyup () ->
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

        closeBtn.click () ->
            searchBar
                .val ""
                .keyup()

            return @


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
