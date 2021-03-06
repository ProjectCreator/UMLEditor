// Generated by CoffeeScript 1.10.0
(function() {
  $(document).ready(function() {
    var editor, uml, uml2, uml3;
    editor = new App.ProjectEditor();
    console.log(editor);
    uml = new App.Model(editor, "my wife - my model", [
      {
        name: "prop1",
        type: "String",
        visibility: "private",
        "default": "hello world"
      }, {
        name: "prop2",
        type: "String"
      }
    ], [
      {
        name: "method1",
        type: "Int"
      }, {
        name: "method2",
        type: "String",
        visibility: "public",
        parameters: [
          {
            name: "a",
            type: "Integer",
            "default": 12
          }, {
            name: "b",
            type: "Boolean"
          }
        ]
      }, {
        name: "method3",
        type: "String",
        visibility: "public"
      }
    ], {
      isInterface: true
    });
    uml2 = new App.Controller(editor, "my controller", [
      {
        name: "prop1",
        type: "String",
        visibility: "private",
        "default": "hello world"
      }, {
        name: "prop2",
        type: "String"
      }
    ], [
      {
        name: "method1",
        type: "Int"
      }, {
        name: "method2",
        type: "String",
        visibility: "public",
        parameters: [
          {
            name: "a",
            type: "Integer",
            "default": 12
          }, {
            name: "b",
            type: "Boolean"
          }
        ]
      }, {
        name: "method3",
        type: "String",
        visibility: "public"
      }
    ], {
      isInterface: true
    });
    uml3 = new App.View(editor, "my pretty view", [
      {
        name: "prop1",
        type: "String",
        visibility: "private",
        "default": "-"
      }
    ], [
      {
        name: "method1",
        type: "Int"
      }, {
        name: "method2",
        type: "String",
        visibility: "public",
        parameters: [
          {
            name: "a",
            type: "Integer",
            "default": 12
          }, {
            name: "b",
            type: "Boolean"
          }
        ]
      }
    ], {
      isAbstract: true
    });
    editor.addClass(uml);
    editor.addClass(uml2);
    editor.addClass(uml3);
    editor.draw();
    window.editor = editor;
    return true;
  });

}).call(this);
