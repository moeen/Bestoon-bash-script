#!/bin/bash

TOKEN_REQ(){
  if [ ! -f $HOME/.bestoon_config.txt ]
  then
    read -p "Please enter your bestoon token : " TOKEN
    read -p "Do you want to save it for next use(yes/no)? " AWNSER_TOKEN
    if [ $AWNSER_TOKEN == "yes" ]
      then
        echo "$TOKEN" > $HOME/.bestoon_config.txt
      else
        echo
        echo "OK!"
    fi
  else
    TOKEN=`cat $HOME/.bestoon_config.txt`
fi }

while getopts "iehga:t:" options
  do
    case "$options" in
      i)
        TOKEN_REQ
        TYPE="income" ;;
      e)
        TOKEN_REQ
        TYPE="expense" ;;
      a)
        TOKEN_REQ
        AMOUNT="$OPTARG" ;;
      t)
        TOKEN_REQ
        TEXT="$OPTARG" ;;
      g)
        TOKEN_REQ
        curl --data "token=$TOKEN" http://bestoon.ir/q/generalstat/
        exit 0 ;;
      h)
        echo -e "Bestoon script help\nBestoon website : http://www.bestoon.ir\nBestoon source page : https://github.com/jadijadi/bestoon\nBestoon script source page : https://github.com/moeinroid/Bestoon-bash-script\nUse -i for your income\nUse -e for your expenses\n(NOTE : DONT USE -i AND -e TOGETHER!)\nUse -a for your amount\nUse -t for your income/expense text\nUse -g to show your generalstat\nAnd Use -h for help\nThanks for using BESTOON ;)"
        exit 0 ;;
    esac
done

if [ ! -z $TYPE ]
  then
    if [ ! -z $AMOUNT ]
      then
          if [ ! -z $TEXT ]
            then
              curl --data "token=$TOKEN&amount=$AMOUNT&text=$TEXT" http://bestoon.ir/submit/$TYPE/
            else
              echo "Please enter your income/expense text with -t"
          fi
      else
        echo "Please enter your amount with -a"
    fi
  else
    echo "Please choose income or expense with -i or -e"
fi
