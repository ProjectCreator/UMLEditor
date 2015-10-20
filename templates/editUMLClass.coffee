App.Templates.editUMLClass =
    template: """<div class="modal fade uml edit">
                    <div class="modal-dialog">
                        <div class="modal-content">
                            <div class="modal-header">
                                <button type="button" class="close" data-dismiss="modal">
                                    <span>&times;</span>
                                </button>
                                <h3 class="modal-title">
                                    <span>Edit "<span class="className">{{className}}</span>"</span>
                                    <button type="button" class="btn btn-danger deleteClass right hpadded">Delete class</button>
                                    <button type="button" class="btn btn-default renameClass right">Rename class</button>
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
                                                        <input type="checkbox" class="abstractCheckbox"{{isAbstract}} />
                                                    </span>
                                                    <input type="text" class="form-control" readonly value="is abstract?" />
                                                </div>
                                            </div>
                                            <div class="col-xs-4 col-xs-push-2">
                                                <div class="input-group">
                                                    <span class="input-group-addon">
                                                        <input type="checkbox" class="interfaceCheckbox"{{isInterface}} />
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
    bindEvents: (view) ->
        self = @
        @find("button.deleteClass").click () ->
            if confirm "Are you really sure you want to delete the class '#{view.model.name}' and all of its incoming and outgoing dependencies?"
                view.hide()
                self.on "hidden.bs.modal", () ->
                    view.model.editor.removeClass view.model
                    return true
            return true

        @find("button.renameClass").click () ->
            if (name = prompt("Enter the new name of the class!"))?
                view.model.name = name
                view.draw()
            return true

        @find "button.cancel"
            .click () ->
                view.draw()
                return true

        @find "button.reset"
            .click () ->
                view.draw()
                return true

        @find "button.save"
            .click () ->
                data = view._getInput()
                view.model.update data.attributes, data.methods, data.generalOptions
                view.hide()
                return true

        @find ".attributes .add"
            .click () ->
                self.find ".attributes form"
                    .append view._createFormRow({
                        name: "new attribute"
                        type: "new type"
                        visibility: "public"
                    }, true)
                return true
        @find ".methods .add"
            .click () ->
                self.find ".methods form"
                    .append view._createFormRow({
                        name: "new method"
                        type: "new type"
                        visibility: "public"
                    }, false)
                return true
        return @
