
package main

import (
 "bufio"
 "encoding/json"
 "fmt"
 "os"
 "regexp"
)

func main() {
 // Считываем всю строку
 reader := bufio.NewReader(os.Stdin)
 input, _ := reader.ReadString('\n')

 // Убираем возможные пробелы в начале и конце
 input = regexp.MustCompile(`^\s*|\s*$`).ReplaceAllString(input, "")

 // Находим содержимое внутри скобок
 re := regexp.MustCompile(`\((.*?)\)`)
 matches := re.FindStringSubmatch(input)

 if len(matches) < 2 {
  fmt.Println("Не удалось извлечь содержимое из скобок")
  return
 }

 // Содержимое внутри скобок
 normalizedInput := matches[1]

 // Создаём ассоциативный массив (map)
 data := make(map[string]string)

 // Паттерн для извлечения ключа и значения
 pattern := regexp.MustCompile(`\[(.+?)\]="(.+?)"`)

 // Находим все пары ключ-значение
 for _, part := range pattern.FindAllStringSubmatch(normalizedInput, -1) {
  if len(part) == 3 {
   key := part[1]   // Ключ
   value := part[2] // Значение
   data[key] = value
  }
 }

 // Генерируем JSON
 jsonData, err := json.Marshal(data)
 if err != nil {
  fmt.Println("Ошибка при преобразовании в JSON:", err)
  return
 }

 // Выводим JSON в stdout
 fmt.Println(string(jsonData))
}
