#!/bin/bash
#Rota el enlace /usr/share/backgrounds/default a otro fichero de fondo de pantalla

d=~/Pictures/wallpapers/
b="$d"/default


r=$(($RANDOM%$(ls "$d"/*.[jpJP][npNP][gG] | wc -l)))
i=0

for f in "$d"/*.[jpJP][npNP][gG]
do
[ "$(basename "$f")" == "$(basename "$b")" ] && continue;
if [ $i -eq $r ]; then break; fi
i=$((i+1))
done

ln -sf "$f" "$b"

