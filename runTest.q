system "c 100 2000";
qFile:getenv `QHOME;
system "l ", qFile, "code/qunit.q";
system "l ", qFile, "code/vwap.q";
system "l ", qFile, "code/vwapTest.q";

.qunit.runTests `.vwapTest;

exit 0
