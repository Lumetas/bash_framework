#!/bin/bash
source "oop.l"
source "http_server.l"
transform_syntax() {
sed -E '

    # Для классов
    s/^[[:space:]]*Class ([a-zA-Z_][a-zA-Z0-9_]*) \{/Class \1 <<'\''CLASSEND'\''/g;

    # Заменяем function() на function
    s/^[[:space:]]*([a-zA-Z_][a-zA-Z0-9_]*)\(\) \{/function \1 {/g;

    # Заменяем if (условие) на if [[ условие ]]
    s/^[[:space:]]*if \((.*)\) \{/if [[ \1 ]]; then/g;

    # Заменяем else if (условие) на elif [[ условие ]]
    s/^[[:space:]]*\} else if \((.*)\) \{/elif [[ \1 ]]; then/g;

    # Заменяем else { на else
    s/^[[:space:]]*\} else \{/else/g;

    # Заменяем while (условие) на while [[ условие ]]
    s/^[[:space:]]*while \((.*)\) \{/while [[ \1 ]]; do/g;

    # Заменяем for (инициализация; условие; инкремент) на for ((инициализация; условие; инкремент))
    s/^[[:space:]]*for \(\((.*)\)\) \{/for (( \1 )); do/g;

    # Заменяем закрывающие фигурные скобки на соответствующие ключевые слова
    s/^[[:space:]]*\}i[[:space:]]*$/fi/g;  # для if
    s/^[[:space:]]*\}l[[:space:]]*$/done/g;  # для циклов
    s/^[[:space:]]*\}c[[:space:]]*$/CLASSEND/g;  # для классов
    s/^[[:space:]]*\}f[[:space:]]*$/\}/g;  # для функций
'

}



function include {
	. <(transform_syntax < $1);
}

. <(transform_syntax <<<"$(awk '/STARTLUMFRAMEWORK/{flag=1;next} flag' $0)")
exit;

