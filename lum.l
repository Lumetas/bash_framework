#!/bin/bash
source "modules.l"

. <(transform_syntax <<<"$(awk '/STARTLUMFRAMEWORK/{flag=1;next} flag' $0)")
exit;

