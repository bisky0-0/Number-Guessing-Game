#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=number_guess -t --no-align -c"
RND=$((1+ RANDOM % 1000))

COUNT=0

GUESSING(){
if [[ $1 ]]
  then 
  echo -e "$1"
  else
  echo -e "\nGuess the secret number between 1 and 1000:"
fi  
read GUSSSED_NUM
if [[ ! $GUSSSED_NUM =~ ^[0-9]+$ ]]
  then 
     ((COUNT++))
     GUESSING "\nThat is not an integer, guess again:"
elif [[ $GUSSSED_NUM -gt $RND ]]
   then  
   ((COUNT++))
   GUESSING "\nIt's lower than that, guess again:"     
 elif [[ $GUSSSED_NUM -lt $RND ]]
  then 
  ((COUNT++))
  GUESSING "\nIt's higher than that, guess again:"  
 else
   ((COUNT++))
   echo -e "\nYou guessed it in $COUNT tries. The secret number was $RND. Nice job!"   
fi    
}     

MAIN_MENU(){  
if [[ $1 ]]
then
  echo -e "\n$1"
else 
  echo "Enter your username:"  
fi
read USERNAME
if [[ -z $USERNAME ]]
 then MAIN_MENU "Please Enter your username to start:"
else
 NAME_EXISTENT=$($PSQL "SELECT username, games_played, best_game FROM users WHERE username='$USERNAME'")
  if [[ -z $NAME_EXISTENT ]]
    then
       echo -e "\nWelcome, $USERNAME! It looks like this is your first time here."
       GUESSING
       INSERT_RESULT=$($PSQL "INSERT INTO users(username, games_played, best_game) values('$USERNAME', 1, $COUNT)")
       echo $INSERT_RESULT
    else 
    IFS='|' read NAME GAMES BEST <<< "$NAME_EXISTENT"

       echo -e "\nWelcome back, $NAME! You have played $GAMES games, and your best game took $BEST guesses."
       
       GUESSING
       if [[ $BEST -gt $COUNT ]]
       then
       UPDATE_RESULT=$($PSQL "update users set games_played = games_played+1, best_game = $COUNT WHERE username='$USERNAME'")
       else
       UPDATE_RESULT=$($PSQL "update users set games_played = games_played+1 WHERE username='$USERNAME'")
  fi   
  fi
  fi
}

MAIN_MENU  



