#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi
TEAMS="teams";
GAMES="games";\

# Do not change code above this line. Use the PSQL variable above to query your database.
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WIN_GOALS OPP_GOALS
do
  if [[ $YEAR != "year" ]] && [[ $ROUND != "round" ]] && [[ $WINNER != "winner" ]] && [[ $OPPONENT != "opponent" ]] && [[ $WIN_GOALS != "winner_goals" ]] && [[ $OPP_GOALS != "opponent_goals" ]]
  then
    WINNER_ID=$($PSQL "SELECT team_id FROM $TEAMS WHERE name='$WINNER'")
    if [[ -z $WINNER_ID ]]
    then
      INSERT_TEAM_RESULT=$($PSQL "INSERT INTO $TEAMS(name) VALUES('$WINNER')")
      WINNER_ID=$($PSQL "SELECT team_id FROM $TEAMS WHERE name='$WINNER'")
      if [[ $INSERT_TEAM_RESULT == "INSERT 0 1" ]]
      then 
        echo Inserted into $TEAMS, $WINNER, $WINNER_ID
      fi
    fi
    OPPONENT_ID=$($PSQL "SELECT team_id FROM $TEAMS  WHERE name='$OPPONENT'")
    if [[ -z $OPPONENT_ID ]]
    then
      INSERT_TEAM_RESULT=$($PSQL "INSERT INTO $TEAMS (name) VALUES('$OPPONENT')")
      OPPONENT_ID=$($PSQL "SELECT team_id FROM $TEAMS  WHERE name='$OPPONENT'")
      if [[ $INSERT_TEAM_RESULT == "INSERT 0 1" ]]
      then 
        echo Inserted into $TEAMS, $OPPONENT, $OPPONENT_ID
      fi
    fi
    INSERT_OPPONENT_RESULT=$($PSQL "INSERT INTO $GAMES(year, round, winner_goals, opponent_goals, winner_id, opponent_id) VALUES('$YEAR','$ROUND','$WIN_GOALS','$OPP_GOALS','$WINNER_ID','$OPPONENT_ID')")
    if [[ $INSERT_TEAM_RESULT == "INSERT 0 1" ]]
    then 
      echo Inserted into $GAMES, $YEAR, $ROUND
    fi
  fi
done
