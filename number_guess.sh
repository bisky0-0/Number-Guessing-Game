#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=number_guess -t --no-align -c"
RND=$((1+ RANDOM % 1000))



GUESSING(){
if [[ $1 ]]
  then 
  echo -e "$1\nGuess the secret number between 1 and 1000:\n"
fi  
read GUSSSED_NUM

if [[ ! $GUSSSED_NUM =~ ^[0-9]+$ ]]
  then 
     GUESSING "That is not an integer, guess again:"
elif [[ $GUSSSED_NUM -gt $RND ]]
   then  GUESSING "It's lower than that, guess again:"     
 elif [[ $GUSSSED_NUM -lt $RND ]]
  then GUESSING "It's higher than that, guess again:"  
 else 
   echo "You guessed it in <number_of_guesses> tries. The secret number was <secret_number>. Nice job!"   
fi    
}     


  

echo -e "Enter your username:\n"

read USERNAME
 NAME_EXISTENT=$($PSQL "SELECT username FROM users WHERE username='$USERNAME'")
  if [[ -z $NAME_EXISTENT ]]
    then
       echo "Welcome, $USERNAME! It looks like this is your first time here."
       INSERT_RESULT=$($PSQL "INSERT INTO users(username) values('$USERNAME')")

       echo -e "\n Guess the secret number between 1 and 1000:\n"
       GUESSING
    else 
       echo "Welcome back, <username>! You have played <games_played> games, and your best game took <best_game> guesses."
       GUESSING
  fi     

