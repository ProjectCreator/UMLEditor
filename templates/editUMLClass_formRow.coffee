App.Templates.editUMLClassFormRow =
    template: """<div class="form-group">
                    <div class="row padded">
                        <label for="{{id}}" class="col-xs-2 control-label">{{name}}</label>
                        <div class="col-xs-8">
                            <input type="text" id="{{id}}" class="form-control name" placeholder="Name" value="{{name}}" />
                        </div>
                        <div class="col-xs-1">
                            <button type="button" class="close property hidden" title="Remove property">
                                <span>&times;</span>
                            </button>
                        </div>
                    </div>
                    <div class="row padded">
                        <div class="col-xs-8 col-xs-push-2">
                            <input type="text" class="form-control type" placeholder="Type" value="{{type}}" />
                        </div>
                    </div>
                    <div class="row padded">
                        <div class="col-xs-8 col-xs-push-2">
                            {{#select}}
                                <select class="form-control visibility">
                                    <option value="public" {{public}}>+ public</option>
                                    <option value="private" {{private}}>- private</option>
                                    <option value="protected" {{protected}}># protected</option>
                                    <option value="package" {{package}}>~ package</option>
                                </select>
                            {{/select}}
                        </div>
                    </div>
                    {{#paramValue}}
                        <div class="row padded">
                            <div class="col-xs-4 col-xs-push-2">
                                <input type="text" class="form-control default" placeholder="Default value (optional)" value="{{default}}" data-current-value="{{default}}" />
                            </div>
                            <div class="col-xs-4 col-xs-push-2">
                                <div class="input-group">
                                    <span class="input-group-addon">
                                        <input type="checkbox" class="nullCheckbox" {{checked}} />
                                    </span>
                                    <input type="text" class="form-control" readonly value="NULL" />
                                </div>
                            </div>
                        </div>
                    {{/paramValue}}
                    {{#paramList}}
                        <div class="row padded">
                            <div class="col-xs-8 col-xs-push-2">
                                {{! triple mustache = unescaped HTML}}
                                {{{list}}}
                            </div>
                        </div>
                    {{/paramList}}
                  </div>"""

    bindEvents: (id, property) ->
        self = @
        @find("##{id}").blur () ->
            input = $(@)
            input.parent().siblings("label").text input.val()
            return true
        @find(".close.hidden.property").click () ->
            if confirm "Remove '#{property.name}'?"
                self.remove()
            return true
        @find(".nullCheckbox").change () ->
            box = $(@)
            input = box.closest(".row").find(".default")
            if box.is(":checked")
                input.attr "data-current-value", input.val()
                input.val ""
            else
                input.val input.attr("data-current-value")
            return true
        @find(".add.parameter").click () ->
            $(@).closest(".row").before App.Templates.getHTML("editUMLClassParamRow", {
                name: ""
                type: ""
                default: ""
            })
            return true
        @find(".close.hidden.parameter").click () ->
            $(@).closest(".row").remove()
            return true
        return @
