//+------------------------------------------------------------------+
//|                                            S_GapAnalysis.mq4.mq4 |
//|                                                         M Wilson |
//+------------------------------------------------------------------+
#property copyright "M Wilson"
#property version   "1.00"
#property strict
//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart()
  {

   /*
   
   It is not possible to get the exact GAP risk from historic candlestick
   data as you would need every tick.   It is possible to get a feel for
   the GAP risk by analysing the following:
   i) The maximum [ Open(t) - Close(t-1) ] / Close(t-1)
   ii) The maximum [ High(t) - Low(t) ] / Mid(t)
      (ie a worst case gap event of high to low or low to high)
   
   This script scans through the candles on the active chart and records
   the maximum (high-low)/mid and maximum (open-close)/open
   
   Run this on the smallest timeframe available for the desired index/stock
   etc.
   
   */
   
   double dblMaxHL = 0.0;
   double dblMaxOC = 0.0;
   
   for(int i=0;i<Bars;i++)
   {
      // Cannot process open-close gap for the first candle, so calculate
      // open close gap for all other candles
      if(i<Bars-1)
      {
         double dblOCGap = MathAbs(iOpen(Symbol(),0,i) - iClose(Symbol(),0,i+1))/iClose(Symbol(),0,i+1);
         dblMaxOC = dblOCGap>dblMaxOC ? dblOCGap : dblMaxOC;
      }
      
      // Calculate High/Low gap for all candles
      double dblMid = 0.5*(iHigh(Symbol(),0,i) + iLow(Symbol(),0,i));
      double dblHLGap = (iHigh(Symbol(),0,i) - iLow(Symbol(),0,i))/dblMid;
      dblMaxHL = dblHLGap>dblMaxHL ? dblHLGap : dblMaxHL;
      
   }
   
   // Calculate the maximum of H-L/Mid and C-O/O
   double dblMaxG = dblMaxOC>dblMaxHL ? dblMaxOC : dblMaxHL;

   // Report the results
   string strReport = "Analysis of Historic Gap Risk\n\n";
   strReport += "Max (High-Low)/Mid :        "+DoubleToString(dblMaxHL*100,2)+" %\n";
   strReport += "Max (Open-Close)/Close :   "+DoubleToString(dblMaxOC*100,2)+" %\n\n";
   strReport += "Maximum Historic %:   "+DoubleToString(dblMaxG*100,2)+" %\n\n\n";
   MessageBox(strReport);
   
  }
//+------------------------------------------------------------------+