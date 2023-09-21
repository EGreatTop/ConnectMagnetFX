//+------------------------------------------------------------------+
//|                                              ConnectMagnetFX.mq4 |
//|                                  Copyright 2023, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2022, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict

double CurrPrice;
int MagicNumberSELL1 = 111111;
int MagicNumberBUY4 = 444444; 
double StopLoss;
double lotSize;
double LotSize = 0; 
int orderID; 
double OpenPrice; double StopLossPrice; double TakeProfitPrice; 
int orderModified;
double RSI_CloseValue; double RSIValue;
double RSITrigger = 2; double BUYCutOFF; double SELLCutOFF;
int TradeActive; int counterUp = 0; int getMinuteUp; int counterDown = 0; int getMinuteDown; int counterTrade;
int counterTradeKEEP; int ReverseKEEP; int hour; int minute;
double StopAt1000; double ReverseLastValueKEEP = 0; double PriceDiffTrade;

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---
   
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---
   
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
//---
      RSIValue();
      RSIStatus();
      RunTrade();
      ModifyOrder1();
  }
//+------------------------------------------------------------------+

void RSIValue()
{
   RSI_CloseValue = iRSI(NULL,0,14,PRICE_CLOSE,0);
   RSIValue = RSI_CloseValue;
}  

void RSIStatus()
{
   CurrPrice = iClose(NULL,PERIOD_H1,0);
   if(RSI_CloseValue >= 74)
   {
      RSITrigger = 0;
      hour = Hour();  minute = Minute(); 
      Alert("RSITrigger: " + RSITrigger);
   }
   else if(RSI_CloseValue <= 26)
   {
      RSITrigger = 1;
      hour = Hour();  minute = Minute(); 
      Alert("RSITrigger: " + RSITrigger);
   }
}


void RunTrade()
{
   CurrPrice = iClose(NULL,PERIOD_H1,0);
   counterTrade = counterTrade + 1;
   if(RSITrigger == 0 && CurrPrice < LastValue50)
   {
      PriceDIFF = LastValue50 - CurrPrice;
      Alert("PriceDIFF: "+ PriceDIFF);
      if(PriceDIFF <= 10.0)
      {        
         if(OrdersTotal() == 1)       
         {
            if(TradeActive == 1)
            { 
               int getHour = Hour(); int getMinute = Minute();
               if(hour == 23 && getHour >= 0)
               {
                  if(High[1] < LastValue50 && Low[1] < LastValue50 && CurrPrice < High[1])
                  { 
                     StopLoss = LastValue50 + 0.3;
                     SELLTradeOne();
                     TradeActive = 0;
                     hour = Hour();
                  }
               }
               else if(getHour > hour)
               {                  
                  if(High[1] < LastValue50 && Low[1] < LastValue50 && CurrPrice < High[1])
                  {                     
                     StopLoss = LastValue50 + 0.3;
                     SELLTradeOne();
                     TradeActive = 0;  
                     hour = Hour();      
                  }
               }
            }
         }
         else if(OrdersTotal() == 0)
         {
            int getHour = Hour(); int getMinute = Minute();
            if(hour == 23 && getHour >= 0)
            {
               if(High[1] < LastValue50 && Low[1] < LastValue50 && CurrPrice < High[1])
               { 
                  StopLoss = LastValue50 + 0.3;
                  SELLTradeOne();
                  TradeActive = 0;
                  hour = Hour();
               }
            }
            else if(getHour > hour)
            {
               if(High[1] < LastValue50 && Low[1] < LastValue50 && CurrPrice < High[1])
               {
                  StopLoss = LastValue50 + 0.3;
                  SELLTradeOne();
                  TradeActive = 0;
                  hour = Hour(); 
               }
            }
         }
      }
   }
   else if(RSITrigger == 1 && CurrPrice > LastValue50)
   { 
      PriceDIFF = CurrPrice - LastValue50;
      if(PriceDIFF <= 10.0)
      {        
         if(OrdersTotal() == 1)       
         {
            if(TradeActive == 0)
            { 
               int getHour = Hour(); int getMinute = Minute();
               if(hour == 23 && getHour >= 0)
               {
                  if(Low[1] > LastValue50 && High[1] > LastValue50 && CurrPrice > Low[1])
                  { 
                     StopLoss = LastValue50 - 0.3;
                     BUYTradeFour();
                     TradeActive = 1;
                     hour = Hour();
                  }
               }
               else if(getHour > hour)
               {
                  if(Low[1] > LastValue50 && High[1] > LastValue50 && CurrPrice > Low[1])
                  {                     
                     StopLoss = LastValue50 - 0.3;
                     BUYTradeFour();
                     TradeActive = 1;
                     hour = Hour();
                  }
               }
            }
         }
         else if(OrdersTotal() == 0)
         {
            int getHour = Hour(); int getMinute = Minute();
            if(hour == 23 && getHour >= 0)
            {
               if(Low[1] > LastValue50 && High[1] > LastValue50 && CurrPrice > Low[1])
               { 
                     StopLoss = LastValue50 - 0.3;
                     BUYTradeFour();
                     TradeActive = 1;
                     hour = Hour();
               }
            }
            else if(getHour > hour)
            {
               if(Low[1] > LastValue50 && High[1] > LastValue50 && CurrPrice > Low[1])
               {
                  StopLoss = LastValue50 - 0.3;
                  BUYTradeFour();
                  TradeActive = 1;
                  hour = Hour();
               }
            }
         }
      }
   }
}

