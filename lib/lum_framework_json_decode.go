
package main

import (
 "bufio"
 "encoding/json"
 "fmt"
 "os"
 "strings"
)

func main() {
 if len(os.Args) < 2 {
  fmt.Println("Необходим аргумент для имени переменной")
  return
 }
 varName := os.Args[1]

 // Читаем JSON из стандартного ввода
 reader := bufio.NewReader(os.Stdin)
 input, _ := reader.ReadString('\n')

 // Убираем возможные пробелы в начале и конце
 input = strings.TrimSpace(input)

 // Декодируем JSON
 var data map[string]interface{}
 if err := json.Unmarshal([]byte(input), &data); err != nil {
  fmt.Println("Ошибка при декодировании JSON:", err)
  return
 }

 // Выводим объявление асссоциативного массива
 // fmt.Printf("declare -A %s;\n", varName)

 // Обрабатываем ключи и значения
 for key, value := range data {
  // Игнорируем вложенные структуры (массивы и объекты)
  if _, ok := value.(map[string]interface{}); ok {
   continue // Игнорируем объекты
  }
  if _, ok := value.([]interface{}); ok {
   continue // Игнорируем массивы
  }

  // Выводим ключ и значение в требуемом формате
  fmt.Printf("%s[%s]=\"%v\";\n", varName, key, value)
 }
}
