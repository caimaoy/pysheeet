REQUIREMENT = requirements.txt

.PHONY: build
build: html

%:
	cd docs && make $@
publish:
	ghp-import docs/_build/html -p
