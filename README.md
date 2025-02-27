# medline-ghost-demo

## Demo repo to show functionality of gh-ost to clients
1. run `docker compose up` to create a pair of mysql 8.0 servers with distinctly configured server_id's (needed for row based replication)
2. run `./scripts/initial-setup.sh` to create a user for replication, configure the master/slave to allow replication, and start replication
3. run `./scripts/init-seeds.sh` to create a generic `users` table, and seed with randomly generated records
4. [todo] execute gh-ost targeting our local environment, as "Test on replica" 
    - [todo] verify new table has changes made, and has expected records
    - docs [here](https://github.com/github/gh-ost/blob/master/doc/testing-on-replica.md#examples)
5. [todo] execute gh-ost targeting our local environment, as "Migrate on replica"
    - [todo] verify ghost table is gone, and replication is still continuing