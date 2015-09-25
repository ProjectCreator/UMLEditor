PROJECT_NAME = UMLEditor

DIR = ./js
COFFEE_FILES = $(DIR)/namespaces.coffee \
			   $(DIR)/ShapeFactory.coffee $(DIR)/LinkFactory.coffee 
DEBUG_FILE = $(DIR)/debug.coffee
TEST_FILES = $(DIR)/$(PROJECT_NAME).test.coffee


make:
	# compile coffee
	cat $(DEBUG_FILE) $(COFFEE_FILES) | coffee --compile --stdio > $(DIR)/$(PROJECT_NAME).js

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
