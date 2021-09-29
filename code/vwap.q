

// @Function this is used to calculate the condational vwap for client order
// @Param co - table -  client order table 
// @Param mt - table -  market trade  table
// @return - table - column - id sym start end vwap 
// @Example 
   // clientorder:([]id:`long$();version:`int$();sym:`$();time:`timestamp$();side:`$();limit:`float$();start:`timestamp$();end:`timestamp$());
   //markettrade:([]sym:`$();time:`timestamp$();price:`float$();volume:`long$());
   //.vwap.CalCondVWAP[clientorder;markettrade] 
.vwap.CalCondVWAP:{[co;mt]
   if[not 98h=type co;:`$"expected client order type -  Table" ];
   if[not 98h=type mt;:`$"expected market trade type -  Table" ];
   if[0=count co;:`NoOrder];
   res:select any differ[first limit ;limit],first sym,start,end,first time by id from co;
   res:select id,sym,{?[x;last y;first y]}'[limit;start],{?[x;last y;first y]}'[limit;end],time from res;
   w:(res[`start];res[`end]);
   mt:update `p#sym from `sym xasc mt;
   select id,sym,start,end,vwap:price from wj1[w;`sym`time;res;(mt;(wavg;`volume;`price))]
 };
