#!/bin/bash
source "oop.l"
source "http_server.l"
source "json.l"
source "parser.l"
source "struct.l"
function include { . <(transform_syntax < $1); }
