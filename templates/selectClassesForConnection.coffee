App.Templates.selectClassesForConnection =
    template: """<div class="selectClassesForConnection">
                    <div class="alert alert-danger alert-sm">
                        <div class="row padded">
                            <div class="centered bigger">
                                <strong>STATUS</strong>
                            </div>
                        </div>
                        <div class="row padded">
                            <div class="col-xs-4">
                                <strong>type:</strong>
                                <span class="type"></span>
                            </div>
                            <div class="col-xs-4">
                                <strong>source:</strong>
                                <span class="source"></span>
                            </div>
                            <div class="col-xs-4">
                                <strong>target:</strong>
                                <span class="target"></span>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-xs-4 col-xs-push-4 centered">
                                <button class="btn btn-primary save" style="margin-right: 15px;">Save</button>
                                <button class="btn btn-danger cancel">Cancel</button>
                            </div>
                        </div>
                    </div>
                </div>"""
    bindEvents: (editor) ->
        saveBtn = @find(".save")
        cancelBtn = @find(".cancel")

        saveBtn.click () ->
            newConnection = editor.dataCollector
                .hide()
                .createConnection()
            editor
                .addConnection newConnection
                .draw()
            return true

        cancelBtn.click () ->
            editor
                .showClassData()
                .dataCollector
                    .hide()
            return true
        return @
