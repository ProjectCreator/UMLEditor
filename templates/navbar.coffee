App.Templates.navbar =
    template: """<nav class="navbar navbar-default">
                    <div class="container-fluid">
                        <div class="navbar-header">
                            <a class="navbar-brand" href="#">ProjectEditor</a>
                        </div>

                        <div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
                            <ul class="nav navbar-nav">
                                <li>
                                    <a href="#">
                                        <span class="label label-primary label-lg projectSettings">
                                            Project settings &nbsp;
                                            <span class="glyphicon glyphicon-wrench"></span>
                                        </span>
                                    </a>
                                </li>
                                <li>
                                    <a href="#">
                                        <span class="label label-primary label-lg newClass">
                                            New class &nbsp;
                                            <span class="glyphicon glyphicon-plus"></span>
                                        </span>
                                    </a>
                                </li>
                                <li>
                                    <a href="#">
                                        <span class="label label-primary label-lg newConnection">
                                            Connect classes &nbsp;
                                            <span class="glyphicon glyphicon-link"></span>
                                        </span>
                                    </a>
                                </li>
                                <li>
                                    <a href="#">
                                        <span class="label label-primary label-lg save">
                                            Save &nbsp;
                                            <span class="glyphicon glyphicon-hdd"></span>
                                        </span>
                                    </a>
                                </li>
                                <li class="dropdown">
                                    <a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button">
                                        View &nbsp;
                                        <span class="glyphicon glyphicon-object-align-horizontal"></span>
                                        {{!<span class="caret"></span>}}
                                    </a>
                                    <ul class="dropdown-menu view">
                                        <li class="all"><a href="#">All</a></li>
                                        <li class="model"><a href="#">Models</a></li>
                                        <li class="view"><a href="#">Views</a></li>
                                        <li class="controller"><a href="#">Controllers</a></li>
                                        <li class="model_controller"><a href="#">Models &amp; Controllers</a></li>
                                        <li class="controller_view"><a href="#">Controllers &amp; Views</a></li>
                                    </ul>
                                </li>
                                <li class="dropdown">
                                    <a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button">
                                        Export &nbsp;
                                        <span class="glyphicon glyphicon-export"></span>
                                        {{!<span class="caret"></span>}}
                                    </a>
                                    <ul class="dropdown-menu export">
                                        <li class="json"><a href="#">JSON</a></li>
                                        <li class="cson"><a href="#">CSON</a></li>
                                        <li class="xml"><a href="#">XML</a></li>
                                    </ul>
                                </li>
                                <li class="dropdown">
                                    <a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button">
                                        Import &nbsp;
                                        <span class="glyphicon glyphicon-import"></span>
                                        {{!<span class="caret"></span>}}
                                    </a>
                                    <ul class="dropdown-menu import">
                                        <li class="json"><a href="#">JSON</a></li>
                                        <li class="cson"><a href="#">CSON</a></li>
                                        <li class="xml"><a href="#">XML</a></li>
                                    </ul>
                                </li>
                            </ul>
                            <ul class="nav navbar-nav navbar-right">
                                <form class="navbar-form" role="search">
                                    <div class="form-group relative">
                                        <input type="text" class="form-control search" placeholder="Search classes">
                                        <button type="button" class="close" title="Clear search">
                                            <span>&times;</span>
                                        </button>
                                    </div>
                                </form>
                            </ul>
                        </div>
                    </div>
                </nav>"""
    bindEvents: (editor) ->
        commandPalette = editor.commandPalette

        # PROJECT SETTINGS
        @find(".projectSettings").click () ->
            editor.showSettingsModal()
            return true

        # CLASS SEARCH
        searchBar = @find(".search")
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
                editor.svg.select(".background").classed "searching", true
                for clss in editor.classes when not clss.name.contains(val)
                    clss.views.class.element.classed "searching", true
            else
                editor.svg.select(".background").classed "searching", false
                for clss in editor.classes
                    clss.views.class.element.classed "searching", false

            return true

        closeBtn.click () ->
            searchBar
                .val ""
                .keyup()
            return true
        commandPalette.registerCommand "search", "Search classes", () ->
            searchBar.focus()
            return true

        # NEW CLASS BUTTON
        createNewClass = () ->
            uml = new App.UMLClass(editor, "_#{Date.now()}", [], [])
            editor.addClass uml
            editor.draw()
            return true
        @find(".label.newClass").click createNewClass
        commandPalette.registerCommand "class.new", "New class", createNewClass

        # CONNECT BUTTON
        createNewConnection = () ->
            editor.showConnectionModal()
            return true
        @find(".label.newConnection").click createNewConnection
        commandPalette.registerCommand "connection.new", "Connect classes", createNewConnection

        # SAVE BUTTON
        @find(".label.save").click () ->
            console.info "TODO: save diagram to server!"
            return true

        # VIEW
        @find(".view li").each (idx, elem) ->
            $elem = $(elem)
            type = $elem.attr("class")
            setView = () ->
                editor
                    .setView type
                    .draw()
                return true
            $elem.click setView
            commandPalette.registerCommand "view.#{type}", "Set view to '#{type}'", setView
            return true

        # EXPORT
        exportJSON = () ->
            editor.showImportExportModal editor.toJSON(), "json"
            return true
        exportList = @find(".export")
        exportList.find(".json").click exportJSON
        commandPalette.registerCommand "export.json", "Export as JSON", exportJSON


        # IMPORT
        importJSON = () ->
            editor.showImportExportModal "", "json"
            return true
        importList = @find(".import")
        importList.find(".json").click importJSON
        commandPalette.registerCommand "import.json", "Import as JSON", importJSON

        return @
    bindKeys: (editor) ->
        self = @
        Mousetrap(document.body).bind "u+s", () ->
            if editor.inKeyboardMode
                self.find(".search").focus()
                return false
            return true
        return @
