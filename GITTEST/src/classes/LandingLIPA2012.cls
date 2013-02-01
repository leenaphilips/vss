public with sharing class LandingLIPA2012 {

    public String email {get; set;}
    
    public String clientCode {get; set;}
    
    public PageReference sendEmail(){
    
        if( Utils.isEmpty(email) || !Utils.isValidEmail(email) ){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please enter a valid email address'));
            return null;
        }
        
        Boolean found = false;
        Contact con = null;
        for(Contact c : [select id, AccountId, Account.Name from Contact where email=:email and Account.ClientCode__c =: clientCode]){
            found = true;
            con = c;
            break;
        }
        if( !found ){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'We do not have that email address on file;'+email+';'+clientCode));
            return null;
        }
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'An email has been sent to the address specified containing your rebate information'));
        
        String templateId = [select id from EmailTemplate where Name = :clientCode + ' - Request'].id;
        
        Messaging.SingleEmailMessage m = new Messaging.SingleEmailMessage();
        m.setSenderDisplayName( con.Account.Name );
        m.setReplyTo('info@efi.org');
        m.setWhatId(con.AccountId);
        m.setTemplateId(templateId);
        m.setTargetObjectId( con.id );
      
        System.debug('EMAIL MESSAGE: '+m);
        Messaging.SendEmailResult res = Messaging.SendEmail( new Messaging.Email[]{ m } )[0];
        return null;
    }
    
    @isTest(SeeAllData=true)
    public static void testIt(){
        LandingLIPA2012 ll = new LandingLIPA2012();
        ll.clientCode = 'LIPA';
        ll.sendEmail();
        ll.email = 'aaa@aaa.com.tv.abc';
        ll.sendEmail();
        ll.email = 'cvitone@gmail.com';
        ll.sendEmail();
    }
}