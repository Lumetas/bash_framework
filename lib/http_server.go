package main

import (
 "bytes"
 "fmt"
 "io/ioutil"
 "net/http"
 "os"
 "os/exec"
 "strings"
)

func main() {
 // Чтение функций из stdin
 inputData, err := ioutil.ReadAll(os.Stdin)
 if err != nil {
  fmt.Println("Ошибка чтения stdin:", err)
  return
 }

 // Получаем переменные окружения
 host := os.Getenv("HOST")
 port := os.Getenv("PORT")

 if host == "" || port == "" {
  fmt.Println("Не указаны хост или порт. Установите переменные окружения HOST и PORT.")
  return
 }

 // Создаем HTTP-обработчик
 http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
  // Получаем параметры запроса
  getValues := r.URL.Query()
  postValues := r.Form
  httpLocation := r.URL.Path

  // Устанавливаем переменные окружения
  os.Setenv("http_location", httpLocation)

  for key, values := range getValues {
   os.Setenv("GET_"+key, strings.Join(values, ","))
  }
  for key, values := range postValues {
   os.Setenv("POST_"+key, strings.Join(values, ","))
  }

  // Выполняем команду app_server.server с установленными переменными
  cmd := exec.Command("bash", "-c", string(inputData)+"\napp_server.server") // Исправлено здесь
  var out bytes.Buffer
  var stderr bytes.Buffer
  cmd.Stdout = &out
  cmd.Stderr = &stderr

  if err := cmd.Run(); err != nil {
   http.Error(w, stderr.String(), http.StatusInternalServerError)
   return
  }

  // Возвращаем вывод команды пользователю
  fmt.Fprint(w, out.String())
 })

 // Запуск HTTP-сервера
 address := fmt.Sprintf("%s:%s", host, port)
 if err := http.ListenAndServe(address, nil); err != nil {
  fmt.Println("Ошибка при запуске сервера:", err)
 }
}

