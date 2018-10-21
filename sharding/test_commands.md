Показать существующие шарды и их реплики
```
db.getSiblingDB("config").shards.find()
```
или то же самое построчно
```
use admin
db.runCommand({listshards:1})
```
Вывод сегментированных DB
```
db.getSiblingDB("config").databases.find()
```
Вывод сегментированных коллекций
```
db.getSiblingDB("config").collections.findOne()
```
Узнать количество чанк
```
use config
db.chunks.count()
```
Детальная информация о шардах
```
sh.status()
```
Инфа о DB
```
use asl
db.sessions.count()
db.sessions.getIndexes()
db.sessions.stats()
db.sessions.stats().size
```
