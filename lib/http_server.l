#!/bin/bash
function http_server {

	class_prepare $1 app_server | ./http_server;

}
