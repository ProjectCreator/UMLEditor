$(document).ready () ->
    editor = new App.UMLEditor()
    console.log editor

    uml = new App.UMLClass(
        editor
        "my class"
        [
            {
                name: "prop1"
                type: "String"
                visibility: "private"
                default: "hello world"
            }
            {
                name: "prop2"
                type: "String"
            }
        ]
        [
            {
                name: "method1"
                type: "Int"
            }
            {
                name: "method2"
                type: "String"
                visibility: "public"
                parameters: [
                    {
                        name: "a"
                        type: "Integer"
                        default: 12
                    }
                    {
                        name: "b"
                        type: "Boolean"
                    }
                ]
            }
            {
                name: "method3"
                type: "String"
                visibility: "public"
            }
        ]
        {
            # abstract: true
            isInterface: true
        }
    )
    # console.log uml

    uml2 = new App.UMLClass(
        editor
        "my 2nd class"
        [
            {
                name: "prop1"
                type: "String"
                visibility: "private"
                default: "-"
            }
        ]
        [
            {
                name: "method1"
                type: "Int"
            }
            {
                name: "method2"
                type: "String"
                visibility: "public"
                parameters: [
                    {
                        name: "a"
                        type: "Integer"
                        default: 12
                    }
                    {
                        name: "b"
                        type: "Boolean"
                    }
                ]
            }
        ]
        {
            isAbstract: true
            # isInterface: true
        }
    )
    # console.log uml2

    editor.addClass uml
    editor.addClass uml2

    editor.draw()
    return true
