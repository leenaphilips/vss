@isTest
public with sharing class Test_Rep_Lipa {

    public testMethod static void doIt(){
        //ReportDateHelper rdh = new ReportDateHelper();
        User u = [select id from User where UserCode__c='lipa1'];
        
        if( u!= null){
            System.runAs(u) { runTests(); }
        } else {
            runTests();
        }
    }
    
    public static void runTests(){
        
        Test.startTest();
        (new Rep_Lipa_ProductRebates(true)).getResultSet('LIRF');
        (new Rep_Lipa_Summary(true)).getResultSet('LIRF');
        Test.stopTest();
    }
    
 
}