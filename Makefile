.PHONY: docs
docs:
	mkdocs serve -a 127.0.0.1:12001
.PHONY: install_packages
start:
	flutter pub get

.PHONY: install
install: 
	flutter pub add ${package}
	flutter pub get

.PHONY: install-dev
install-dev:  
	flutter pub add -d ${package}
	flutter pub get