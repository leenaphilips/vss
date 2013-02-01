@isTest
public class Test_PSE_Reports {
  
  private static PageReference pageRef = Page.ReportLauncher;
  
    public testMethod static void doIt(){
        //ReportDateHelper rdh = new ReportDateHelper();
        User u = [select id from User where userCode__c='pse1'];
        
        if( u!= null){
            System.runAs(u) { runTests(); }
        } else {
            runTests();
        }
    }
    
    public static void runTests(){
        
        Test.startTest();
        
        ReportLauncher rl = new ReportLauncher(true);
        rl.getReportLabel();
        
        pageRef.getParameters().put('InvoiceDate', '10/17/2011');
        pageRef.getParameters().put('InvoiceYear', '2011');
        Test.setCurrentPage(pageRef);
        
        (new Rep_Pse_Markdown(true)).getResultSet('PSE');
        (new Rep_Pse_InvSum(true)).getResultSet('PSE');
        (new Rep_Pse_MouExport(true)).getResultSet('PSE');
        (new Rep_Pse_SalesByPart(true)).getResultSet('PSE');
        (new Rep_Pse_RebatesByInvoice(true)).getResultSet('PSE');
        (new Rep_Pse_Allocation(true)).getResultSet('PSE');
        
        Rep_Pse_Detail r = new Rep_Pse_Detail(true);
        r.getResultSet();
        
        Test.stopTest();
    }
      
}