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
