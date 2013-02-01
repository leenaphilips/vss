@isTest
public with sharing class Test_SGE_Reports {

    public testMethod static void doIt(){
        //ReportDateHelper rdh = new ReportDateHelper();
    	User u = [select id from User where UserCode__c='sge1'];
    	
    	if( u!= null){
    		System.runAs(u) { runTests(); }
    	} else {
    		runTests();
    	}
    }
    
    public static void runTests(){
    	
        Test.startTest();
        
        (new Rep_Sge_MouExport(true)).getResultSet('SGE');
        (new Rep_Sge_Markdown(true)).getResultSet('SGE');
        (new Rep_Sge_InvSum(true)).getResultSet('SGE');
        (new REp_Sge_SalesByPart(true)).getResultSet('SGE');
        
        Test.stopTest();
    }
    
      
}