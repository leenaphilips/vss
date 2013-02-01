/*
 * 2012.06.21::Sends emails by un-setting the SendStatusEmail flag.
 */
public class EmailBatchProcessor {

    public void sendAllEmails(){
        
        for(List<Rebate__c> rebateList : [select id from Rebate__c where SendStatusEmail__c = true]){
            if( rebateList == null || rebateList.isEmpty() ) return;
            
            for(Rebate__c rebate : rebateList){
                rebate.SendStatusEmail__c = false;
            }
            
            update rebateList;
        }
    }
    
    @isTest(SeeAllData=true)
    public static void testIt(){
        Contact c = new Contact(FirstName='Chris', LastName ='Vitone', Email='Cvitone@gmail.com');
        insert c;
    
        Rebate__c r = new Rebate__c(FormCode__c = 'LIRF2012', RebateStatus__c = 'eSubmit', Name='Test', contactId__c = c.id, SendStatusEmail__c = true);
        insert r;
        
        (new EmailBatchProcessor()).sendAllEmails();
    }
}