void RunTrade2()
{
   CurrPrice = iClose(NULL,PERIOD_H1,0);
   counterTrade = counterTrade + 1;
   if(CurrPrice < LastValue25)
   {
      PriceDIFF = CurrPrice - LastValue25;
      if(PriceDIFF <= 10.0)
      {        
         if(OrdersTotal() == 1)       
         {
            if(TradeActive == 1)
            { 
               int getHour = Hour(); int getMinute = Minute();
               if(hour == 23 && getHour >= 0)
               {
                  if(Open[2] > Close[2] && Open[1] > Close[1] && CurrPrice < Low[1])
                  {
                     Alert("Buy Modify Trigger 1"); 
                     StopLoss = LastValue25 + 0.3;
                     SELLTradeOne();
                     TradeActive = 0;
                  }
               }
               else if(getHour > hour)
               {
                  if(Open[2] > Close[2] && Open[1] > Close[1] && CurrPrice < Low[1])
                  {
                     Alert("Buy Modify Trigger 2");
                     StopLoss = LastValue25 + 0.3;
                     SELLTradeOne();
                     TradeActive = 0;               
                  }
               }
            }
         }
      }
   }
   else if(CurrPrice > LastValue25)
   { 
      PriceDIFF = CurrPrice - LastValue25;
      if(PriceDIFF <= 10.0)
      {        
         if(OrdersTotal() == 1)       
         {
            if(TradeActive == 0)
            { 
               int getHour = Hour(); int getMinute = Minute();
               if(hour == 23 && getHour >= 0)
               {
                  if(Open[2] < Close[2] && Open[1] < Close[1] && CurrPrice > High[1])
                  { 
                     Alert("Sell Modify Trigger 1");
                     StopLoss = LastValue25 - 0.3;
                     BUYTradeFour();
                     TradeActive = 1;
                  }
               }
               else if(getHour > hour)
               {
                  if(Open[2] < Close[2] && Open[1] < Close[1] && CurrPrice > High[1])
                  {
                     Alert("Sell Modify Trigger 1");
                     StopLoss = LastValue25 - 0.3;
                     BUYTradeFour();
                     TradeActive = 1;               
                  }
               }
            }
         }
      }
   }
}

void SELLTradeOne()
{   
   StopLoss = LastValue50 + 0.3; 
   lotSize = LotSize;
   orderID = OrderSend(NULL,OP_SELL,lotSize,Bid,2,StopLoss,Bid - 150.0,"XAUUSD",MagicNumberSELL1);
   if(orderID < 0)
   {
      Alert("Order ID (XAUUSD) is: " + GetLastError());
   }
   else
   {
      LastValueKEEP = LastValue50;
      Price5 = Bid + 0.2;
      Price30 = Bid - 3.0;
      Price50 = Bid - 5.0;
      Price90 = Bid - 9.0;
      Price100 = Bid - 10.0;
      Price150 = Bid - 15.0;
      Price200 = Bid - 20.0;
      Price300 = Bid - 30.0;
      StopAt1000 = Bid - 120.0;
      Alert("Trade Type Taken (XAUUSD) is Sell, Order ID is : " + orderID);
   }
}

void SELLTradeTwo()
{
   CalculateLotSize(StopLoss);
   lotSize = LotSize;
   orderID = OrderSend(NULL,OP_SELL,lotSize,Bid,2,StopLoss,Bid - 60.0,"XAUUSD",MagicNumberSELL2);
   if(orderID < 0)
   {
      Alert("Order ID (XAUUSD) is: " + GetLastError());
   }
   else
   {
      Alert("Trade Type Taken (XAUUSD) is Sell, Order ID is : " + orderID);
   }
}

