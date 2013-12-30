#!/bin/sh

echo "starting game"

curl -d "opponentName=FATBOYSLIMe&pointsToWin=1000&maxRounds=2000&dynamiteCount=100" http://localhost:9393/start

echo "getting first move"

echo $(curl -s http://localhost:9393/move)

echo "playing DYNAMITE"

curl -d "lastOpponentMove=DYNAMITE" http://localhost:9393/move

echo "getting next move (expecting DYNAMITE)"

echo $(curl -s http://localhost:9393/move)

echo "playing SCISSORS"

curl -d "lastOpponentMove=SCISSORS" http://localhost:9393/move

echo $(curl -s http://localhost:9393/move)

echo "playing SCISSORS"

curl -d "lastOpponentMove=SCISSORS" http://localhost:9393/move

echo $(curl -s http://localhost:9393/move)

echo "playing SCISSORS"

curl -d "lastOpponentMove=SCISSORS" http://localhost:9393/move

echo $(curl -s http://localhost:9393/move)