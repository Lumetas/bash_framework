function Class {
	read -r -d '' $1
	local class_content="${!1}"
	read -r -d '' $1 <<<$class_content

}

function New {

	local class_content="${!1}"
	local class_content="${class_content//\$self/$2}"
	local class_content="${class_content//\$../$2.}"

	read -r -d '' $2 <<<$class_content
	
	
	local props="\$self.property.set() {
		read -r -d '' \$self_\$1 <<<\$2;
	}

	\$self.property.get() {
		local v=\"\$self_\$1\";
		echo -e \"\${!v}\";
	}

	"

	local props="${props//\$self/$2}"

	. <( echo -e "$props" )
	. <( echo -e "$class_content" )
	
	obj_name="$2";
	shift 2;
	if declare -F "$obj_name.construct" > /dev/null; then
		eval "$obj_name.construct $@";
	fi
}

function class_prepare {
	local class_content="${!1}"
	local class_content="${class_content//\$self/$2}"
	local class_content="${class_content//\$../$2.}"

	read -r -d '' $2 <<<$class_content
	
	
	local props="\$self.property.set() {
		read -r -d '' \$self_\$1 <<<\$2;
	}

	\$self.property.get() {
		local v=\"\$self_\$1\";
		echo -e \"\${!v}\";
	}

	"

	local props="${props//\$self/$2}"
	
	echo -e "$3\n$props\n$class_content";

}
