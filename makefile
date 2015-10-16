PROJECT_NAME = UMLEditor

DIR = ./js
COFFEE_FILES = $(DIR)/namespaces.coffee \
			   $(DIR)/prototyping/String.coffee $(DIR)/prototyping/Array.coffee \
			   ./templates/navbar.coffee ./templates/svg.coffee ./templates/chooseConnection.coffee ./templates/selectClassesForConnection.coffee \
			   $(DIR)/Template.coffee \
			   $(DIR)/UMLConnection/UMLConnectionDataCollector.coffee \
			   $(DIR)/UMLEditor.coffee \
			   $(DIR)/AbstractView.coffee \
			   $(DIR)/UMLClass/UMLClass.coffee $(DIR)/UMLClass/UMLClassView.coffee $(DIR)/UMLClass/UMLClassEditView.coffee \
			   $(DIR)/UMLConnection/UMLMultiplicity.coffee \
			   $(DIR)/UMLConnection/UMLConnection.coffee \
			   $(DIR)/UMLConnection/ClassLevel/Generalization.coffee $(DIR)/UMLConnection/ClassLevel/Realization.coffee
DEBUG_FILE = $(DIR)/debug.coffee
TEST_FILES = $(DIR)/$(PROJECT_NAME).test.coffee

CSS_FILES = css/general.sass css/uml.sass css/uml_edit.sass css/dagre_graph.sass css/templates/selectClassesForConnection.sass

make:
	# compile coffee
	cat $(DEBUG_FILE) $(COFFEE_FILES) | coffee --compile --stdio > $(DIR)/$(PROJECT_NAME).js
	# compile sass
	cat $(CSS_FILES) > css/$(PROJECT_NAME).sass
	sass css/$(PROJECT_NAME).sass css/$(PROJECT_NAME).css

test: make
	cat $(TEST_FILES) | coffee --compile --stdio > $(DIR)/$(PROJECT_NAME).test.js

min:
	cat $(COFFEE_FILES) | coffee --compile --stdio > $(PROJECT_NAME).temp.js
	uglifyjs $(PROJECT_NAME).temp.js -o $(DIR)/$(PROJECT_NAME).min.js -c drop_console=true -d DEBUG=false -m
	rm -f $(PROJECT_NAME).temp.js

clean:
	rm -f $(DIR)/$(PROJECT_NAME).js
	rm -f $(DIR)/$(PROJECT_NAME).test.js
	rm -f $(DIR)/$(PROJECT_NAME).min.js
	# css
	rm -f css/UMLEditor.sass
	rm -f css/UMLEditor.css
	rm -f css/UMLEditor.css.map
