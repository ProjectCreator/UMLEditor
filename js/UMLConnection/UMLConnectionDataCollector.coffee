class App.UMLConnectionDataCollector

    # CONSTRUCTOR
    constructor: (editor) ->
        @editor = editor
        @reset()
        @div = App.Templates.get("selectClassesForConnection", editor)
        $(document.body).append @div

    createConnection: () ->
        console.log "creating connection....", @data
        clss = App.Connections[@data.type._capitalize()]
        return new clss(@data.source, @data.target)

    reset: () ->
        @data =
            source: null
            target: null
            type: null
        return @

    setType: (type) ->
        @data.type = type
        @_update()
        return @

    # NOTE: returns if the given className was added
    toggleData: (className) ->
        if @data.source is className
            @data.source = null
            res = false
        else if @data.target is className
            @data.target = null
            res = false

        else if not @data.source?
            @data.source = className
            res = true
        else if not @data.target?
            @data.target = className
            res = true
        else
            throw new Error("Invalid data given or existing data is invalid!")

        @_update()
        return res

    _update: () ->
        @div.find(".type").text(@data.type or "?")
        @div.find(".source").text(@data.source or "?")
        @div.find(".target").text(@data.target or "?")
        return @

    show: () ->
        @div.fadeIn(100)
        return @

    hide: () ->
        @div.fadeOut(100)
        return @
