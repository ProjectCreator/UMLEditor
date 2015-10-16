App.Templates.get = (name, args...) ->
    if (template = App.Templates[name])?
        if template.template?
            $elem = $ Mustache.to_html(template.template)
            template.bindEvents?.apply($elem, args)
        else
            $elem = $ Mustache.to_html(template)

        return $elem
    return null
