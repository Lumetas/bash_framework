#!/bin/bash
function http_server {
	class_prepare $1 app_server "source modules.l" | lum_framework_http_server;
}
