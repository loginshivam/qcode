clientorder:([]id:`long$();version:`int$();sym:`$();time:`timestamp$();side:`$();limit:`float$();start:`timestamp$();end:`timestamp$());
markettrade:([]sym:`$();time:`timestamp$();price:`float$();volume:`long$());

t:.z.p;
`clientorder insert (9;1i;`MSFT;.z.p;`B;1000.0;t-00:10:00;t);
`markettrade insert (6#`MSFT;t-desc 6?00:12:00;6#10.0;10 20 30 40 50 60);

`clientorder insert (10;1i;`MSFT;.z.p;`B;1040.0;t-00:08:00;t+00:05);
`clientorder insert (11;1i;`MSFT;.z.p;`B;3000.0;.z.p-00:10:00;.z.p);
`clientorder insert (11;2i;`MSFT;.z.p;`B;3000.0;.z.p-00:10:00;.z.p);
`clientorder insert (12;1i;`GOOG;.z.p;`B;5000.0;.z.p-00:10:00;.z.p);
`clientorder insert (13;1i;`GOOG;.z.p;`B;6000.0;.z.p-00:10:00;.z.p);
`clientorder insert (14;1i;`MSFT;.z.p;`B;7000.0;.z.p-00:10:00;.z.p);
`clientorder insert (15;1i;`MSFT;.z.p;`B;1000.0;.z.p-00:10:00;.z.p);

t:.z.p;
`clientorder insert (16;1i;`ORAC;.z.p;`B;1000.0;t-00:30:00;t-00:20:00);
`markettrade insert(4#`ORAC;t-00:35:00 00:25:00 00:22:00 00:15:00;5 8 10 12f;3 5 8 15);

`clientorder insert (17;1i;`GOOG;.z.p;`B;1000.0;.z.p-00:10:00;.z.p);
`clientorder insert (17;2i;`GOOG;.z.p;`B;2000.0;.z.p-00:10:00;.z.p);
`clientorder insert (17;3i;`GOOG;.z.p;`B;3000.0;.z.p-00:07:00;.z.p+00:05:00);

t:.z.d;
`clientorder insert (17;4i;`GOOG;.z.p;`B;4000.0;t-00:04:00;t+00:10:00);
`markettrade insert(8#`GOOG;t-asc 8?00:15:00;8#10.0;5 15 25 35 45 55 65 75);

`clientorder insert (18;1i;`MSFT;.z.p;`B;1000.0;.z.p-00:10:00;.z.p);
`clientorder insert (19;1i;`MSFT;.z.p;`B;1000.0;.z.p-00:10:00;.z.p);
`clientorder insert (20;1i;`MSFT;.z.p;`B;1000.0;.z.p-00:10:00;.z.p);


 res:select any differ[first limit ;limit],first sym,start,end,first time by id from clientorder;
   res:select id,sym,{?[x;last y;first y]}'[limit;start],{?[x;last y;first y]}'[limit;end],time from res;
   w:(res[`start];res[`end]);
   markettrade:update `p#sym from `sym xasc markettrade;
/res1:select from res where id in 9 11 16 17;  
t: select id,sym,start,end,vwap:price from wj1[w;`sym`time;res;(markettrade;(wavg;`volume;`price))];


.price.CalCondVWAP:{[co;mt]
   res:select any differ[first limit ;limit],first sym,start,end,first time by id from co;
   res:select id,sym,{?[x;last y;first y]}'[limit;start],{?[x;last y;first y]}'[limit;end],time from res;
   w:(res[`start];res[`end]); 
   mt:update `p#sym from `sym xasc mt; 
   select id,sym,start,end,vwap:price from wj1[w;`sym`time;res;(mt;(wavg;`volume;`price))]
 };
