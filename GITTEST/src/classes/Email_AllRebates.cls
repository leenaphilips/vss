public class Email_AllRebates extends StatusEmail{

    public String contactId {
        get; 
        set
        {
            contactId = value;
            if( contactId == null ){
                email = null;
                return;
            }
        
            Contact c = [select firstName, LastName, Name, email from Contact where ID = :contactId];
            if( c== null || Utils.isEmpty(c.email)){
                email = null;
                return;
            }
            
            email = c.email;     
            FirstName = c.FirstName;      
        }
    }

    public String FirstName {get; set;}
    private String email;
    private Account account;
    private Boolean isAccountLoaded = false;
    
    private void loadAccount(){
    
        Account[] accounts = [select id, clientCode__c, Name, PrimaryColor__c, SecondaryColor__c, TertiaryColor__c, LocalTimeOffset__c, CustomerServicePhone__c 
        from Account WHERE clientCode__c = :clientCode];
        account = accounts != null && accounts.size() > 0 ? accounts[0] : null;
        isAccountLoaded = true;
    }
    
    public Boolean getHasRebates(){
        return [select count() from Rebate__c 
            where contactId__r.email = :email and formId__r.clientCode__c = :clientCode] > 0;
    }

    class RebateLinks {
        public Boolean isReceived {get; set;}
        public String statusUrl {get; set;}
        public String formUrl {get; set;}
        public String rebateNumber {get; set;}
        public DateTime createdDate {get; set; }
    }
    
    //-- We are passing a single contact to this form (as that is what the email requires) but we need to match on email address
    public List<RebateLinks> getRebates(){
        Rebate__c[] rebates = [SELECT id, RebateNumber__c, FormCode__c, FormID__r.ApexPageName__c, FormID__r.ClientCode__c, CreatedDate, 
            FormId__r.FormURL__c, FormId__r.StatusURL__c, MailingZipcode__c, name, RebateStatusMM__c, HashCode__c 
            FROM Rebate__c 
            WHERE contactId__r.email = :email and formId__r.clientCode__c = :clientCode 
            ORDER by createddate asc];
            
        if( rebates == null || rebates.size() == 0 ) return null;
        
        List<RebateLinks> links = new List<RebateLinks>();
        URL__c urls = URL__c.getOrgDefaults();
     
        for(Rebate__c r : rebates){
            RebateLinks l = new RebateLinks();
            l.isReceived = 'eSubmit'.equalsIgnoreCase(r.RebateStatusMM__c);
            l.rebateNumber = r.rebateNumber__c;
            l.createdDate = r.createdDate;
            
            String suffix = '?FormCode=' + r.FormCode__c + '&RebateNumber=' + r.RebateNumber__c +'&PostalCode=' + r.MailingZipCode__c + '&auth=' + r.HashCode__c;
            if( !l.isReceived ){
                l.formURL = r.FormId__r.formURL__c + suffix;
            }
            
            l.statusURL = r.FormId__r.statusURL__c + suffix;
            
            links.add(l);
        }
        
        return links;
    }
    
    public String getClientName(){
        if( !isAccountLoaded ) loadAccount();
        return account != null ? account.Name : null;
    }
    
    public String getCustomerServicePhone(){
        if( !isAccountLoaded ) loadAccount();
        return account != null ? account.CustomerServicePhone__c : null;
    }
    
    public String getWeekdayOpenTime(){
        if( !isAccountLoaded ) loadAccount();
        return Utils.getWeekdayOpenTime((Integer)account.LocalTimeOffset__c);
    }
    
    public String getWeekdayCloseTime(){
        if( !isAccountLoaded ) loadAccount();
        return Utils.getWeekdayCloseTime((Integer)account.LocalTimeOffset__c);
    }
    
    public String getWeekendOpenTime(){
        if( !isAccountLoaded ) loadAccount();
        return Utils.getWeekendOpenTime((Integer)account.LocalTimeOffset__c);
    }
    
    public String getWeekendCloseTime(){
        if( !isAccountLoaded ) loadAccount();
        return Utils.getWeekendCloseTime((Integer)account.LocalTimeOffset__c);
    }
    
    public String getPrimaryColor(){
        if( !isAccountLoaded ) loadAccount();
        return account.PrimaryColor__c;
    }
    
    public String getSecondaryColor(){
        if( !isAccountLoaded ) loadAccount();
        return account.SecondaryColor__c;
    }
    
    public String getTertiaryColor(){
        if( !isAccountLoaded ) loadAccount();
        return account.TertiaryColor__c;
    }
    
    @isTest(SeeAllData=true)
    public static void testIt(){
        Contact c = new Contact(lastName = 'Vitone', firstName='Chris', Email='Something@example.com');
        insert c;
        
        Rebate__c r = new Rebate__c(contactId__c = c.id, FormCode__c = 'LIRF2012');
        insert r;
        
        insert (new RebateDetail__c(RebateId__c = r.id, Manufacturer__c = 'GE', ModelNumber__c = 'ABC123', MeasureRebateAmount__c = 75, Quantity__c = 1));
        insert (new RebateDetail__c(IsCustomerPayable__c = false, RebateId__c = r.id, Manufacturer__c = 'GE', ModelNumber__c = 'ABC123', MeasureRebateAmount__c = 75, Quantity__c = 1));
        
        Email_AllRebates ur = new Email_AllRebates();
        ur.contactId = c.id;
        ur.clientCode = 'LIPA';
        ur.getHasRebates();
        ur.getRebates();
        ur.getClientName();
        ur.getPrimaryColor();
        ur.getSecondaryColor();
        ur.getTertiaryColor();
        ur.getWeekdayOpenTime();
        ur.getWeekdayCloseTime();
        ur.getWeekendOpenTime();
        ur.getWeekendCloseTime();
        ur.getCustomerServicePhone();
    }
}