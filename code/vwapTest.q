system "d .vwapTest";

beforeNamespaceOveride:{

 };

setUpMock:{
   .vwapTest.clientorder:([]id:`long$();version:`int$();sym:`$();time:`timestamp$();side:`$();limit:`float$();start:`timestamp$();end:`timestamp$());
   .vwapTest.markettrade:([]sym:`$();time:`timestamp$();price:`float$();volume:`long$());
 };

testColumn:{
   show "hello";
   t:.z.p;
   `.vwapTest.clientorder insert (16;1i;`ORAC;.z.p;`B;1000.0;t-00:30:00;t-00:20:00);
   `.vwapTest.markettrade insert(4#`ORAC;t-00:35:00 00:25:00 00:22:00 00:15:00;5 8 10 12f;3 5 8 15); 
   `.vwapTest.markettrade insert(4#`GOOG;t-00:35:00 00:25:00 00:22:00 00:15:00;5 8 10 12f;13 15 18 20);
    res:.vwap.CalCondVWAP[.vwapTest.clientorder;.vwapTest.markettrade];  
    .qunit.assertEquals[cols res;`id`sym`start`end`vwap ; "Column should match"];
 };

testVwap:{
  t:.z.p;
  `.vwapTest.clientorder insert (16;1i;`ORAC;.z.p;`B;1000.0;t-00:30:00;t-00:20:00);
  `.vwapTest.markettrade insert(4#`ORAC;t-00:35:00 00:25:00 00:22:00 00:15:00;5 10 15 20f;5 10 15 20);
  res:.vwap.CalCondVWAP[.vwapTest.clientorder;.vwapTest.markettrade];
  expected:enlist `id`sym`start`end`vwap!(16;`ORAC;t-00:30:00;t-00:20:00;13f);
  .qunit.assertEquals[res;expected ; "Vwap calculation"];
 };

