#!/bin/bash

setLanguage() {
    lang=""

    case "$1" in
    "Hey Sofia")
        lang="es-ES"
        ;;
    "Hey Emma")
        lang="fr-FR"
        ;;
    *)
        exit 1
        ;;
    esac

    echo $lang
}

spin() {
    pid=$!

    spin[0]="-"
    spin[1]="\\"
    spin[2]="|"
    spin[3]="/"

    echo -n "[loading] ${spin[0]}"
    while [ kill -0 $pid ]; do
        for i in "${spin[@]}"; do
            echo -ne "\b$i"
            sleep 0.1
        done
    done
}

main() {
    set -e

    source .venv/bin/activate

    lang=""
    t_lang=""
    name=""
    prev_inputs=()
    prev_responses=()

    echo -ne "Who would you like to talk to?\n1) Sofia (Español)\n2) Emma (Français)\nSelect: "

    read selection

    echo $selection

    if [[ $selection == 1 ]]; then
        lang="en-es"
        t_lang="es-en"
        name="Sofia"
    else
        lang="en-fr"
        t_lang="fr-en"
        name="Emma"
    fi

    echo -ne "\nBegin chatting with $name: "

    read input

    size=${#input}

    if [[ $size -lt 2 || $size -gt 28 ]]; then
        exit 1
    fi

    translated_input=$(python translate.py "$input" "$lang")
    echo -ne "Translation: $translated_input"

    response=$(python converse.py $input)
    translated_response=$(python translate.py "$response" "$lang")
    echo -ne "\n$name: $response"
    echo -ne "\nTranslation: $translated_response"

    while true; do
        echo -ne "\nYou: "
        read inp

        translated_inp=$(python translate.py "$inp" "$lang")
        echo -ne "Translation: $translated_inp"

        res=$(python converse.py $inp)
        translated_res=$(python translate.py "$res" "$lang")
        echo -ne "\n$name: $res"
        echo -ne "\nTranslation: $translated_res"

    done
}

main
