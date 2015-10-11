class App.UMLClassEditView extends App.AbstractView

    # CONSTRUCTOR
    constructor: (model) ->
        super(model)

        self = @
        @div = $ """<div class="modal fade uml edit">
                        <div class="modal-dialog">
                            <div class="modal-content">
                                <div class="modal-header">
                                    <button type="button" class="close" data-dismiss="modal">
                                        <span>&times;</span>
                                    </button>
                                    <h3 class="modal-title">Edit "#{@model.name}"</h3>
                                </div>
                                <div class="modal-body">
                                    <div class="attributes">
                                        <h4>Attributes</h4>
                                        <form class="form-horizontal"></form>
                                        <div class="row">
                                            <div class="col-xs-9 col-xs-push-3">
                                                <button type="button" class="btn btn-primary add">Add attribute</button>
                                            </div>
                                        </div>
                                    </div>
                                    <hr />
                                    <div class="methods">
                                        <h4>Methods</h4>
                                        <form class="form-horizontal"></form>
                                        <div class="row">
                                            <div class="col-xs-9 col-xs-push-3">
                                                <button type="button" class="btn btn-primary add">Add method</button>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="modal-footer">
                                    <button type="button" class="btn btn-danger cancel" data-dismiss="modal">Cancel</button>
                                    <button type="button" class="btn btn-default reset">Reset</button>
                                    <button type="button" class="btn btn-primary save">Save changes</button>
                                </div>
                            </div>
                        </div>
                    </div>"""

        @div.find "button.reset"
            .click () ->

        @div.find "button.save"
            .click () ->
                data = self._getInput()
                self.model.update data.attributes, data.methods
                self.hide()
                return true

        @div.find ".attributes .add"
            .click () ->
                self.div.find ".attributes form"
                    .append self._createFormRow({
                        name: "new attribute"
                        type: "new type"
                        visibility: "public"
                    }, true)
                return true
        @div.find ".methods .add"
            .click () ->
                self.div.find ".methods form"
                    .append self._createFormRow({
                        name: "new method"
                        type: "new type"
                        visibility: "public"
                    }, false)
                return true
        $(document.body).append @div
        @hide()

    _getInput: () ->
        attributes = []
        methods = []

        @div.find(".attributes .form-group").each (elem, idx) ->
            formGroup = $(@)

            attributes.push {
                name: formGroup.find(".name").val()
                type: formGroup.find(".type").val()
                visibility: formGroup.find(".visibility").val()
                default: if formGroup.find(".nullCheckbox").prop("checked") then null else formGroup.find(".default").val()
            }
            return true

        @div.find(".methods .form-group").each (elem, idx) ->
            formGroup = $(@)

            methods.push {
                name: formGroup.find(".name").val()
                type: formGroup.find(".type").val()
                visibility: formGroup.find(".visibility").val()
            }
            return true

        return {
            attributes: attributes
            methods: methods
        }


    _createFormRow: (property, isAttribute = true) ->
        id = "id_#{@model.name._idSafe()}_#{property.name._idSafe()}"
        div = $ """<div class="form-group">
                    <div class="row padded">
                        <label for="#{id}" class="col-xs-3 control-label">#{property.name}</label>
                        <div class="col-xs-7">
                            <input type="text" id="#{id}" class="form-control name" placeholder="Name" value="#{property.name}" />
                        </div>
                        <div class="col-xs-1">
                            <button type="button" class="close hidden" title="Remove property">
                                <span>&times;</span>
                            </button>
                        </div>
                    </div>
                    <div class="row padded">
                        <div class="col-xs-7 col-xs-push-3">
                            <input type="text" class="form-control type" placeholder="Type" value="#{property.type}" />
                        </div>
                    </div>
                    <div class="row padded">
                        <div class="col-xs-7 col-xs-push-3">
                            <select class="form-control visibility">
                                <option value="public"#{if property.visibility is "public" then " selected" else ""}>+ public</option>
                                <option value="private"#{if property.visibility is "private" then " selected" else ""}>- private</option>
                                <option value="protected"#{if property.visibility is "protected" then " selected" else ""}># protected</option>
                                <option value="package"#{if property.visibility is "package" then " selected" else ""}>~ package</option>
                            </select>
                        </div>
                    </div>
                    #{
                        if isAttribute
                            """<div class="row padded">
                                <div class="col-xs-4 col-xs-push-3">
                                    <input type="text" class="form-control default" placeholder="Default value (optional)" value="#{property.default or ""}" data-original-value="#{property.default or ""}" data-current-value="#{property.default or ""}" />
                                </div>
                                <div class="col-xs-3 col-xs-push-3">
                                    <div class="input-group">
                                        <span class="input-group-addon">
                                            <input type="checkbox" class="nullCheckbox"#{if property.default? then "" else " checked"} />
                                        </span>
                                        <input type="text" class="form-control" readonly value="NULL" />
                                    </div>
                                </div>
                            </div>"""
                        else
                            ""
                    }
                  </div>"""
        div.find "##{id}"
            .blur () ->
                input = $(@)
                input.parent().siblings("label").text input.val()
                return true
        div.find ".close.hidden"
            .click () ->
                if confirm "Remove '#{property.name}'?"
                    div.remove()
                return true
        div.find ".nullCheckbox"
            .change () ->
                box = $(@)
                input = box.closest(".row").find(".default")
                if box.is(":checked")
                    input.attr "data-current-value", input.val()
                    input.val ""
                else
                    input.val input.attr("data-current-value")
                return true
        return div

    draw: () ->
        body = @div.find(".modal-body .attributes form").empty()
        for attribute in @model.attributes
            body.append @_createFormRow(attribute)

        body = @div.find(".modal-body .methods form").empty()
        for method in @model.methods
            body.append @_createFormRow(method, false)
        return @

    redraw: () ->
        return @draw()

    show: () ->
        @div.modal("show")
        return @

    hide: () ->
        @div.modal("hide")
        return @
