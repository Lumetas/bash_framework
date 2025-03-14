#!/bin/bash
source "modules.l"
export LUMFRAMEWORKVERSION=0.5
shopt -s expand_aliases

if [[ "${BASH_SOURCE[0]}" != "${0}" ]]; then
    . <(transform_syntax <<<"$(awk '/STARTLUMFRAMEWORK/{flag=1;next} flag' $0)")
    exit;
else
    if [[ "$1" == "-v" ]]; then
        echo $LUMFRAMEWORKVERSION;
    elif [[ "$1" == "init" && -n "$2" ]]; then
        git clone https://github.com/Lumetas/bash_framework.git "$2";
        cd "$2";
        chmod +x install;
        rm test README.md test.json;
        echo l | ./install;
    elif [[ "$1" == "build" ]]; then
        # Проверка наличия аргументов
        if [ $# -lt 2 ]; then
            echo "Использование: $0 build <файл1> [файл2 ...]"
            exit 1
        fi

        # Имя итогового скрипта (на основе первого файла)
        OUTPUT_SCRIPT="${2%.*}.bin"

        # Очистка предыдущего результата
        rm -f "$OUTPUT_SCRIPT"

        # Создание временной директории
        TMP_DIR=$(mktemp -d)

        # Копирование всех необходимых файлов
        cp lum.l http_server.l json.l oop.l parser.l struct.l modules.l "$TMP_DIR/"
        cp -r lib "$TMP_DIR/"

        # Копирование дополнительных файлов, переданных в аргументах
        for file in "${@:2}"; do
            cp "$file" "$TMP_DIR/"
        done

        # Создание архива
        tar -czf "$TMP_DIR/lum_framework.tar.gz" -C "$TMP_DIR" .

        # Создание самораспаковывающегося скрипта
        cat <<EOF > "$OUTPUT_SCRIPT"
#!/bin/bash

# Временная директория для распаковки
TMP_DIR=\$(mktemp -d)

# Извлечение архива
ARCHIVE_START=\$(awk '/^__ARCHIVE__/ {print NR + 1; exit 0; }' "\$0")
tail -n+\$ARCHIVE_START "\$0" | tar -xz -C "\$TMP_DIR"

# Переход в директорию с распакованными файлами
cd "\$TMP_DIR"

# Установка PATH для бинарных файлов
export PATH="\$TMP_DIR/lib:\$PATH"

# Запуск первого переданного файла с аргументами
if [ -f "$2" ]; then
    bash "$2" "\$@"
else
    echo "Ошибка: файл '$2' не найден."
    exit 1
fi

# Очистка временной директории
rm -rf "\$TMP_DIR"

exit 0

__ARCHIVE__
EOF

        # Добавление архива в конец скрипта
        cat "$TMP_DIR/lum_framework.tar.gz" >> "$OUTPUT_SCRIPT"

        # Установка прав на выполнение
        chmod +x "$OUTPUT_SCRIPT"

        # Очистка временной директории
        rm -rf "$TMP_DIR"

        echo "Проект собран: $OUTPUT_SCRIPT"
    else
        echo "Неизвестная команда. Используйте:"
        echo "  $0 -v              # Показать версию"
        echo "  $0 init <директория> # Инициализировать проект"
        echo "  $0 build <файл1> [файл2 ...] # Собрать проект"
    fi
fi
