#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=number_guess -t --no-align -c"
RND=$((1+ RANDOM % 1000))




  

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

