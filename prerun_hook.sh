#! /bin/bash

set -e

printf "
port: ${PORT}
# managementApiSecret: ${MGMT_SECRET}
databases:
  default:
    connector: postgres
    host: ${DB_HOST}
    port: ${DB_PORT}
    database: prisma
    schema: public
    user: ${DB_USER}
    password: ${DB_PASSWORD}
    migrations: true
" >> ${PRISMA_CONFIG_PATH}