package main

import (
 "bytes"
 "fmt"
 "io/ioutil"
 "net/http"
 "os"
 "os/exec"
 "strconv"
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
  // Получаем параметры запроса и заголовки
  getValues := r.URL.Query()
  postValues := r.Form
  httpLocation := r.URL.Path

  // Устанавливаем переменные окружения
  os.Setenv("http_location", httpLocation)

  // Устанавливаем GET и POST параметры
  for key, values := range getValues {
   os.Setenv("GET_"+key, strings.Join(values, ","))
  }
  for key, values := range postValues {
   os.Setenv("POST_"+key, strings.Join(values, ","))
  }

  // Устанавливаем заголовки из запроса
  for key, values := range r.Header {
   os.Setenv("HEADER_"+key, strings.Join(values, ", "))
  }

  // Устанавливаем куки
  for _, cookie := range r.Cookies() {
   os.Setenv("COOKIE_"+cookie.Name, cookie.Value)
  }

  // Выполняем команду app_server.server с установленными переменными
  cmd := exec.Command("bash", "-c", string(inputData)+"\napp_server.server")
  var out bytes.Buffer
  var stderr bytes.Buffer
  cmd.Stdout = &out
  cmd.Stderr = &stderr

  if err := cmd.Run(); err != nil {
   http.Error(w, stderr.String(), http.StatusInternalServerError)
   return
  }

  // Парсинг вывода команды
  outputLines := strings.Split(out.String(), "\n")
  if len(outputLines) < 3 {
   http.Error(w, "error, headers not set", http.StatusInternalServerError)
   return
  }

  // Получаем заголовки, куки и код состояния
  headersLine := outputLines[0]
  cookiesLine := outputLines[1]
  statusCodeLine := outputLines[2]

  // Устанавливаем заголовки
  for _, header := range strings.Split(headersLine, ";") {
   parts := strings.SplitN(header, ":", 2)
   if len(parts) == 2 {
    w.Header().Set(strings.TrimSpace(parts[0]), strings.TrimSpace(parts[1]))
   }
  }

  // Устанавливаем куки
  for _, cookie := range strings.Split(cookiesLine, ";") {
   parts := strings.SplitN(cookie, "=", 2)
   if len(parts) == 2 {
    http.SetCookie(w, &http.Cookie{
     Name:  strings.TrimSpace(parts[0]),
     Value: strings.TrimSpace(parts[1]),
    })
   }
  }

  // Устанавливаем код состояния
  statusCode, err := strconv.Atoi(strings.TrimSpace(statusCodeLine))
  if err == nil {
   w.WriteHeader(statusCode)
  }

  // Возвращаем остальной вывод команды пользователю
  for _, line := range outputLines[3:] {
   if strings.TrimSpace(line) != "" {
    fmt.Fprint(w, line+"\n")
   }
  }
 })

 // Запуск HTTP-сервера
 address := fmt.Sprintf("%s:%s", host, port)
 if err := http.ListenAndServe(address, nil); err != nil {

  fmt.Println("Ошибка при запуске сервера:", err)
 }
}
