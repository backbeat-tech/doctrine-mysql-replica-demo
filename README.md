# Doctrine MySQL replica demo

A simple Symfony app that uses a primary database for writes and a replica database for reads.

See the code in Doctrine DBAL [here](https://github.com/doctrine/dbal/blob/master/lib/Doctrine/DBAL/Connections/MasterSlaveConnection.php).

## Run the app

You need docker-compose installed.

Run `docker-compose up` and wait for everything to start.
The `primary` and `replica` MySQL containers will start, then `replica` will configure itself as a slave of `primary`.
The `app` container runs a basic Symfony app using the web server bundle.

## URLs

* http://localhost:8001/ - select query, uses replica only
* http://localhost:8001/insert - insert query, uses primary only
* http://localhost:8001/update/{id} - select and update queries, uses replica to fetch the data then switches to primary
* http://localhost:8001/ping - troubleshooting, no database used

## Observing logs

The app logs are available in the docker-compose output (run `docker-compose logs -f app`), showing which database is being used:

```
app_1      | 2019-03-27T17:17:39+00:00 [info] Matched route "app_app_update".
app_1      | 2019-03-27T17:17:40+00:00 [debug] SELECT t0.id AS id_1, t0.level AS level_2, t0.hash AS hash_3 FROM item t0 WHERE t0.id = ?
app_1      | 2019-03-27T17:17:40+00:00 [debug] Used REPLICA for the previous query.
app_1      | 2019-03-27T17:17:40+00:00 [debug] "START TRANSACTION"
app_1      | 2019-03-27T17:17:40+00:00 [debug] UPDATE item SET level = ?, hash = ? WHERE id = ?
app_1      | 2019-03-27T17:17:40+00:00 [debug] "COMMIT"
app_1      | 2019-03-27T17:17:40+00:00 [debug] Used PRIMARY for the previous query.
app_1      | [Wed Mar 27 17:17:40 2019] 172.19.0.1:60352 [200]: /update/1
```