void SELLTradeThree()
{
   CalculateLotSize(StopLoss);
   lotSize = LotSize;
   orderID = OrderSend(NULL,OP_SELL,lotSize,Bid,2,StopLoss,Bid - 60.0,"XAUUSD",MagicNumberSELL3);
   if(orderID < 0)
   {
      Alert("Order ID (XAUUSD) is: " + GetLastError());
   }
   else
   {
      Alert("Trade Type Taken (XAUUSD) is Sell, Order ID is : " + orderID);
   }
}

void BUYTradeFour()
{
   StopLoss = LastValue50 - 0.3;
   lotSize = LotSize;
   orderID = OrderSend(NULL,OP_BUY,lotSize,Ask,2,StopLoss,Ask + 150.0,"XAUUSD", MagicNumberBUY4);
   if(orderID < 0)
   {
      Alert("Order ID (XAUUSD) is: " + GetLastError());
   }
   else
   {
      Alert("Trade Type Taken (XAUUSD) is Buy, Order ID is : " + orderID);
   }
}

void BUYTradeFive()
{     
   CalculateLotSize(StopLoss);
   lotSize = LotSize;
   orderID = OrderSend(NULL,OP_BUY,lotSize,Ask,2,StopLoss,Ask + 60.0,"XAUUSD", MagicNumberBUY5);
   if(orderID < 0)
   {
      Alert("Order ID (XAUUSD) is: " + GetLastError());
   }
   else
   {
      Alert("Trade Type Taken (XAUUSD) is Buy, Order ID is : " + orderID);
   }
}

void CloseTradeBUY()
{
   for(int i = 0; i < OrdersTotal(); i++)
   {
      if(OrderSelect(i, SELECT_BY_POS, MODE_TRADES)==true)
      {
         int getOrder = OrderTicket(); //OrderOpenPrice();
         if(getOrder > 0)
         {
            StopLoss = OrderStopLoss();
            lotSize = LotSize;
            CurrPrice = iClose(NULL,PERIOD_H1,0);
            if(OrderType() == OP_BUY)
            {
               OrderClose(getOrder,lotSize,OrderClosePrice(),10);
            }
         }
      }    
   }   
}

void CloseTradeSELL()
{
   for(int i = 0; i < OrdersTotal(); i++)
   {
      if(OrderSelect(i, SELECT_BY_POS, MODE_TRADES)==true)
      {
         int getOrder = OrderTicket(); //OrderOpenPrice();
         if(getOrder > 0)
         {
            StopLoss = OrderStopLoss();
            lotSize = LotSize;
            CurrPrice = iClose(NULL,PERIOD_H1,0);
            if(OrderType() == OP_SELL)
            {
               OrderClose(getOrder,lotSize,OrderClosePrice(),10);
            }
         }
      }    
   }   
}

void ModifyOrder1()
{
   CurrPrice = iClose(NULL,PERIOD_H1,0);
   
   for(int i = 0; i < OrdersTotal(); i++)
   {
      if(OrderSelect(i, SELECT_BY_POS, MODE_TRADES))
      {
         if(OrderSymbol() == Symbol())
         {
            RefreshRates();
            
            //Get the open Price
            OpenPrice = OrderOpenPrice();
            StopLossPrice = OrderStopLoss();
            TakeProfitPrice = OrderTakeProfit();
            
            if(OrderType() == OP_SELL && CurrPrice <= Price100)
            {     
               if(Price100 > 0)
               {                
                  if(StopLossPrice <= OpenPrice - 1.0)
                  { }
                  else
                  {  
                     if(OrderModify(OrderTicket(), OpenPrice, OpenPrice - 1.0, TakeProfitPrice, OrderExpiration()))
                     {                  
                        orderModified++;
                     }
                  }
               }               
            }
            else if(OrderType() == OP_BUY && CurrPrice >= Price100)
            { 
               if(Price100 > 0)
               {
                  if(StopLossPrice >= OpenPrice + 1.0)
                  { }
                  else  
                  {            
                     if(OrderModify(OrderTicket(), OpenPrice, OpenPrice + 1.0, TakeProfitPrice, OrderExpiration()))
                     {                  
                        orderModified++;
                     }
                  }
               }
            }            
         }
      }
      else
      {
         Print("Failed to select the order: ", GetLastError());
      }
   }
}