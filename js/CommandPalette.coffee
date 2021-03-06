class App.CommandPalette

    # CONSTRUCTOR
    constructor: (editor) ->
        @editor = editor
        # NOTE: structure is {path: {name: X, callback: Y}}
        @commands = {}
        @element = App.Templates.get("commandPalette", null, @)
        @lastQuery = ""
        @visible = false
        @currentResultIdx = -1
        @resultSet = []

        $(document.body).append @element

    registerCommand: (path, name, callback) ->
        @commands[path] =
            name: name
            callback: callback
        return @

    unregisterCommand: (path) ->
        delete @commands[path]
        return @

    exec: (path, hide = true) ->
        if hide
            @hide()
        return @commands[path]?.callback?()

    execCurrent: (hide) ->
        return @exec(@resultSet[@currentResultIdx].path, hide)

    find: (input, limit = 7) ->
        @currentResultIdx = -1

        inputLower = input.toLowerCase()
        res = []
        levDist = App.Algorithms.levDist
        # search for path or name
        for path, obj of @commands
            # get distances
            pathDist = levDist(input, path)
            nameDist = levDist(input, obj.name)
            if pathDist < nameDist
                dist = pathDist
                matchBy = "path"
            else if nameDist < pathDist
                dist = nameDist
                matchBy = "name"
            else
                dist = pathDist
                matchBy = "both"

            # direct hit is better than non-direct hit (but save distance for multiple direct hits)
            # direct hit on path
            if path.toLowerCase().indexOf(inputLower) >= 0
                directHit = true
                matchBy = "path"
            # direct hit on name
            else if obj.name.toLowerCase().indexOf(inputLower) >= 0
                directHit = true
                matchBy = "name"
            # fuzzy
            else
                # add to results only if 'good enough'
                # NOTE: factor is threshold for 'not matching'
                if dist >= Math.min(path.length, obj.name.length) * 0.8
                    continue
                directHit = false

            res.push {
                path: path
                name: obj.name
                callback: obj.callback
                dist: dist
                matchBy: matchBy
                directHit: directHit
            }

        res.sort (a, b) ->
            # can't decide by direct hit -> decide by distance
            if a.directHit is b.directHit
                return a.dist - b.dist
            # decide by direct hit
            return if a.directHit then -1 else 1

        @resultSet = res

        return res.slice(0, limit)

    reset: () ->
        @lastQuery = ""
        @visible = false
        @currentResultIdx = -1
        @resultSet = []

        @element.find(".results").empty()
        @element.find(".search").val ""

        return @

    show: () ->
        @editor.navbar.addClass "blurred"
        @editor.svg.classed "blurred", true

        @element.fadeIn 200, () =>
            @visible = true
            @element.find(".search").focus()
            return true
        return @

    hide: () ->
        @editor.navbar.removeClass "blurred"
        @editor.svg.classed "blurred", false

        @element.fadeOut 200, () =>
            @visible = false
            @reset()
            return true
        return @

    toggle: () ->
        if @visible
            return @hide()
        return @show()

    # navigation through result set
    nextResult: () ->
        if @currentResultIdx < @resultSet.length - 1
            if @currentResultIdx >= 0
                @element.find(".result").eq(@currentResultIdx)
                    .removeClass "active"
                    .next ".result"
                    .addClass "active"
            else
                @element.find(".result").eq(0).addClass "active"
            @currentResultIdx++

        return @

    prevResult: () ->
        if @currentResultIdx > 0
            @element.find(".result").eq(@currentResultIdx)
                .removeClass "active"
                .prev ".result"
                .addClass "active"
            @currentResultIdx--

        return @
