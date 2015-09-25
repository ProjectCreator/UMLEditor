$(document).ready () ->

    graph = new joint.dia.Graph()

    paper = new joint.dia.Paper({
        el:     $('#myholder')
        width:  1200
        height: 600
        model:  graph
        gridSize: 1
    })

    # rect = new joint.shapes.basic.Rect({
    #     position: { x: 100, y: 30 },
    #     size: { width: 100, height: 30 },
    #     attrs: { rect: { fill: 'blue' }, text: { text: 'my box', fill: 'white' } }
    # })
    #
    # rect2 = rect.clone()
    # rect2.translate(300)
    #
    # link = new joint.dia.Link({
    #     source: { id: rect.id },
    #     target: { id: rect2.id }
    # })
    # link.attr {
    #     '.marker-source': { fill: 'red', d: 'M 10 0 L 0 5 L 10 10 z' },
    #     '.marker-target': { fill: 'yellow', d: 'M 10 0 L 0 5 L 10 10 z' }
    # }

    model = App.ShapeFactory.Model.new({
        name: 'test'
        attributes: [
            {
                name: "attr1"
                type: "String"
            }
            {
                name: "attr2"
                type: "Number"
            }
        ]
        methods: [
            {
                name: "doStuff"
                parameters: [
                    {
                        name: "a"
                        type: "String"
                    }
                    {
                        name: "b"
                        type: "MyType"
                    }
                ]
            }
        ]
    }, {
        x: 20
    })

    controller = App.ShapeFactory.Controller.new({
        name: 'testController'
        attributes: [
            {
                name: "attr1"
                type: "String"
            }
        ]
        methods: [
            {
                name: "doStuff"
                parameters: [
                    {
                        name: "a"
                        type: "String"
                    }
                    {
                        name: "b"
                        type: "MyType"
                    }
                ]
            }
        ]
    }, {
        x: 370
        y: 100
    })

    console.log controller

    graph.addCells([
        # rect
        # rect2
        # link
        model
        controller
    ])

    graph.addCell(
        App.LinkFactory.new("Association", model, controller)
    )


    # paperSmall = new joint.dia.Paper({
    #     el: $('#myholder-small')
    #     width: 600
    #     height: 100
    #     model: graph
    #     gridSize: 1
    # })
    # paperSmall.scale(0.5)
    # paperSmall.$el.css('pointer-events', 'none')
