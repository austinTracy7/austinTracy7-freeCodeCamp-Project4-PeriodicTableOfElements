#!/bin/bash

if [ -z $1 ]
then
  OUTPUT='Please provide an element as an argument.'
elif [[ $1 =~ [0-9]+ ]]
then
  PSQL='psql --username=freecodecamp --dbname=periodic_table -c'
  RESPONSE=$($PSQL "SELECT 'The element with atomic number ' || atomic_number || ' is ' || name || ' (' || symbol ||'). It''s a ' || type  || ', with a mass of ' || atomic_mass || ' amu. ' || name || ' has a melting point of ' || melting_point_celsius || ' celsius and a boiling point of ' || boiling_point_celsius || ' celsius.' FROM elements LEFT JOIN properties USING(atomic_number) LEFT JOIN types USING(type_id) WHERE atomic_number = $1 ;")
  OUTPUT=$(sed -e 's/.column.[[:space:]]//' <<< "$RESPONSE")
  OUTPUT=$(sed -e 's/---//g' <<< $OUTPUT)
  OUTPUT=$(sed -e 's/--//g' <<< $OUTPUT)
  OUTPUT=$(sed -e 's/.1 row.$//g' <<< $OUTPUT)
  OUTPUT=$(sed -e 's/[[:space:]]*$//'<<<$OUTPUT)
  OUTPUT=$(sed -e 's/^[[:space:]]*//'<<<$OUTPUT)
elif (( $(wc -m <<< "$1") < 4 ))
then
  PSQL='psql --username=freecodecamp --dbname=periodic_table -c'
  RESPONSE=$($PSQL "SELECT 'The element with atomic number ' || atomic_number || ' is ' || name || ' (' || symbol ||'). It''s a ' || type  || ', with a mass of ' || atomic_mass || ' amu. ' || name || ' has a melting point of ' || melting_point_celsius || ' celsius and a boiling point of ' || boiling_point_celsius || ' celsius.' FROM elements LEFT JOIN properties USING(atomic_number) LEFT JOIN types USING(type_id) WHERE symbol = '$1' ;")
  OUTPUT=$(sed -e 's/.column.[[:space:]]//' <<< "$RESPONSE")
  OUTPUT=$(sed -e 's/---//g' <<< $OUTPUT)
  OUTPUT=$(sed -e 's/--//g' <<< $OUTPUT)
  OUTPUT=$(sed -e 's/.1 row.$//g' <<< $OUTPUT)
  OUTPUT=$(sed -e 's/[[:space:]]*$//'<<<$OUTPUT)
  OUTPUT=$(sed -e 's/^[[:space:]]*//'<<<$OUTPUT)
  
else
  PSQL='psql --username=freecodecamp --dbname=periodic_table -c'
  RESPONSE=$($PSQL "SELECT 'The element with atomic number ' || atomic_number || ' is ' || name || ' (' || symbol ||'). It''s a ' || type  || ', with a mass of ' || atomic_mass || ' amu. ' || name || ' has a melting point of ' || melting_point_celsius || ' celsius and a boiling point of ' || boiling_point_celsius || ' celsius.' FROM elements LEFT JOIN properties USING(atomic_number) LEFT JOIN types USING(type_id) WHERE name = '$1' ;")
  OUTPUT=$(sed -e 's/.column.[[:space:]]//' <<< "$RESPONSE")
  OUTPUT=$(sed -e 's/---//g' <<< $OUTPUT)
  OUTPUT=$(sed -e 's/--//g' <<< $OUTPUT)
  OUTPUT=$(sed -e 's/.1 row.$//g' <<< $OUTPUT)
  OUTPUT=$(sed -e 's/[[:space:]]*$//'<<<$OUTPUT)
  OUTPUT=$(sed -e 's/^[[:space:]]*//'<<<$OUTPUT)
fi

# fixing the output for 0 rows
if [[ $OUTPUT =~ "(0 rows)" ]]
then
  OUTPUT='I could not find that element in the database.'
fi
  echo $OUTPUT
