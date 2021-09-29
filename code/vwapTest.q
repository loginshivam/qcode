system "d .vwapTest";

beforeNamespaceOveride:{

 };

setUpMock:{
   .vwapTest.clientorder:([]id:`long$();version:`int$();sym:`$();time:`timestamp$();side:`$();limit:`float$();start:`timestamp$();end:`timestamp$());
   .vwapTest.markettrade:([]sym:`$();time:`timestamp$();price:`float$();volume:`long$());
 };

testClientOrderCountZero:{
    res:.vwap.CalCondVWAP[.vwapTest.clientorder;.vwapTest.markettrade];
    .qunit.assertEquals[res;`NoOrder ; "Minimumn one client order should be there"];
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

testMultipleVersionIfLimitChange:{
    `.vwapTest.clientorder insert (17;1i;`GOOG;.z.p;`B;1000.0;.z.p-00:10:00;.z.p);
    `.vwapTest.clientorder insert (17;2i;`GOOG;.z.p;`B;2000.0;.z.p-00:10:00;.z.p);
    `.vwapTest.clientorder insert (17;3i;`GOOG;.z.p;`B;3000.0;.z.p-00:07:00;.z.p+00:05:00);

    t:.z.p;
    `.vwapTest.clientorder insert (17;4i;`GOOG;.z.p;`B;4000.0;t-00:04:00;t+00:10:00);
    `.vwapTest.markettrade insert(8#`GOOG;t-desc 8?00:10:00;10 20 25 35 40 50 10 30f;5 15 25 35 45 55 65 75);
     res:.vwap.CalCondVWAP[.vwapTest.clientorder;.vwapTest.markettrade];
     expected:enlist `id`sym`start`end!(17;`GOOG;t-00:04:00;t+00:10:00);
     .qunit.assertEquals[select id,sym,start,end from res;expected ; "market trade for update version will be included if limit changes"];
 };

testMultipleVersionNoLimitChange:{ 
    t:.z.p;
    `.vwapTest.clientorder insert (17;1i;`GOOG;t;`B;1000.0;t-00:02:00;t+00:07:00);
    `.vwapTest.clientorder insert (17;2i;`GOOG;t+00:01:00;`B;1000.0;t+00:10:00;.z.p);
    `.vwapTest.clientorder insert (17;3i;`GOOG;.z.p;`B;1000.0;.z.p-00:07:00;.z.p+00:05:00);
    `.vwapTest.clientorder insert (17;4i;`GOOG;.z.p;`B;1000.0;t-00:04:00;t+00:10:00);
    `.vwapTest.markettrade insert(8#`GOOG;t-desc 8?00:10:00;10 20 25 35 40 50 10 30f;5 15 25 35 45 55 65 75);
     res:.vwap.CalCondVWAP[.vwapTest.clientorder;.vwapTest.markettrade];
     expected:enlist `id`sym`start`end!(17;`GOOG;t-00:02:00;t+00:07:00);
     .qunit.assertEquals[select id,sym,start,end from res;expected ; "include market trade from first version if limit has not changed"];
 };

testMultiSym:{
   t:.z.p;
   `.vwapTest.clientorder insert (16;1i;`ORAC;.z.p;`B;1000.0;t-00:30:00;t-00:20:00);
   `.vwapTest.markettrade insert(4#`ORAC;t-00:35:00 00:25:00 00:22:00 00:15:00;5 8 10 12f;3 5 8 15);
   `.vwapTest.markettrade insert(4#`GOOG;t-00:35:00 00:25:00 00:22:00 00:15:00;5 8 10 12f;13 15 18 20);
   `.vwapTest.clientorder insert (17;4i;`GOOG;.z.p;`B;4000.0;t-00:04:00;t+00:10:00);
  `.vwapTest.markettrade insert(8#`GOOG;t-desc 8?00:10:00;10 20 25 35 40 50 10 30f;5 15 25 35 45 55 65 75);
   res:.vwap.CalCondVWAP[.vwapTest.clientorder;.vwapTest.markettrade];
   expected:flip `id`sym`start`end!(16 17;`ORAC`GOOG;((t-00:30:00); (t-00:04:00));((t-00:20:00); (t+00:10:00)));
   .qunit.assertEquals[select id,sym,start,end from res;expected ; "Multiple sym order"];
 };

testNoMarketData:{
    t:.z.p;
    `.vwapTest.clientorder insert (16;1i;`ORAC;.z.p;`B;1000.0;t-00:30:00;t-00:20:00);
    `.vwapTest.markettrade insert(4#`GOOG;t-00:35:00 00:25:00 00:22:00 00:15:00;5 8 10 12f;13 15 18 20);
    res:.vwap.CalCondVWAP[.vwapTest.clientorder;.vwapTest.markettrade];
    .qunit.assertEquals[null first exec vwap from res;1b; "market data does not exists"];
 };
