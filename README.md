## Set up
1. `cd` into `api/`
2. `$ mix pkg`
3. `$ ./bin/generate_release`
4. `$ ansible-playbook ./deploy/deploy.yml`
5. `$ ansible-playbook ./deploy/migrations.yml`
6. `$ ansible-playbook ./deploy/startup.yml`

## Database setup
1. `cd` into `api/`
2. `$ ansible-playbook ./deploy/create-db.yml`

This has to be done _before_ the app server is started

## Teardown
1. `cd` into `api/`
2. `$ ansible-playbook ./deploy/teardown.yml`

## Database teardown
1. `cd` into `api/`
2. `$ ansible-playbook ./deploy/teardown-db.yml`