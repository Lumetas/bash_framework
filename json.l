function lum.json.encode {
	set | grep "^$1=" | ./lib/lum_framework_json_encode
}

function lum.json.decode {
	. <(cat | ./lib/lum_framework_json_decode $1;)
}
