function lum.json.encode {
	set | grep "^$1=" | lum_framework_json_encode
}

function lum.json.decode {
	. <(cat | lum_framework_json_decode $1;)
}
