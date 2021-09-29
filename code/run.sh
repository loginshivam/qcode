clear
export QHOME=~/kdb/  #set QHOME path
echo "Running Tests"
rlwrap $QHOME/l64/q code/runTest.q
