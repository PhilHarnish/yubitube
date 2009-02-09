#!/bin/sh

case "$1" in
test*)
  CP="-cp ../lib/asunit/as25/ -cp ../test/"
  OUT="../test/RunTests.swf"
  MAIN="AllTests.as"
  ;;
*)
  CP=""
  OUT="../web/latest.swf"
  MAIN="Main.as"
  ;;
esac

mtasc -swf $OUT\
      -version 8\
      -cp ~/bin/std8/\
      $CP\
      -cp .\
      -header 640:480:20\
      -trace yubi.util.Firebug.out\
      -strict -infer -wimp\
      -main $MAIN

if [ $? != 0 ]; then
  echo "Build failed."
  exit -1
fi

if [ "$1" = "testrun" ] && [ -n "$(which open)" ]; then
  open ../test/RunTests.swf
fi
