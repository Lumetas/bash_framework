#!/bin/bash
function lum.http.server {
	class_prepare $1 app_server "source modules.l" | ./lib/lum_framework_http_server;
}
