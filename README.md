Фреймворк делает синтаксис баша более удобным и си-подобным так же добавляет классы.
### Синтаксис
Чтобы начать его использовать вам нужно: подключить файл, выполнить специальную команду(`STARTLUMFRAMEWORK`). Пример:
```
#!/bin/bash
source "lum.l"; STARTLUMFRAMEWORK
Class test_class {
	$self_test=dfgdfg

	$..file() {
		echo $$self_test;
	}f

	$..calc() {
		echo $(( $1 + $2 ));
	}f

}c

New test_class test;

while (true) {
	echo 1;
}l
```

Примеры можно найти в файле `test`

```
Class test_class {
	$self_test=dfgdfg

	$..file() {
		echo $$self_test;
	}f

	$..calc() {
		echo $(( $1 + $2 ));
	}f

}c

```

Для создания класса используется Class После вы указываете его название и открываете фигурные скобки. Для создания методов можно использовать как `$self.method() {}f` так и `$..method() {}f`, Для свойств: `$self_property`. так же можно использовать метод: `$self.property.set $property $value` | `$..property.set $property $value` и для получения: `$$self_property` | `$self.property.get $property` | `$..property.get $property`

Ветвления if else выглядят так:
```
if ($1 == 1) {
	echo 1;
} else if ($1 == 2) {
	echo 2;
} else {
	echo else;
}i
```
Циклы. Например while:
```
while (true) {
	echo 1;
}l
```

Закрывающая скобка должна иметь указатель на то какой блок она закрывает:
- }f (function)
- }c (class)
- }l (loop)
- }i (if)

Для подключения файлов испольщующих фреймворк я рекомендую использовать `include <path_to_file>`, для подключения просто bash файлов вы так же можете использовать `source` или `.`. В подключаемых файлах не нужно использовать `STARTLUMFRAMEWORK` или повторно подключать фреймворк.


### http_server
В состав фреймворка входит http сервер. Для его использования вам необходимо создать класс где будет метод с названием `server`. Для запуска используйте: `HOST=localhost PORT=8080 http_server class` Где class - имя вашего класса. Сервер будет запущен на указанном адресе и порту и начнёт принимать запросы. При поступлении запроса будет выполнен метод server из указанного класса. Вам будут доступны некоторые переменные. Например: `$http_location` Содержит путь по которому обратились к серверу. Если вам нужно получить данные какого-либо метода вы можете использовать `$GET_key` Тогда вы получите данные get параметра с названием "key". Первая строка установиливает заголовки. Вторая cookie, а третья http коды. Если вам это не нужно вы можете просто сделать `echo -e "\n\n200"` Тогда не будут установлены никакие заголовки или куки, будет установлен код 200. Для получения установленных cookie вы можете использовать `$COOKIE_name` для пользовательских заголовков `$HEADER_name`. Примеры:

Вывод пути и гет параметра cook с установкой хедеров и кук
```
#!/bin/bash
source "lum.l"; STARTLUMFRAMEWORK

Class test {
	$..server() {
		echo "Content-Type: text/html; X-Custom-Header: CustomValue"
    		echo "testcook=$GET_cook;"
    		echo "200"

		pwd
		echo $GET_cook
	}f
	
}c


HOST=localhost PORT=8080 http_server test
```
Без установки хедеров и кук, вывод всех переменных
```
#!/bin/bash
source "lum.l"; STARTLUMFRAMEWORK

Class test {
	$..server() {
		echo -e "\n\n200"
		set
	}f
	
}c


HOST=localhost PORT=8080 http_server test;
```
Без установки хедеров и кук, вывод всех полученных get параметров
```
#!/bin/bash
source "lum.l"; STARTLUMFRAMEWORK

Class test {
	$..server() {
		echo -e "\n\n200"
		set | grep "^GET_*"
	}f
	
}c


HOST=localhost PORT=8080 http_server test;
```

Обратите вниманиe при получении запросов. Вам будут недоступны глобальные переменные или функции находящиеся не в этом классе. Если же вы всё таки хотите получить доступ к своим переменным перед запуском сервера вам нужно их экспортировать например: `export variable=value`


### JSON
- `json.encode` принимает имя ассоциативного массива и выводит json.
- `json.decode` принимает в stdin json и параметром имя объекта в который нужно положить значения из этого json.
Обратите внимание. Вложенные структуры не поддерживаются, это только КЛЮЧ=ЗНАЧЕНИЕ.

### Установка.
##### Завиимости
Фреймворк зависит только от стандартных posix команд и bash, но для сборки потребуется `go`

##### Процесс установки
Склонируйте репозиторий, выдайте права на исполнение файлу `install`, запустите и выберите как вы хотите установить фреймворк, локально или глобально.
```
git clone https://github.com/Lumetas/bash_framework.git
cd bash_framework
chmod +x install
./install
```
