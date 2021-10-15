# Stress Test Yandex.Tank

## Содержание

В этом репо будут собраны инструменты для тестирования

## Нагрузочное тестирование

[Документация на Yandex.Tank](https://yandextank.readthedocs.io/en/latest/config_reference.html#phantom-http-field-num-integer)

## Зависимости

* jq

## Запуск

* Заполнить переменные в файле `start.sh`
  * APP_METOD: GET, POST, PUT etc.
  * APP_HOST: имя хоста, например myhost.domain.local
  * APP_PORT: порт на хосте
  * APP_SEC: true\false SSL
  * APP_SCHEDULE: стратегия тестирования (см. [Tutorial](https://yandextank.readthedocs.io/en/latest/tutorial.html))
  * APP_URL: например /api/users
  * APP_BODY: тело запроса

```bash
./start.sh
Get API Token?[y\n]: n          # Получить token для доступа к сервису
Generate new ammo?[y\n]: y      # Сгенерировать "обойму"
```

[Grafana](http://localhost:3000) admin\admin

## Остановка

```bash
docker-compose down
```
