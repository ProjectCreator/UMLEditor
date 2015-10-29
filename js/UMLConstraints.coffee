# HELPER FUNCTIONS
cyclicConnection = (editor, umlClass, connection) ->
    type = connection.type
    # check target class'es outConnections for generalizations/realizations with 'this' as target
    if type is "generalization" or type is "realization"
        for c in editor.getClass(connection.target).outConnections
            type = c.type
            if (type is "generalization" or type is "realization") and c.target is umlClass.name
                # throw new Error("Cyclic generalization or realization detected!")
                return true
    return false

identicalConnectionExists = (editor, umlClass, connection) ->
    id = connection.getId()
    for c in umlClass.outConnections when c.getId() is id
        return true
    return false

modelViewConnection = (editor, umlClass, connection) ->
    target = editor.getClass(connection.target)

    if (umlClass.type is "model" and target.type is "view") or (umlClass.type is "view" and target.type is "model")
        return true
    return false
# END - HELPER FUNCTIONS




# - no same connection twice (same type, source and target)
edge = (editor, umlClass, connection) ->
    if identicalConnectionExists(editor, umlClass, connection)
        return "identical connection"
    if modelViewConnection(editor, umlClass, connection)
        return "connection is between model and view"
    # NOTE: 'this' == App.UMLConstraints
    return @edge[connection.type]?(editor, umlClass, connection) or true

# - only interfaces can be realized
# - no circular realizations
edge.realization = (editor, umlClass, connection) ->
    if cyclicConnection(editor, umlClass, connection)
        return "cycle detected"
    if not umlClass.isInterface
        return "target is no interface"
    return true

# - no circular generalizations
edge.generalization = (editor, umlClass, connection) ->
    if cyclicConnection(editor, umlClass, connection)
        return "cycle detected"
    return true

App.UMLConstraints =
    node: null
    # NODE CONSTRAINTS
    # 1. no name twice -> realized by editor (in addClass)
    # 2. only the classes according to the current view shall be drawn => realized by the editor (classes-getter)
    # EDGE CONSTRAINTS
    edge: edge
