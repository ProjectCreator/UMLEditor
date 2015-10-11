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
                    name: "a"
                    type: "Integer"
                ]
            }
            {
                name: "method3"
                type: "String"
                visibility: "public"
            }
        ]
    )
    console.log uml
    return true
