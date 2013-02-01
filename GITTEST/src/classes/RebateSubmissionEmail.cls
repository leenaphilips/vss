/*
    Controller for the VF Email that is sent when a rebate has been submitted.  
*/
public class RebateSubmissionEmail extends StatusEmail {

    public ID rebateId {
        get;
        set {
            for(Rebate__c[] r : [select Id, FormId__c, FormId__r.AccountId__r.LocalTimeOffset__c FROM Rebate__c where ID = :value]){
                rebate = r != null && !r.isEmpty() ? r[0] : null;
                value = rebate != null ? rebate.id : null;
                break;
            }
        }
    }
    
    private Rebate__c rebate;
    
    public List<RebateDetail__c> getPayableDetails(){
        return [select id, DetailStatus__c, MeasureCategory__c, Manufacturer__c, ModelNumber__c, PayableAmount__c
        FROM RebateDetail__c 
        WHERE RebateId__c = :rebate.Id and IsCustomerPayable__c = true];
    }
    
    public String getActionList(){
        
        for(FormParameter__c[] fp : [select ParameterValue__c FROM FormParameter__c WHERE FormID__c =: rebate.FormId__c AND ParameterName__c = 'ActionList']){
            return fp != null && !fp.isEmpty() ? fp[0].ParameterValue__c : null;
        }
        
        return null;
    }
    
    public String getWeekdayOpenTime(){
        return Utils.getWeekdayOpenTime((Integer)rebate.FormId__r.AccountId__r.LocalTimeOffset__c);
    }
    
    public String getWeekdayCloseTime(){
        return Utils.getWeekdayCloseTime((Integer)rebate.FormId__r.AccountId__r.LocalTimeOffset__c);
    }
    
    public String getWeekendOpenTime(){
        return Utils.getWeekendOpenTime((Integer)rebate.FormId__r.AccountId__r.LocalTimeOffset__c);
    }
    
    public String getWeekendCloseTime(){
        return Utils.getWeekendCloseTime((Integer)rebate.FormId__r.AccountId__r.LocalTimeOffset__c);
    }
    
    @isTest(SeeAllData=true)
    public static void testIt(){
        Rebate__c r = new Rebate__c(FormCode__c = 'LIRF2012');
        insert r;
        
        RebateDetail__c d = new RebateDetail__c(RebateId__c = r.id, MeasureCode__c = 'RF_75', ModelNumber__c = '1234', Manufacturer__c = 'GE');
        insert d;
        
        RebateSubmissionEmail c = new RebateSubmissionEmail();
        c.rebateId = r.id;
        c.getPayableDetails();
        c.getActionList();
        c.getWeekdayOpenTime();
        c.getWeekdayCloseTime();
        c.getWeekendOpenTime();
        c.getWeekendCloseTime();
    }
}