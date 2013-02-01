public class Email_ShowFooter {

    private Account account = null; 
    private Form__c form = null;
    
    public String formCode {
        get; 
        set {
            if( !Utils.isEmpty(value) ){
                form = [select id, CustomerServicePhone__c, PrimaryColor__c, SecondaryColor__c, TertiaryColor__c, ClientProgramName__c
                    FROM Form__c where FormCode__c = :value][0];
            }
        }
    }
    public String clientCode {
        get; 
        set{
            account = [select id, localTimeOffset__c, CustomerServicePhone__c, ClientName__c, PrimaryColor__c, SecondaryColor__c, 
                TertiaryColor__c, valediction__c
                FROM Account WHERE ClientCode__c = :value][0];
        } 
    }
    
    public String getPrimaryColor(){ return form != null ? form.PrimaryColor__c : account.PrimaryColor__c; }
    public String getSecondaryColor(){ return form != null ? form.SecondaryColor__c : account.SecondaryColor__c; }
    public String getTertiaryColor(){ return form != null ? form.TertiaryColor__c : account.TertiaryColor__c; }
    
    public String getClientProgramName(){ return form != null ? form.ClientProgramName__c : account.ClientName__c; }
    
    public String getCustomerServicePhone(){ return form != null ? form.CustomerServicePhone__c : account.CustomerServicePhone__c; }
    
    public String getValediction(){ return account.Valediction__c; }
    
    public String getWeekdayOpenTime(){
        return Utils.getWeekdayOpenTime((Integer)account.LocalTimeOffset__c);
    }
    
    public String getWeekdayCloseTime(){
        return Utils.getWeekdayCloseTime((Integer)account.LocalTimeOffset__c);
    }
    
    public String getWeekendOpenTime(){
        return Utils.getWeekendOpenTime((Integer)account.LocalTimeOffset__c);
    }
    
    public String getWeekendCloseTime(){
        return Utils.getWeekendCloseTime((Integer)account.LocalTimeOffset__c);
    }
    
    @isTest(SeeAllData=true)
    public static void testIt(){
        Email_ShowFooter f = new Email_ShowFooter();
        f.ClientCode = 'LIPA';
        f.FormCode = 'LIRF2012';
        
        f.getPrimaryColor();
        f.getSecondaryColor();
        f.getTertiaryColor();
        f.getCustomerServicePhone();
        f.getClientProgramName();
        f.getWeekdayOpenTime();
        f.getWeekdayCloseTime();
        f.getWeekendOpenTime();
        f.getWeekendCloseTime();
    }
    
}