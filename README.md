Фреймворк делает синтаксис баша более удобным и си-подобным так же добавляет классы.

Чтобы начать его использовать вам нужно: подключить файл, выполнить специальную команду. Пример:
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
	$self_hui=dfgdfg

	$..file() {
		echo $$self_hui;
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




