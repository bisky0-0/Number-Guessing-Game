#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=number_guess -t --no-align -c"
RND=$((1+ RANDOM % 1000))

COUNT=0

GUESSING(){
if [[ $1 ]]
  then 
  echo -e "$1"
fi  
echo "Guess the secret number between 1 and 1000:"
read GUSSSED_NUM
if [[ ! $GUSSSED_NUM =~ ^[0-9]+$ ]]
  then 
     GUESSING "That is not an integer, guess again:"
elif [[ $GUSSSED_NUM -gt $RND ]]
   then  
   $COUNT=$((COUNT + 1))
   GUESSING "\nIt's lower than that, guess again:"     
 elif [[ $GUSSSED_NUM -lt $RND ]]
  then 
  $COUNT=$((COUNT + 1))
  GUESSING "\nIt's higher than that, guess again:"  
 else 
   echo "You guessed it in <number_of_guesses> tries. The secret number was <secret_number>. Nice job!"   
fi    
}     

  
echo -e "Enter your username:"
read USERNAME
 NAME_EXISTENT=$($PSQL "SELECT username, games_count, best_game FROM users WHERE username='$USERNAME'")
  if [[ -z $NAME_EXISTENT ]]
    then
       echo -e "\nWelcome, $USERNAME! It looks like this is your first time here."
       GUESSING
       $($PSQL "INSERT INTO users(username, game_count, best_game) values($USERNAME, $COUNT, $COUNT)")
    else 
    echo $NAME_EXISTENT | while IFS='|' read NAME, GAMES, BEST 
    do
       echo -e "\nWelcome back, $USERNAME! You have played $GAMES games, and your best game took BEST guesses."
       GUESSING
       if [[ $BEST -lt $COUNT ]]
       then
       $($PSQL "update users set game_count = $COUNT+1  best_game=$COUNT")
       else
       $($PSQL "update users set game_count = $COUNT+1")
  fi   
  done
  fi

  



