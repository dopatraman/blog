format:
	black .

run:
	python manage.py runserver

test:
	python manage.py test

typecheck:
	mypy --ignore-missing-imports .
