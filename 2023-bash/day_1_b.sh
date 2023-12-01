#!/bin/bash

input_file="inputs/day_1.txt"

declare -A reference=(
    ["1"]="1"
    ["one"]="1"
    ["2"]="2"
    ["two"]="2"
    ["3"]="3"
    ["three"]="3"
    ["4"]="4"
    ["four"]="4"
    ["5"]="5"
    ["five"]="5"
    ["6"]="6"
    ["six"]="6"
    ["7"]="7"
    ["seven"]="7"
    ["8"]="8"
    ["eight"]="8"
    ["9"]="9"
    ["nine"]="9"
)

sum=0
echo  "" > "matches.csv"
echo "ligne,position,substring,pattern,valeur,chiffres,sum" >> "matches.csv"

# Parcourir chaque ligne du fichier d'entrée
while IFS= read -r line; do
    position=0
    chiffres=()

    # echo "Ligne en cours : $line"
    # Indicateur pour savoir si un motif a été trouvé

    # Tant que la position est inférieure à la longueur de la chaîne
    while [ "$position" -lt "${#line}" ]; do
        # Initialiser la sous-chaîne courante à partir de la position actuelle
        current_substring="${line:$position}"
        is_key_found=false
        # echo "Position : $position, Sous-chaîne actuelle : $current_substring"


        # Vérifier si la sous-chaîne commence par un élément du tableau de référence
        for key in "${!reference[@]}"; do
            # echo "pattern $key"
            if [[ "$current_substring" = "$key"* ]]; then
                # Ajouter la valeur associée à la table de référence dans le tableau chiffres
                chiffres+=("${reference[$key]}")
                # echo "Motif trouvé : $key, Ajouté à chiffres : ${reference[$key]}"
                # echo "$line,$position,$current_substring,$key,${reference[$key]},${chiffres[@]},$sum"
                echo "$line,$position,$current_substring,$key,${reference[$key]},${chiffres[@]},$sum" >> "matches.csv"
                position=$((position + ${#key}))
                is_key_found=true
                break  # Sortir de la boucle for dès qu'un motif est trouvé
            fi
        done

        # Si aucun motif n'est trouvé, incrémenter la position de 1
        if [ "$is_key_found" == false ]; then
            position=$((position + 1))
        else break
        fi
    done

    reversed_line=$(rev <<< "$line")

    position=0  # Réinitialiser la position pour la chaîne inversée

    while [ "$position" -lt "${#reversed_line}" ]; do
        # Initialiser la sous-chaîne courante à partir de la position actuelle
        current_substring="${reversed_line:$position}"
        is_key_found=false
        # echo "Position : $position, Sous-chaîne actuelle : $current_substring"


        # Vérifier si la sous-chaîne commence par un élément du tableau de référence
        for key in "${!reference[@]}"; do
            # echo "pattern $key"
            reversed_key=$(rev <<< "$key")
            if [[ "$current_substring" = "$reversed_key"* ]]; then
                # Ajouter la valeur associée à la table de référence dans le tableau chiffres
                chiffres+=("${reference[$key]}")
                # echo "Motif trouvé : $key, Ajouté à chiffres : ${reference[$key]}"
                # echo "$reversed_line,$position,$current_substring,$reversed_key,${reference[$key]},${chiffres[@]},$sum"
                echo "$line,$position,$current_substring,$reversed_key,${reference[$key]},${chiffres[@]},$sum" >> "matches.csv"
                position=$((position + ${#key}))
                is_key_found=true
                break  # Sortir de la boucle for dès qu'un motif est trouvé
            fi
        done

        # Si aucun motif n'est trouvé, incrémenter la position de 1
        if [ "$is_key_found" == false ]; then
            position=$((position + 1))
        else break
        fi
    done

    # echo "chiffres ${chiffres[@]}"

    # Nouveau chiffre est la concaténation du premier et dernier élément du tableau chiffres
    if [ "${#chiffres[@]}" -gt 0 ]; then
        # Nouveau chiffre est la concaténation du premier et dernier élément du tableau chiffres
        nouveau_chiffre="${chiffres[0]}${chiffres[-1]}"

        # Ajouter à la somme totale
        sum=$((sum + nouveau_chiffre))
        # echo "Nouveau chiffre ajouté à la somme : $nouveau_chiffre"
    fi

done < "$input_file"
# Afficher la somme totale
echo "Somme: $sum"

