setup:
	pip install pipenv
	pip install black
	install

env:
	pipenv shell

install:
	pipenv install

clean:
	find . -name '*.pyc' -exec rm -f {} +
	find . -name '*.pyo' -exec rm -f {} +
	find . -name '*~' -exec rm -f {} +

format:
	black .

run:
	python manage.py runserver

test:
	python manage.py test

typecheck:
	mypy --ignore-missing-imports .

prep: clean typecheck format test