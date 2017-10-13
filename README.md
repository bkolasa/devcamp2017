# Instalacja

Aby uruchomić środowiska pokazywane podczas warsztatów wymagane jest, aby:
* mieć zainstalowane programy `docker` i `docker-compose`
* ściągnąć paczki instalacyjne Vertiki ze strony [my.vertica.com](my.vertica.com) (dostępne po zarejestrowaniu):
  * wersję community bazy danych w formacie rpm (np. vertica-8.1.1-0.x86_64.RHEL6.rpm)
  * wersję klienta wraz z konektorami ODBC i JDBC w formacie tar.gz (np. vertica-client-8.1.1-2.x86_64.tar.gz)
* sklonować to repozytorium i umieścić pobrane wcześniej pliki rpm i tar.gz
* Uruchomić w repozytorium polecenie (trwa ok. 20 minut i pobiera kikaset MB z internetu):
```bash
docker-compose up
```
* Rozpakować archiwum z klientem Vertiki (np. vertica-client-8.1.1-2.x86_64.tar.gz)
* Za pomocą znajdującego się tam klienta `vsql` zapełnić bazę używając komendy:
```bash
$PATH_TO_VSQL -p 5433 -U dbadmin < populate_db.sql
```

# Całe dane
W repozytorium znajduje się tylko próbka danych z pozycjami autobusów z jednego niepełnego dnia (1.11.2016 r.).
Pełny zbiór danych znajduje się [tutaj](https://drive.google.com/open?id=0B6lknm3hDQaNSXZHaDd1TTIwT3c) (ok. 900 MB skompresowanych danych).
Należy go następnie rozpakować i przenieść do katalogu z repozytorium. Finalnie plik waży ok. 8 GB.

# Wymaganie sprzętowe

* minimum 8GB pamięci RAM (najlepiej 16 GB)
* 20 GB miejsca na dysku
