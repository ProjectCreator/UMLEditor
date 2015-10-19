App.Templates.editUMLClassParamRow =
    template: """<div class="row padded parameter">
                    <div class="col-xs-3">
                        <input type="text" class="form-control name" placeholder="parameter name" value="{{name}}" />
                    </div>
                    <div class="col-xs-3">
                        <input type="text" class="form-control type" placeholder="parameter type" value="{{type}}" />
                    </div>
                    <div class="col-xs-2">
                        <input type="text" class="form-control default" placeholder="default" value="{{default}}" data-current-value="{{default}}" />
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
