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
    name=""
    prev_inputs=()
    prev_responses=()
    # name=$(python listen.py "./models/recog/en/wav2vec2-large-xlsr-53-english")

    echo -ne "Who would you like to talk to?\n1) Sofia (Español)\n2) Emma (Français)\nSelect: "

    read selection

    echo $selection

    if [[ $selection == 1 ]]; then
        lang="es-en"
        name="Sofia"
    else
        lang="fr-en"
        name="Emma"
    fi

    echo -ne "\nBegin chatting with $name: "

    read input

    size=${#input}

    if [[ $size -lt 2 || $size -gt 28 ]]; then
        exit 1
    fi

    convo=$(python converse.py $input)

    echo $convo

    while true; do
        echo -ne "You: "
        read inp

        convo=$(python converse.py $inp)

        echo "$name: $convo"
    done
}

main
