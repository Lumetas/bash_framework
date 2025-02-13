#!/bin/bash

struct.create() {
  local base_path="$1"
  local structure="$2"

  # Удаляем пустые строки из структуры
  structure=$(echo "$structure" | sed '/^[[:space:]]*$/d')

  # Внутренняя функция для создания файлов и папок
  create_item() {
    local path="$1"
    local item="$2"

    if [[ "$item" == */ ]]; then
      # Это папка
      mkdir -p "$path/${item%/}"
    else
      # Это файл
      touch "$path/$item"
    fi
  }

  # Обрабатываем каждую строку структуры
  while IFS= read -r line; do
    # Заменяем табуляции на 4 пробела (для удобства)
    line=$(echo "$line" | sed 's/\t/    /g')

    # Определяем уровень вложенности по количеству пробелов в начале строки
    local level=$(echo "$line" | awk '{print match($0, /[^ ]/)}')
    level=$((level - 1))  # Уровень = количество пробелов / 4 (если табуляция заменена на 4 пробела)

    # Убираем лишние пробелы в начале и конце строки
    line=$(echo "$line" | sed -e 's/^[ \t]*//' -e 's/[ \t]*$//')

    # Строим полный путь
    local full_path="$base_path"
    for ((i = 1; i <= level; i++)); do
      full_path="$full_path/${path_stack[$i]}"
    done

    # Создаем файл или папку
    create_item "$full_path" "$line"

    # Если это папка, добавляем её в стек
    if [[ "$line" == */ ]]; then
      path_stack[$((level + 1))]="${line%/}"
    fi
  done <<< "$structure"
}

struct.dump() {
  local base_path="$1"
  local indent="$2"
  
  for item in "$base_path"/*; do
    local item_name=$(basename "$item")

    # Игнорируем скрытые файлы и папки
    if [[ "$item_name" == .* ]]; then
      continue
    fi

    if [[ -d "$item" ]]; then
      echo "${indent}${item_name}/"
      struct.dump "$item" "$indent "
    elif [[ -f "$item" ]]; then
      echo "${indent}${item_name}"
    elif [[ -L "$item" ]]; then
      echo "${indent}${item_name} (symlink)"
    fi
  done
}
