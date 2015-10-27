App.Templates.importExportModal =
    template: """<div class="modal fade uml edit">
                    <div class="modal-dialog">
                        <div class="modal-content">
                            <div class="modal-header">
                                <button type="button" class="close" data-dismiss="modal">
                                    <span>&times;</span>
                                </button>
                                <h3 class="modal-title">
                                    Import / Export
                                </h3>
                            </div>
                            <div class="modal-body">
                                <form>
                                    <div class="row padded">
                                        <div class="col-xs-4">
                                            <div class="input-group">
                                                <span class="input-group-addon">
                                                    <input type="radio" name="format" value="json" tabindex="50" />
                                                </span>
                                                <input type="text" class="form-control" readonly value="JSON" tabindex="-1" />
                                            </div>
                                        </div>
                                        <div class="col-xs-4">
                                            <div class="input-group">
                                                <span class="input-group-addon">
                                                    <input type="radio" name="format" value="cson" tabindex="51" />
                                                </span>
                                                <input type="text" class="form-control" readonly value="CSON" tabindex="-1" />
                                            </div>
                                        </div>
                                        <div class="col-xs-4">
                                            <div class="input-group">
                                                <span class="input-group-addon">
                                                    <input type="radio" name="format" value="xml" tabindex="52" />
                                                </span>
                                                <input type="text" class="form-control" readonly value="XML" tabindex="-1" />
                                            </div>
                                        </div>
                                    </div>
                                    <textarea class="form-control" style="resize: vertical; height: 375px;"></textarea>
                                    <input type="text" class="invisible" />
                                </form>
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
                                <button type="button" class="btn btn-primary import">Import</button>
                            </div>
                        </div>
                    </div>
                </div>"""
    bindEvents: (editor) ->
        self = @

        radioBtns = @find "[name='format']"
        textarea = @find "textarea"
        # MODAL ACTIONS
        @on "show.bs.modal", () ->
            radioBtns.filter("[value='#{self.data("format")}']").prop("checked", true)
            textarea.val(self.data("value"))
            return true

        @on "shown.bs.modal", () ->
            self.find(".invisible").focus()
            return true

        @on "hidden.bs.modal", () ->
            textarea.val ""
            return true

        # IMPORT
        @find(".btn.import").click () ->
            editor
                .fromJSON textarea.val()
                .draw()
            self.modal("hide")
            return true

        return @
    bindKeys: (editor) ->
        self = @
        elem = @get(0)
        Mousetrap(elem)
            .bind "esc", (evt, combo) ->
                self.modal("hide")
                return false
            .bind "u+w", (evt, combo) ->
                if editor.inKeyboardMode
                    self.modal("hide")
                    return false
                return true

        return @
