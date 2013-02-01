@isTest
public class Test_Rep_SCL {

    public testMethod static void doIt(){
        //ReportDateHelper rdh = new ReportDateHelper();
        User u = [select id from User where usercode__c='scl1'];
        
        if( u!= null){
            System.runAs(u) { runTests(); }
        } else {
            runTests();
        }
    }
    
    public static void runTests(){
        
        Test.startTest();
        (new Rep_SCL_ProductRebates(true)).getResultSet('SCLCW');
        (new Rep_SCL_Summary(true)).getResultSet('SCLCW');
        (new Rep_SCL_FuelEfficiency(true)).getResultSet('SCLCW');
        Test.stopTest();
    }
    
}