App.Templates.chooseConnection =
    template: """<div class="modal fade uml chooseConnection">
                    <div class="modal-dialog">
                        <div class="modal-content">
                            <div class="modal-header">
                                <button type="button" class="close" data-dismiss="modal">
                                    <span>&times;</span>
                                </button>
                                <h3 class="modal-title">
                                    Choose a connection / dependency type
                                </h3>
                            </div>
                            <div class="modal-body">
                                <div class="general">
                                    <form class="form-horizontal form-group">
                                        <h4>Class level relationships</h4>
                                        <div class="row padded">
                                            <div class="col-xs-8 col-xs-push-2">
                                                <div class="input-group clickable">
                                                    <span class="input-group-addon">
                                                        <input type="radio" name="connectionType" value="generalization" />
                                                    </span>
                                                    <input type="text" class="form-control no-focus" readonly value="Generalization ('inherit from X')" />
                                                </div>
                                            </div>
                                        </div>
                                        <div class="row padded">
                                            <div class="col-xs-8 col-xs-push-2">
                                                <div class="input-group clickable">
                                                    <span class="input-group-addon">
                                                        <input type="radio" name="connectionType" value="realization" />
                                                    </span>
                                                    <input type="text" class="form-control no-focus" readonly value="Realization ('implement X')" />
                                                </div>
                                            </div>
                                        </div>

                                        <h4>Instance level relationships</h4>
                                        <div class="row padded">
                                            <div class="col-xs-8 col-xs-push-2">
                                                <div class="input-group clickable">
                                                    <span class="input-group-addon">
                                                        <input type="radio" name="connectionType" value="association" />
                                                    </span>
                                                    <input type="text" class="form-control no-focus" readonly value="Association ('has relationship to X')" />
                                                </div>
                                            </div>
                                        </div>
                                        <div class="row padded">
                                            <div class="col-xs-8 col-xs-push-2">
                                                <div class="input-group clickable">
                                                    <span class="input-group-addon">
                                                        <input type="radio" name="connectionType" value="aggregation" />
                                                    </span>
                                                    <input type="text" class="form-control no-focus" readonly value="Aggregation ('is part of X')" />
                                                </div>
                                            </div>
                                        </div>
                                        <div class="row padded">
                                            <div class="col-xs-8 col-xs-push-2">
                                                <div class="input-group clickable">
                                                    <span class="input-group-addon">
                                                        <input type="radio" name="connectionType" value="composition" />
                                                    </span>
                                                    <input type="text" class="form-control no-focus" readonly value="Composition ('is necessary part of X')" />
                                                </div>
                                            </div>
                                        </div>
                                    </form>
                                </div>
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-default cancel" data-dismiss="modal">Cancel</button>
                                <button type="button" class="btn btn-primary save">Next (select classes)</button>
                            </div>
                        </div>
                    </div>
                </div>"""
    bindEvents: (editor) ->
        saveBtn = @find(".save")

        inputGroups = @find(".input-group")
        inputGroups.click () ->
            $(@).find("input[type='radio']").prop("checked", true)
            inputGroups.filter(".has-error").removeClass "has-error"
            if saveBtn.hasClass "btn-danger"
                saveBtn.removeClass "btn-danger"
            return true

        inputs = @find("[name='connectionType']")
        saveBtn.click () ->
            input = inputs.filter(":checked")
            if input.length > 0
                editor.hideConnectionModal()
                    # .showChooseStatus()
                    .showClassNamesOnly()
                    .dataCollector
                        .reset()
                        .setType(input.val())
                        .show()
            else
                inputGroups.eq(0).addClass "has-error"
                saveBtn.addClass "btn-danger"
            return true
        return @
