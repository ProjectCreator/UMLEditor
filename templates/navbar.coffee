App.Templates.navbar = """<nav class="navbar navbar-default">
    <div class="container-fluid">
        <div class="navbar-header">
            <a class="navbar-brand" href="#">UMLEditor</a>
        </div>

        <div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
            <ul class="nav navbar-nav">
                <li>
                    <a href="#">
                        <span class="label label-primary label-lg">
                            New class &nbsp;
                            <span class="glyphicon glyphicon-plus"></span>
                        </span>
                    </a>
                </li>
                <li>
                    <a href="#">
                        <span class="label label-primary label-lg">
                            Connect classes &nbsp;
                            <span class="glyphicon glyphicon-link"></span>
                        </span>
                    </a>
                </li>
                <li>
                    <a href="#">
                        <span class="label label-primary label-lg">
                            Arrange &nbsp;
                            <span class="glyphicon glyphicon-transfer"></span>
                        </span>
                    </a>
                </li>
                <!-- <li class="dropdown">
                    <a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false">Dropdown <span class="caret"></span></a>
                    <ul class="dropdown-menu">
                        <li><a href="#">Action</a></li>
                        <li><a href="#">Another action</a></li>
                        <li><a href="#">Something else here</a></li>
                        <li role="separator" class="divider"></li>
                        <li><a href="#">Separated link</a></li>
                        <li role="separator" class="divider"></li>
                        <li><a href="#">One more separated link</a></li>
                    </ul>
                </li> -->
            </ul>
            <ul class="nav navbar-nav navbar-right">
                <form class="navbar-form" role="search">
                    <div class="form-group relative">
                        <input type="text" class="form-control search" placeholder="Search classes">
                        <button type="button" class="close" title="Clear search">
                            <span>&times;</span>
                        </button>
                    </div>
                </form>
            </ul>
        </div>
    </div>
</nav>"""
