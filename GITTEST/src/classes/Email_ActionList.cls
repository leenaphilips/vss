/*
 * 2012.09.26::CEV
 *   1. Added new esubmit email parameter 'ProcessOverview'
 *   2. rebates are either electronic or mail-in.  The esubmit email has different content depending on which one it is.  
 *       Modified formParams for ActionList and ProcessOverview to use selctors (mail, esubmit)
 *   
 * 2012.06.21::Used by the Status Emails to display a list of follow up actions that the customer must perform
 *   in order to successfully submit his rebate
 */
public class Email_ActionList extends StatusEmail {

    public String rebateType {get; set;}
    
    private Rebate__c rebate;
    public ID rebateId {get; 
        set{
            rebate = [select id, RebateStatusMM__c, IsReminderEmail__c, formId__c, FormId__r.MailingName__c, FormId__r.MailingStreet1__c, FormId__r.MailingStreet2__c, FormId__r.MailingCity__c, FormId__r.MailingState__c, FormId__r.MailingZipcode__c, SubmitVia__c FROM Rebate__c where ID =: value];
        }
    }
    
    public String getActionList(){ return null; }
    
    public String getBody(){
        
        String selectorName = rebate.RebateStatusMM__c + (rebate.IsReminderEmail__c ? '-reminder' : '') + (!Utils.isEmpty(rebateType) ? '-'+rebateType : '');

        String body = null;
        for(FormParameter__c[] fp : [select ParameterValue__c FROM FormParameter__c 
            WHERE FormID__c =: rebate.formId__c AND ParameterName__c = 'EmailBody' AND SelectorName__c = :selectorName.toLowerCase()]){
            
            body = fp != null && !fp.isEmpty() ? fp[0].ParameterValue__c : null;
        }
        
        if( body == null ) return null;
        
        String address = rebate.FormId__r.MailingName__c + '<br/>' + rebate.FormId__r.MailingStreet1__c + '<br/>';
        if( !Utils.isEmpty(rebate.FormId__r.MailingStreet2__c)){
            address += rebate.FormId__r.MailingStreet2__c + '<br/>';
        }
        address += rebate.FormId__r.MailingCity__c + ', '+ rebate.FormId__r.MailingState__c + ' ' + rebate.FormId__r.MailingZipcode__c+'<br/>';
        return body.replace('%MAILING_ADDRESS%', address);  
    }
    
    @isTest(SeeAllData=true)
    public static void testIt(){
        Rebate__c r = new Rebate__c(FormCode__c = 'LIRF2012');
        insert r;
        
        RebateDetail__c d = new RebateDetail__c(RebateId__c = r.id, MeasureCode__c = 'RF_75', ModelNumber__c = '1234', Manufacturer__c = 'GE');
        insert d;
        
        Email_ActionList c = new Email_ActionList();
        c.rebateId = r.id;
        c.getBody();
    }
}