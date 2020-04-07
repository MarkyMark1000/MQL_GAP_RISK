//+------------------------------------------------------------------+
//|                                                    S_GapRisk.mq4 |
//|                                                         M Wilson |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "M Wilson"
#property link      "https://www.mql5.com"
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
   
   // Define a set of constants for the GAP size that we are analysing
   const double C_GAP_1 = 0.1;
   const double C_GAP_2 = 0.2;
   const double C_GAP_3 = 0.4;
   const double C_GAP_4 = 1.0;
   
   // Get the spot and the size of the GAP movement
   double dblSpot = 0.5*(MarketInfo(Symbol(),MODE_BID)+MarketInfo(Symbol(),MODE_ASK));
   double dbl_JUMP_1 = dblSpot*C_GAP_1;
   double dbl_JUMP_2 = dblSpot*C_GAP_2;
   double dbl_JUMP_3 = dblSpot*C_GAP_3;
   double dbl_JUMP_4 = dblSpot*C_GAP_4;
   
   // Get the ticksize and tickvalue
   double dblTickSize = MarketInfo(Symbol(), MODE_TICKSIZE);
   double dblTickValue = MarketInfo(Symbol(), MODE_TICKVALUE);
   
   // Check we have a value
   if(dblTickValue <= 0)
   {
      MessageBox("Tick Value is zero, are you running the script out of hours ?");
      return;
   }
   
   // Calculate the loss for a 10%, 20%, 40%, 100% jump.
   double dblLoss_1 = (dbl_JUMP_1/dblTickSize)*dblTickValue;
   double dblLoss_2 = (dbl_JUMP_2/dblTickSize)*dblTickValue;
   double dblLoss_3 = (dbl_JUMP_3/dblTickSize)*dblTickValue;
   double dblLoss_4 = (dbl_JUMP_4/dblTickSize)*dblTickValue;
   
   //Get the profit currency
   string strAccountCurr = AccountCurrency();
   
   // Build the Report - Account Information
   string strResult="ACCOUNT/SYMBOL_INFO: "+Symbol()+"\n\n";
   strResult+="SYMBOL_CURRENCY_PROFIT: "+SymbolInfoString(Symbol(),SYMBOL_CURRENCY_PROFIT)+"\n";
   strResult+="ACCOUNT CURRENCY: "+AccountCurrency()+"\n";
   strResult+="SYMBOL_CURRENCY_BASE: "+SymbolInfoString(Symbol(),SYMBOL_CURRENCY_BASE)+"\n"; 
   strResult+="SYMBOL_CURRENCY_MARGIN: "+SymbolInfoString(Symbol(),SYMBOL_CURRENCY_MARGIN)+"\n\n";
   
   // 1 Lot is 100,000 units of the Base Currency.
   
   // Add Ticksize and TickValue
   strResult+="RISK INFO: \n\n";
   strResult+="MODE_TICKSIZE: "+DoubleToString(MarketInfo(Symbol(), MODE_TICKSIZE),6)+"\n"; 
   strResult+="MODE_TICKVALUE: "+DoubleToString(MarketInfo(Symbol(), MODE_TICKVALUE),6)+"\n\n";
   
   // Add GAP risk to the report
   strResult+="APPROX GAP RISK FOR 1 Lot: \n\n";
   strResult+=DoubleToString(C_GAP_1*100,0)+" % GAP:   " + strAccountCurr + 
            " " + DoubleToString(dblLoss_1,0)+"\n";
   strResult+=DoubleToString(C_GAP_2*100,0)+" % GAP:   " + strAccountCurr +
            " " + DoubleToString(dblLoss_2,0)+"\n";
   strResult+=DoubleToString(C_GAP_3*100,0)+" % GAP:   " + strAccountCurr +
            " " + DoubleToString(dblLoss_3,0)+"\n";
   strResult+=DoubleToString(C_GAP_4*100,0)+" % GAP:   " + strAccountCurr + 
            " " + DoubleToString(dblLoss_4,0)+"\n";
   
   MessageBox(strResult);
   
  }
//+------------------------------------------------------------------+
