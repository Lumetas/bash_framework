function json.encode {
	set | grep "^$1=" | lum_framework_json_encode
}

function json.decode {
	. <(cat | lum_framework_json_decode $1;)
}
