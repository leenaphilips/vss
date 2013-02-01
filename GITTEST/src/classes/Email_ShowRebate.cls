/*
  2012.07.06::Added support for quantities.
*/
public class Email_ShowRebate {

    public Rebate__c rebate{ get; private set; }
    public ID rebateId {
        get;
        set {
            for(Rebate__c[] r : [select Id, RebateNumber__c, CustomerPayableAmount__c FROM Rebate__c where ID = :value]){
                rebate = r != null && !r.isEmpty() ? r[0] : null;
                value = rebate != null ? rebate.id : null;
                break;
            }
        }
    }
    
    
    public List<RebateDetail__c> getPayableDetails(){
        List<RebateDetail__c> details = [select id, DetailStatus__c, MeasureCategory__c, Manufacturer__c, ModelNumber__c, MeasureRebateAmount__c, Quantity__c, PayableAmount__c, PayableMeasureAmount__c,
        CheckMailDate__c
        FROM RebateDetail__c 
        WHERE RebateId__c = :rebate.Id and IsCustomerPayable__c = true];
        
        return details == null || details.size() == 0 ? null : details;
    }
    
    
    @isTest(SeeAllData=true)
    public static void testIt(){
        Rebate__c r = new Rebate__c(FormCode__c = 'LIRF2012');
        insert r;
        
        RebateDetail__c d = new RebateDetail__c(RebateId__c = r.id, MeasureCode__c = 'RF_75', ModelNumber__c = '1234', Manufacturer__c = 'GE');
        insert d;
        
        Email_ShowRebate c = new Email_ShowRebate();
        c.rebateId = r.id;
        c.getPayableDetails();
    }
}