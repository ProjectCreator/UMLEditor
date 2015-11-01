App.Templates.errorModal =
    template: """<div class="modal fade error">
                    <div class="modal-dialog">
                        <div class="modal-content">
                            <div class="modal-header">
                                <button type="button" class="close" data-dismiss="modal">
                                    <span>&times;</span>
                                </button>
                                <h3 class="modal-title">
                                    Error
                                </h3>
                            </div>
                            <div class="modal-body"></div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-danger" data-dismiss="modal">Close</button>
                            </div>
                        </div>
                    </div>
                </div>"""
    bindEvents: () ->
        content = @find(".modal-body")
        @on "show.bs.modal", () =>
            content.html @data("error")
            return true
        return @
