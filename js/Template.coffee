App.Templates.get = (name, data, args...) ->
    if (template = App.Templates[name])?
        if template.template?
            $elem = $ Mustache.to_html(template.template, data)
            template.bindEvents?.apply($elem, args)
        else
            $elem = $ Mustache.to_html(template, data)

        return $elem
    return null

# get plain html string (=> no event binding)
App.Templates.getHTML = (name, data, args...) ->
    if (template = App.Templates[name])?
        if template.template?
            elem = Mustache.to_html(template.template, data)
        else
            elem = Mustache.to_html(template, data)

        return elem
    return null

# get d3 object
# NOTE: this only works for templates that 1 element on top level only!
# d3Container = null
App.Templates.getD3 = (name, data, args...) ->
    if (template = App.Templates[name])?
        # if not d3Container?
        #     d3Container = $ """<svg class="hidden" />"""
        #     $(document.body).append d3Container

        # id = "__unique_id"._idUnique()
        if template.template?
            elem = $ Mustache.to_html(template.template, data)
            elem = d3.select(elem.get(0))
            template.bindEvents?.apply(elem, args)
        else
            elem = Mustache.to_html(template, data)
            elem = d3.select(elem.get(0))

        return elem
    return null
