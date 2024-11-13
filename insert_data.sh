#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
csv_file='games.csv'

while IFS=, read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  if [[ $YEAR != 'year' ]]
  then
    echo $WINNER
    TEAM_ID=$($PSQL "select team_id from teams where name='$WINNER'")
    if [[ -z $TEAM_ID  ]]
    then
      echo -e '\nEmpty'
      INSERT_TEAM_ID=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")

      if [[ $INSERT_TEAM_ID == 'INSERT 0 1' ]]
      then
        echo 'Inserted '$WINNER' into teams database'
      fi
    else
      echo '$TEAM_ID'
    fi


    TEAM_ID=$($PSQL "select team_id from teams where name='$OPPONENT'")
    if [[ -z $TEAM_ID  ]]
    then
      echo -e '\nEmpty'
      INSERT_TEAM_ID=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")

      if [[ $INSERT_TEAM_ID == 'INSERT 0 1' ]]
      then
        echo 'Inserted '$OPPONENT' into teams database'
      fi
    else
      echo '$TEAM_ID'
    fi

    WINNER_ID=$($PSQL "select team_id from teams where name='$WINNER'")
    OPPONENT_ID=$($PSQL "select team_id from teams where name='$OPPONENT'")

    GAMES_ROW= $($PSQL "select * from games where year=$YEAR AND round='$ROUND' AND winner_id=$WINNER_ID AND opponent_id=$OPPONENT_ID AND winner_goals=$WINNER_GOALS AND opponent_goals=$OPPONENT_GOALS")
    if [[ -z $GAMES_ROW  ]]
    then
      echo -e '\nEmpty'
      
      INSERT_GAMES=$($PSQL "INSERT INTO games(year,round,winner_id,opponent_id,winner_goals,opponent_goals) VALUES($YEAR,'$ROUND',$WINNER_ID,$OPPONENT_ID,$WINNER_GOALS,$OPPONENT_GOALS)")
      if [[ $INSERT_TEAM_ID == 'INSERT 0 1' ]]
      then
        echo 'Inserted '$YEAR' into games database'
      fi
    else
      echo '$TEAM_ID'
    fi


  fi
done < "$csv_file"
