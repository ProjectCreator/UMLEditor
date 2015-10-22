class App.UMLClassEditView extends App.AbstractView

    # CONSTRUCTOR
    constructor: (model) ->
        super(model)

        self = @

        @div = App.Templates.get(
            "editUMLClass"
            {
                className: @model.name
                # title: App.Templates.get("editUMLClassTitle", {className: @model.name})
                isAbstract: @model.isAbstract
                isInterface: @model.isInterface
            }
            @
        )

        @draw()

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
        return App.Templates.getHTML("editUMLClassParamRow", {
            name: param.name
            type: param.type
            default: param.default or ""
        })

    _createParamList: (method) ->
        return App.Templates.getHTML(
            "editUMLClassParamList"
            # method.parameters or []
            parameters: (App.Templates.getHTML("editUMLClassParamRow", param) for param in (method.parameters or []))
        )

    _createFormRow: (property, isAttribute = true) ->
        self = @
        id = ("id_#{@model.name._idSafe()}_#{property.name._idSafe()}")._idUnique()

        if isAttribute
            paramValue =
                default: property.default or ""
                checked: if property.default? then "" else "checked"
        else
            paramList =
                list: @_createParamList(property)

        return App.Templates.get(
            "editUMLClassFormRow"
            {
                id: id
                name: property.name
                type: property.type
                default: property.default or ""
                isAttribute: isAttribute
                select:
                    public: if property.visibility is "public" then "selected" else ""
                    private: if property.visibility is "private" then "selected" else ""
                    protected: if property.visibility is "protected" then "selected" else ""
                    package: if property.visibility is "package" then "selected" else ""
                paramValue: paramValue
                paramList: paramList
            }
            id
            property
        )

    draw: () ->
        # TITLE
        @div.find(".modal-title .className").text @model.name

        # BODY
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
