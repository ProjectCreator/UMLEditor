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
                                    <h3 class="modal-title">
                                        Edit "#{@model.name}"
                                        <button type="button" class="btn btn-danger deleteClass right hpadded">Delete class</button>
                                    </h3>
                                </div>
                                <div class="modal-body">
                                    <div class="general">
                                        <h4>General options</h4>
                                        <form class="form-horizontal form-group">
                                            <div class="row">
                                                <div class="col-xs-4 col-xs-push-2">
                                                    <div class="input-group">
                                                        <span class="input-group-addon">
                                                            <input type="checkbox" class="abstractCheckbox"#{if model.isAbstract then " checked" else ""} />
                                                        </span>
                                                        <input type="text" class="form-control" readonly value="is abstract?" />
                                                    </div>
                                                </div>
                                                <div class="col-xs-4 col-xs-push-2">
                                                    <div class="input-group">
                                                        <span class="input-group-addon">
                                                            <input type="checkbox" class="interfaceCheckbox"#{if model.isInterface then " checked" else ""} />
                                                        </span>
                                                        <input type="text" class="form-control" readonly value="is interface?" />
                                                    </div>
                                                </div>
                                            </div>
                                        </form>
                                    </div>
                                    <div class="attributes">
                                        <h4>Attributes</h4>
                                        <form class="form-horizontal"></form>
                                        <div class="row">
                                            <div class="col-xs-10 col-xs-push-2">
                                                <button type="button" class="btn btn-primary add">Add attribute</button>
                                            </div>
                                        </div>
                                    </div>
                                    <hr />
                                    <div class="methods">
                                        <h4>Methods</h4>
                                        <form class="form-horizontal"></form>
                                        <div class="row">
                                            <div class="col-xs-10 col-xs-push-2">
                                                <button type="button" class="btn btn-primary add">Add method</button>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="modal-footer">
                                    <button type="button" class="btn btn-danger cancel" data-dismiss="modal">Cancel</button>
                                    <button type="button" class="btn btn-default reset">Reset</button>
                                    <button type="button" class="btn btn-primary btn-lg save">Save changes</button>
                                </div>
                            </div>
                        </div>
                    </div>"""

        @div.find "button.deleteClass"
            .click () ->
                if confirm "Are you really sure you want to delete the class '#{self.model.name}' and all of its incoming and outgoing dependencies?"
                    self.div.modal("hide")
                    self.div.on "hidden.bs.modal", () ->
                        self.model.delete()
                        return true
                return true

        @div.find "button.cancel"
            .click () ->
                self.draw()
                return true

        @div.find "button.reset"
            .click () ->
                self.draw()
                return true

        @div.find "button.save"
            .click () ->
                data = self._getInput()
                self.model.update data.attributes, data.methods, data.generalOptions
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

    delete: () ->
        @div.remove()
        return null

    _getInput: () ->
        generalOptions = {}
        attributes = []
        methods = []

        # GENERAL OPTIONS
        generalOptions.isAbstract = @div.find(".general .abstractCheckbox").prop("checked")
        generalOptions.isInterface = @div.find(".general .interfaceCheckbox").prop("checked")

        # ATTRIBUTES
        @div.find(".attributes .form-group").each (elem, idx) ->
            formGroup = $(@)

            attributes.push {
                name: formGroup.find(".name").val()
                type: formGroup.find(".type").val()
                visibility: formGroup.find(".visibility").val()
                default: if formGroup.find(".nullCheckbox").prop("checked") then null else formGroup.find(".default").val()
            }
            return true

        # METHODS
        @div.find(".methods .form-group").each () ->
            formGroup = $(@)
            parameters = []

            formGroup.find(".row.parameter").each () ->
                paramRow = $(@)
                parameters.push {
                    name: paramRow.find(".name").val()
                    type: paramRow.find(".type").val()
                    default: if paramRow.find(".nullCheckbox").prop("checked") then null else paramRow.find(".default").val()
                }
                return true

            methods.push {
                name: formGroup.find(".name").val()
                type: formGroup.find(".type").val()
                visibility: formGroup.find(".visibility").val()
                parameters: parameters
            }
            return true

        return {
            generalOptions: generalOptions
            attributes: attributes
            methods: methods
        }

    _createParamRow: (param) ->
        return """<div class="row padded parameter">
            <div class="col-xs-3">
                <input type="text" class="form-control name" placeholder="parameter name" value="#{param.name}" />
            </div>
            <div class="col-xs-3">
                <input type="text" class="form-control type" placeholder="parameter type" value="#{param.type}" />
            </div>
            <div class="col-xs-2">
                <input type="text" class="form-control default" placeholder="default" value="#{param.default or ""}" data-current-value="#{param.default or ""}" />
            </div>
            <div class="col-xs-3">
                <div class="input-group">
                    <span class="input-group-addon">
                        <input type="checkbox" class="nullCheckbox" />
                    </span>
                    <input type="text" class="form-control" readonly value="NULL" />
                </div>
            </div>
            <div class="col-xs-1">
                <button type="button" class="close parameter hidden" title="Remove parameter">
                    <span>&times;</span>
                </button>
            </div>
        </div>"""

    _createFormParamList: (method) ->
        res = """<div class="row">
                        <div class="col-xs-12">
                            <label class="control-label">Parameters</label>
                        </div>
                    </div>"""
        if method.parameters?
            for param in method.parameters
                res += @_createParamRow(param)

        res += """<div class="row">
                <div class="col-xs-12">
                    <button type="button" class="btn btn-primary btn-sm add parameter">Add parameter</button>
                </div>
            </div>"""

        return res

    _createFormRow: (property, isAttribute = true) ->
        self = @
        id = ("id_#{@model.name._idSafe()}_#{property.name._idSafe()}")._idUnique()
        div = $ """<div class="form-group">
                    <div class="row padded">
                        <label for="#{id}" class="col-xs-2 control-label">#{property.name}</label>
                        <div class="col-xs-8">
                            <input type="text" id="#{id}" class="form-control name" placeholder="Name" value="#{property.name}" />
                        </div>
                        <div class="col-xs-1">
                            <button type="button" class="close property hidden" title="Remove property">
                                <span>&times;</span>
                            </button>
                        </div>
                    </div>
                    <div class="row padded">
                        <div class="col-xs-8 col-xs-push-2">
                            <input type="text" class="form-control type" placeholder="Type" value="#{property.type}" />
                        </div>
                    </div>
                    <div class="row padded">
                        <div class="col-xs-8 col-xs-push-2">
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
                                <div class="col-xs-4 col-xs-push-2">
                                    <input type="text" class="form-control default" placeholder="Default value (optional)" value="#{property.default or ""}" data-current-value="#{property.default or ""}" />
                                </div>
                                <div class="col-xs-4 col-xs-push-2">
                                    <div class="input-group">
                                        <span class="input-group-addon">
                                            <input type="checkbox" class="nullCheckbox"#{if property.default? then "" else " checked"} />
                                        </span>
                                        <input type="text" class="form-control" readonly value="NULL" />
                                    </div>
                                </div>
                            </div>"""
                        else
                            """<div class="row padded">
                                <div class="col-xs-8 col-xs-push-2">
                                    #{@_createFormParamList(property)}
                                </div>
                            </div>"""
                    }
                  </div>"""
        div.find "##{id}"
            .blur () ->
                input = $(@)
                input.parent().siblings("label").text input.val()
                return true
        div.find ".close.hidden.property"
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
        div.find(".add.parameter").click () ->
            $(@).closest(".row").before self._createParamRow({
                name: ""
                type: ""
                default: null
            })
            return true
        div.find(".close.hidden.parameter").click () ->
            $(@).closest(".row").remove()
            return true
        return div

    draw: () ->
        @div.find(".general .abstractCheckbox").prop("checked", @model.isAbstract)
        @div.find(".general .interfaceCheckbox").prop("checked", @model.isInterface)

        body = @div.find(".modal-body .attributes form").empty()
        for attribute in @model.attributes
            body.append @_createFormRow(attribute, true)

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
