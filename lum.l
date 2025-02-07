#!/bin/bash
source "modules.l"
export LUMFRAMEWORKVERSION=0.5

if [[ "${BASH_SOURCE[0]}" != "${0}" ]]; then
	. <(transform_syntax <<<"$(awk '/STARTLUMFRAMEWORK/{flag=1;next} flag' $0)")
	exit;
else
	if [[ "$1" == "-v" ]]; then
		echo $LUMFRAMEWORKVERSION;
	elif [[ "$1" == "init" && -n "$2" ]]; then
		git clone https://github.com/Lumetas/bash_framework.git "$2";
		cd "$2";
		chmod +x install;
		rm test README.md;
		echo l | ./install;
fi
fi

