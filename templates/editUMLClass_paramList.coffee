App.Templates.editUMLClassParamList =
    template: """<div class="row">
                    <div class="col-xs-12">
                        <label class="control-label">Parameters</label>
                    </div>
                </div>
                {{#parameters}}
                    {{{.}}}
                {{/parameters}}
                <div class="row">
                    <div class="col-xs-12">
                        <button type="button" class="btn btn-primary btn-sm add parameter">Add parameter</button>
                    </div>
                </div>"""
