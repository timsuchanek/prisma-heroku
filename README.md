# Prisma on Heroku example

This repository showcases how to deploy Prisma to Heroku.

## Prerequisites

1. A Heroku account.
1. Heroku CLI installed.
1. Docker installed.

## Step-by-step example deployment

1. Clone this repo
1. Log the Heroku CLI into Heroku: `heroku login`
1. Log into the Heroku docker registry:
    1. `heroku container:login`
    1. If you face issues, try `docker login --username=_ --password=$(heroku auth:token) registry.heroku.com`
1. Create a Heroku app via the web interface or via CLI: `heroku create`. This will return an app name if you didn't specify one, like `endless-sand-123456`. We need this name in the next steps.
1. Execute the build script with the app name and desired Prisma version as args, for example: `./build.sh 1.8.4 endless-sand-123456`. This does 2 things:
    1. It takes the Prisma docker image as a base and adds a prerun hook that renders the Prisma config required to run the app, and adds a CMD docker directive to the image that Heroku requires all images to have.
    1. It tags the image correctly for the Heroku registry and pushes it.
    1. **This does NOT deploy the app.**
1. Now we need to configure the env vars:
    1. Either set them one by one via the CLI with `heroku config:set <key>=<value> -a <your_app_name>`...
    1. ...or navigate to the web interface and set them under `settings`
    1. Set the config vars:
        1. `DB_HOST` to your database host
        1. `DB_PASSWORD` to your database password
        1. `DB_PORT` to your database port
        1. `DB_USER` to your database user
        1. `PRISMA_CONFIG_PATH` to `/app/config.yml`
    1. **Note**: This example repo uses PostgreSQL. To change that, simply change the `connector: postgres` to `connector: mysql` in `prerun_hook.sh`.
1. Finally, deploy the app with `heroku container:release web -a <your_app_name>`
1. Open the app with `heroku open -a <your_app_name>` (this can take a bit, depending on the Dyno startup for example)

# Additional notes
If you want to change the Prisma config, for example to add authentication (recommended), look at the `prerun_hook.sh` file and edit the config there. It is recommended to follow the existing pattern there and use env var interpolation with Heroku config vars to not accidentially commit secrets.