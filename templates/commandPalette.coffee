App.Templates.commandPalette =
    template: """<span class="commandPalette label label-xlg label-info">
                    <div class="row">
                        <div class="col-xs-1">
                            <span class="glyphicon glyphicon-console"></span>
                        </div>
                        <div class="col-xs-11">
                            <input class="search form-control" type="text" placeholder="Search commands" />
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-xs-12 results">
                        </div>
                    </div>
                </span>
                <div class="commandPalette overlay" />"""
    bindEvents: (commandPalette) ->
        resultTemplate = """<div class="row result" data-idx="{{index}}">
                                <div class="col-xs-11 col-xs-push-1">
                                    <div class="row">
                                        <div class="col-xs-12 name">
                                            {{name}}
                                        </div>
                                    </div>
                                    <div class="row">
                                        <div class="col-xs-12 path">
                                            {{path}}
                                        </div>
                                    </div>

                                </div>
                            </div>"""

        results = @find ".results"
        @find(".search").keyup () ->
            query = $(@).val()
            if query isnt commandPalette.lastQuery
                commandPalette.lastQuery = query
                resultData = ({path: match.path, name: match.name, index: i} for match, i in commandPalette.find(query))
                if query.length >= 2
                    results
                        .empty()
                        .append (Mustache.to_html(resultTemplate, data) for data in resultData).join("")
                        .find ".result"
                            .click () ->
                                commandPalette.currentResultIdx = parseInt($(@).attr("data-idx"), 10)
                                commandPalette.execCurrent(true)
                                return false
                else
                    results.empty()
            return true

        # OVERLAY
        @filter(".overlay").click () ->
            commandPalette.hide()
            return true

        return @
    bindKeys: (commandPalette) ->
        Mousetrap(@get(0))
            .bind ["up", "down"], (evt, combo) ->
                if combo is "up"
                    commandPalette.prevResult()
                else
                    commandPalette.nextResult()
                # TODO: not working ->  keyup on search bar is called nontheless
                # evt.preventDefault()
                return false
            .bind "enter", (evt, combo) ->
                commandPalette.execCurrent(true)
                return false
            .bind "esc", (evt, combo) ->
                commandPalette.hide()
                return false
        return @
