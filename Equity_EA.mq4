//+------------------------------------------------------------------+
//|                                                      ProjectName |
//|                                      Copyright 2018, CompanyName |
//|                                       http://www.companyname.net |
//+------------------------------------------------------------------+
int maxasize = 10000; // number of balans values for each bar
int asize = 336; // 7days, 30 min TF
double aBalans[1][2];
double gPreviTime = 0;

string gUseIncreaseMartinsFile = "UseIncrease.dat";

int start()

{

   SaveBalans();


}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void SaveBalans()
{
   double tmp1,tmp2,dmp1,dmp2,pr = gUseIncreaseMartinsFlatRate + 1,pr1;
   int s;
   string aa;

   if(bNewBar() == true) {
      Print("iCustom=",iCustom(NULL, 0, "grabli[balans]", 0, 0));

      tmp1 = aBalans[0,0];
      dmp1 = aBalans[0,1];
      aBalans[0,0] = AccountBalance();
      aBalans[0,1] = TimeCurrent();
      tmp2 = aBalans[1,0];
      dmp2 = aBalans[1,1];
      aBalans[1,0] = tmp1;
      aBalans[1,1] = dmp1;

      for(s = 2; s < maxasize; s++, s++) {
         tmp1 = aBalans[s,0];
         dmp1 = aBalans[s,1];
         aBalans[s,0] = tmp2;
         aBalans[s,1] = dmp2;

         tmp2 = aBalans[s + 1,0];
         dmp2 = aBalans[s + 1,1];
         aBalans[s + 1,0] = tmp1;
         aBalans[s + 1,1] = dmp1;
      }
      int handle = FileOpen(gUseIncreaseMartinsFile,FILE_BIN | FILE_WRITE);
      if(handle > 0) {
         FileWriteArray(handle, aBalans, 0, maxasize * 2); // writing whole array
         FileClose(handle);
      }

      for(s = 0; s < asize; s++) {
         if(aBalans[s,0] != aBalans[s - 1,0]) aa = aa + "\n" + DoubleToStr(aBalans[s,0],2) + " " + DoubleToStr(aBalans[s,1],0);
      }
      if((aBalans[asize - 1,0]) > 0) {
         pr = NormalizeDouble(((AccountBalance() * 100) / (aBalans[asize - 1,0])) - 100,2);
         pr1 = NormalizeDouble((AccountBalance() * 100 / iCustom(NULL, 0, "grabli[balans]", 1, 0)) - 100,2);
      }
      Comment("Weekly Profit=",pr + " ; " + pr1 + "\n", DoubleToStr(aBalans[asize - 1,0],2) + " " + DoubleToStr(aBalans[asize - 1,1],0) + " " + iCustom(NULL, 0, "grabli[balans]", 0, 0) + " " + iCustom(NULL, 0, "grabli[balans]", 1, 0) + "\n" + "\n" + aa);
      Print("weekly profit=",pr, " ; Balans=",AccountBalance(), " ; PrevBalans=",aBalans[asize - 1,0] );
   }

}

/***********************************************/

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool bNewBar()
{
   if( gPreviTime < iTime ( 0, 0, 0 ) ) {
      gPreviTime = iTime ( 0, 0, 0 ) ;
      return ( TRUE ) ;
   } else {
      return ( FALSE ) ;
   }
}
