MQ4
---

These scripts can be used by the MetaTrader system to build executables that provide information
on the GAP risk associated with a particular symbol:

S_GapAnalysis
-------------

This script goes through all of the candles in the chart that the script is run against to find
the following:
i) The maximum value of [ High(t) - Low(t) ] / Mid(t)
ii) The maximum value of [ Open(t) - Close(t-1) ] / Close(t-1)

It is not possible to properly analse the GAP risk within a candlestick chart because it does not
have the tick data present, but these should give an indication of the worst case Jump that was
possible.

S_GapRisk
---------

This scipt calculates the GAP risk associated with a 10%, 20%, 40% and 100% jump.

When the profit and account currency are not the same, the TickValue can change quite rapidly
due to the foreign exchange rate impacting the risk.