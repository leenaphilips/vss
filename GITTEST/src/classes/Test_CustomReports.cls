@isTest
public with sharing class Test_CustomReports {

	public testMethod static void test(){
		
		Account a = new Account(name='account', clientcode__c='ACE');
		insert a;
		
		Form__c f = new Form__c(Name = 'Form', FormCode__c = 'FormCode', AccountId__c = a.id);
		insert f;
		
		Test.startTest();
		CustomReport__c c = new CustomReport__c(
			Name = 'Test Report',
			ApexClassName__c = 'Rep_Code',
			FormID__c = f.id
		);
		insert c;
		
		c = [select id, FormID__c, AccountID__c from CustomReport__c where id =: c.id];
		System.assert(c.AccountID__c == a.id, 'Account not set');
	}
	
	
	public testMethod static void testUpDown(){
		User u = [select id from User where UserCode__c='sge1'];
    	
    	if( u!= null){
    		System.runAs(u) { 
    			testUp();
    		}
    	} else {
			testUp();
    	}
    	
		u = [select id from User where UserCode__c='lipa1'];
    	
    	if( u!= null){
    		System.runAs(u) { 
    			testDown();
    		}
    	} else {
			testDown();
    	}    	
        
	}
	
	private static void testUp(){
		PageReference pageRef = Page.CustomUpReports;
        Test.setCurrentPage(pageRef);
        
        CustomUpReportCntrl c = new CustomUpReportCntrl(true);
        c.getYears();
        c.getInvoiceDates();
        c.getReports();
	}
	
	private static void testDown(){
			
        PageReference pageRef = Page.CustomReports;
        Test.setCurrentPage(pageRef);
        
        CustomReportCntrl c = new CustomReportCntrl(true);
        c.getYears();
        c.getInvoiceDates();
        c.getAccountReports();
        c.getFormReports();
	}
	
}