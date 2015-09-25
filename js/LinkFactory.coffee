uml = joint.shapes.uml

# new uml.Generalization({ source: { id: classes.man.id }, target: { id: classes.person.id }}),
#    new uml.Generalization({ source: { id: classes.woman.id }, target: { id: classes.person.id }}),
#    new uml.Implementation({ source: { id: classes.person.id }, target: { id: classes.mammal.id }}),
#    new uml.Aggregation({ source: { id: classes.person.id }, target: { id: classes.address.id }}),
#    new uml.Composition({ source: { id: classes.person.id }, target: { id: classes.bloodgroup.id }})

App.LinkFactory =
    new: (type, source, target) ->
        if source.mvc.type is "controller" or target.mvc.type is "controller"
            return new uml[type]({
                source:
                    id: source.id
                target:
                    id: target.id
            })
        throw new Error("LinkFactory.new: Cannot connect a #{source.mvc.type} to a #{target.mvc.type}")
