## Requirements
* crystal (v15)

## Quickstart
Install dependencies
```bash
shards install
```

<br>
create the sqlite3 db file and table

```bash
crystal ./createdb.cr
```

<br>
run the batch scraper: once per 60sec.

```bash
crystal ./scrape.cr 
```

<br>
run the webserver in a seperate shell.

```bash
crystal ./webserver.cr
```

URL: http://127.0.0.1:8080/

References:
* https://crystal-lang.org/api/1.15.1/
* https://github.com/crystal-lang/crystal-sqlite3
* https://github.com/kostya/myhtml
* https://www.chartjs.org/docs/latest/
