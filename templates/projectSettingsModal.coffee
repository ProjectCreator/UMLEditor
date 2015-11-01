App.Templates.projectSettingsModal =
    template: """<div class="modal fade projectSettings">
                    <div class="modal-dialog">
                        <div class="modal-content">
                            <div class="modal-header">
                                <button type="button" class="close" data-dismiss="modal">
                                    <span>&times;</span>
                                </button>
                                <h3 class="modal-title">
                                    Project settings
                                </h3>
                            </div>
                            <div class="modal-body">
                                <div class="row padded">
                                    <div class="col-xs-10 col-xs-push-1 alert alert-danger"></div>
                                </div>
                                <form class="form-horizontal form-group">
                                    <div class="row padded">
                                        <div class="col-xs-5 col-xs-push-1">
                                            Name:
                                        </div>
                                        <div class="col-xs-5 col-xs-push-1">
                                            <input type="text" class="form-control name" value="{{name}}" placeholder="Project name" />
                                        </div>
                                    </div>
                                    <div class="row padded">
                                        <div class="col-xs-5 col-xs-push-1">
                                            Target framwork:
                                        </div>
                                        <div class="col-xs-5 col-xs-push-1">
                                            <select class="form-control targetFramework">
                                                {{#frameworks}}
                                                    <option value="{{value}}" {{selected}}>{{name}}</option>
                                                {{/frameworks}}
                                            </select>
                                        </div>
                                    </div>
                                    <div class="row padded">
                                        <hr />
                                        <h4 class="col-xs-10 col-xs-push-1">Database access configuration</h4>
                                        <div class="col-xs-10 col-xs-push-1 databaseConfig">
                                            {{#databaseConfig}}
                                                <div class="row padded">
                                                    <div class="col-xs-6">
                                                        Domain:
                                                    </div>
                                                    <div class="col-xs-6">
                                                        <input class="domain form-control" type="text" value="{{domain}}" placeholder="localhost" />
                                                    </div>
                                                </div>
                                                <div class="row padded">
                                                    <div class="col-xs-6">
                                                        Name:
                                                    </div>
                                                    <div class="col-xs-6">
                                                        <input class="db form-control" type="text" value="{{name}}" placeholder="db" />
                                                    </div>
                                                </div>
                                                <div class="row padded">
                                                    <div class="col-xs-6">
                                                        User:
                                                    </div>
                                                    <div class="col-xs-6">
                                                        <input class="root form-control" type="text" value="{{user}}" placeholder="root" />
                                                    </div>
                                                </div>
                                                <div class="row padded">
                                                    <div class="col-xs-6">
                                                        Password:
                                                    </div>
                                                    <div class="col-xs-6">
                                                        <input class="password form-control" type="password" value="{{password}}" placeholder="adf" />
                                                    </div>
                                                </div>
                                            {{/databaseConfig}}
                                        </div>
                                    </div>
                                    <div class="row padded">
                                        <hr />
                                        <h4 class="col-xs-10 col-xs-push-1">Table names</h4>
                                        <div class="col-xs-10 col-xs-push-1 modelTableMapping"></div>
                                    </div>
                                </form>
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
                                <button type="button" class="btn btn-primary save">Save</button>
                            </div>
                        </div>
                    </div>
                </div>"""
    bindEvents: (editor) ->
        self = @

        errorOutput = @find(".alert-danger")

        nameInput = @find(".name")
        framworkInput = @find(".targetFramework")

        domainInput = @find(".databaseConfig .domain")
        dbNameInput = @find(".databaseConfig .name")
        userInput = @find(".databaseConfig .user")
        passwordInput = @find(".databaseConfig .password")

        modelTableMapping = @find(".modelTableMapping")

        settings = editor.projectSettings

        template = """{{#modelTableMapping}}
            <div class="row padded" data-model-name="{{model}}">
                <div class="col-xs-6">
                    {{model}}
                </div>
                <div class="col-xs-6">
                    <input class="form-control" type="text" value="{{table}}" />
                </div>
            </div>
        {{/modelTableMapping}}"""

        @on "show.bs.modal", () ->
            errorOutput.fadeOut(0)
            self.find(".has-error").removeClass("has-error")

            mapping = ({model: key, table: val} for key, val of settings.modelTableMapping)
            modelTableMapping
                .empty()
                .append Mustache.to_html(template, {modelTableMapping: mapping})
            return true

        @on "hide.bs.modal", () ->
            return self.find(".has-error").length is 0

        # remove has-error class when typing
        @find("input").keyup () ->
            elem = $(@)
            row = elem.closest(".row")
            if row.hasClass("has-error") and elem.val().length > 0
                row.removeClass "has-error"
            return true

        @find(".save").click () ->
            valid = true

            name = nameInput.val()
            if name? and name.length > 0
                settings.name = name
            else
                valid = false
                errorOutput
                    .html "No project name entered!"
                    .slideDown()
                nameInput.closest(".row").addClass("has-error")

            settings.targetFramework = framworkInput.val()

            settings.databaseConfig.domain = domainInput.val() or ""
            settings.databaseConfig.name = dbNameInput.val() or ""
            settings.databaseConfig.user = userInput.val() or ""
            settings.databaseConfig.password = passwordInput.val() or ""


            self.find("[data-model-name]").each (idx, elem) ->
                $elem = $(elem)
                model = $elem.attr("data-model-name")
                table = $elem.find("input").val()
                if table? and table.length > 0
                    settings.modelTableMapping[model] = $elem.find("input").val()
                else
                    valid = false
                    errorOutput
                        .html "No table name for class '#{model}'!"
                        .slideDown()
                    $elem.addClass("has-error")
                    return false
                return true

            return valid


        return @
