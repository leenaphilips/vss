public class UnprocessedRebates {

    public String contactId {
        get; 
        set
        {
            contactId = value;
            if( contactId == null ){
                email = null;
                return;
            }
        
            Contact c = [select email from Contact where ID = :contactId];
            if( c== null || Utils.isEmpty(c.email)){
                email = null;
                return;
            }
            
            email = c.email;            
        }
    }
    
    public String clientCode {
        get; 
        set{
            clientCode = value;
            
            Account[] accounts = [select id, clientCode__c, Name, LocalTimeOffset__c, CustomerServicePhone__c from Account WHERE clientCode__c = :clientCode];
            account = accounts != null && accounts.size() > 0 ? accounts[0] : null;
        } 
    }
    
    private String email;
    private Account account;
    
    public Boolean getHasRebates(){
        return [select count() from Rebate__c 
            where contactId__r.email = :email and formId__r.clientCode__c = :clientCode] > 0;
    }
    
    //-- We are passing a single contact to this form (as that is what the email requires) but we need to match on email address
    public List<Rebate__c> getRebates(){
        return [select id, RebateNumber__c, FormCode__c, FormID__r.ApexPageName__c, FormID__r.ClientCode__c, CreatedDate, MailingZipcode__c, name, RebateStatus__c 
            from Rebate__c 
            where contactId__r.email = :email and formId__r.clientCode__c = :clientCode 
            order by createddate asc];
    }
    
    public String getClientName(){
        return account != null ? account.Name : null;
    }
    
    public String getCustomerServicePhone(){
        return account != null ? account.CustomerServicePhone__c : null;
    }
    
    public String getWeekdayOpenTime(){
        return Utils.getWeekdayOpenTime((Integer)account.LocalTimeOffset__c);
    }
    
    public String getWeekdayCloseTime(){
        return Utils.getWeekdayCloseTime((Integer)account.LocalTimeOffset__c);
    }
    
    public String getWeekendOpenTime(){
        return Utils.getWeekendCloseTime((Integer)account.LocalTimeOffset__c);
    }
    
    public String getWeekendCloseTime(){
        return Utils.getWeekendCloseTime((Integer)account.LocalTimeOffset__c);
    }
    
    @isTest(SeeAllData=true)
    public static void testIt(){
        Contact c = new Contact(lastName = 'Vitone', firstName='Chris', Email='Something@example.com');
        insert c;
        
        Rebate__c r = new Rebate__c(contactId__c = c.id, FormCode__c = 'SGERF2012');
        insert r;
        
        insert (new RebateDetail__c(RebateId__c = r.id, Manufacturer__c = 'GE', ModelNumber__c = 'ABC123', MeasureRebateAmount__c = 75, Quantity__c = 1));
        insert (new RebateDetail__c(IsCustomerPayable__c = false, RebateId__c = r.id, Manufacturer__c = 'GE', ModelNumber__c = 'ABC123', MeasureRebateAmount__c = 75, Quantity__c = 1));
        
        UnprocessedRebates ur = new UnprocessedRebates();
        ur.contactId = c.id;
        ur.clientCode = 'LIPA';
        ur.getRebates();
        ur.getHasRebates();
        ur.getClientName();
        ur.getCustomerServicePhone();
        ur.getWeekdayOpenTime();
        ur.getWeekdayCloseTime();
        ur.getWeekendOpenTime();
        ur.getWeekendCloseTime();
    }
}