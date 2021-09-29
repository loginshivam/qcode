
/clientorder:([]id:`long$();version:`int$();sym:`$();time:`timestamp$();side:`$();limit:`float$();start:`timestamp$();end:`timestamp$());
/markettrade:([]sym:`$();time:`timestamp$();price:`float$();volume:`long$());

// @Function this is used to calculate the condational vwap for client order
// @Param co - table -  client order table 
// @Param mt - table -  market trade  table
// @return - table 
// @Example 

.vwap.CalCondVWAP:{[co;mt]
   res:select any differ[first limit ;limit],first sym,start,end,first time by id from co;
   res:select id,sym,{?[x;last y;first y]}'[limit;start],{?[x;last y;first y]}'[limit;end],time from res;
   w:(res[`start];res[`end]);
   mt:update `p#sym from `sym xasc mt;
   select id,sym,start,end,vwap:price from wj1[w;`sym`time;res;(mt;(wavg;`volume;`price))]
 };
