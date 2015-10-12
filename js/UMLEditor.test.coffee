$(document).ready () ->
    uml = new App.UMLClass(
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
            abstract: true
            interface: true
        }
    )
    console.log uml
    return true
