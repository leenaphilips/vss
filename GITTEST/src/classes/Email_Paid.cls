//-- ONLY FOR SINGLE-MEASURE LEGACY REBATES
public class Email_Paid extends StatusEmail {

    public String RebateId {get; set;}
    
    public Date getCheckMailDate(){
        
        List<RebateDetail__c> details = [select id, CheckMailDate__c from RebateDetail__c WHERE RebateID__c = :RebateId AND IsCustomerPayable__c = true];
        if( details.isEmpty() ) return null;
        return details[0].CheckMailDate__c;
    }
    
    @isTest(SeeAllData=true)
    public static void testId(){
        
        TestUtils u = new TestUtils();
        u.createRebate();
        
        Email_Paid p = new Email_Paid();
        p.RebateId = u.rebate.id;
        p.getCheckMailDate();
    }
}