@isTest
public class Test_PdoxTriggers {

    private static final String PROGRAM_CODE = 'LIRF';
    private static final String FORM_CODE = 'LIRF2011';
    private static final String ACCOUNT_NUMBER = 'ABC-123-321-XYZ';
    private static final String MODEL_NUMBER = 'DCR122WDD';
    private static final String MANUFACTURER = 'Danby';
    
    private static Contact contact;
    
    public static void testContactAssignment(){
        //-- TEST NEW
        Contact c = new Contact(IsSentFromPdx__c = true, IsPdxValidated__c = true, FirstName = 'Chris', LastName = 'Vitone', AccountNumber__c = ACCOUNT_NUMBER, PdxId__c = PROGRAM_CODE+'|'+ACCOUNT_NUMBER);
        insert c;
        System.assert(c.AccountId == null, 'Contact.Account should be null');
        
        c = new Contact(IsSentFromPdx__c = true, IsPdxValidated__c = true, FirstName = 'Chris', LastName = 'Vitone', AccountNumber__c = ACCOUNT_NUMBER, PdoxProgramCode__c = PROGRAM_CODE);
        insert c;
        c = [select id, AccountId from Contact where id = :c.id];
        System.assert(c.AccountId != null, 'Contact.Account should not be null');
                
        c.IsSentFromPdx__c = true;
        c.PdoxProgramCode__c = 'SOMETHING';
        update c;
        c = [select id, AccountId from Contact where id = :c.id];
        System.assert(c.AccountId == null, 'Contact.Account should be null');
        
        c.IsSentFromPdx__c = true;
        c.PdoxProgramCode__c = PROGRAM_CODE;
        update c;
        c = [select id, AccountId from Contact where id = :c.id];
        System.assert(c.AccountId != null, 'Contact.Account should not be null');
        
        contact = c;
    }
    
    public static void testRebateAssignment(){
        Rebate__c r = new Rebate__c(IsSentFromPdx__c = true, IsPdxValidated__c = true, PdxAccountNumber__c = ACCOUNT_NUMBER, FormCode__c = FORM_CODE);
        insert r;
        
        Rebate__c rr = [select Id, ContactID__c, FormId__c from Rebate__c where id = :r.id];
        System.assert(rr.ContactID__c != null, 'Contact ID should not be null');
        System.assert(rr.FormId__c != null, 'Form ID should not be null');
        
        r.IsSentFromPdx__c = true;
        r.PdxAccountNumber__c = null;
        r.FormCode__c = null;
        update r;
        
        rr = [select Id, ContactID__c, FormId__c from Rebate__c where id = :r.id];
        System.assert(rr.ContactID__c == null, 'Contact ID should be null');
        System.assert(rr.FormId__c == null, 'Form ID should be null');
        
        r.IsSentFromPdx__c = true;
        r.PdxAccountNumber__c = ACCOUNT_NUMBER;
        r.FormCode__c = FORM_CODE;
        update r;
        
        rr = [select Id, ContactID__c, FormId__c from Rebate__c where id = :r.id];
        System.assert(rr.ContactID__c != null, 'Contact ID should not be null');
        System.assert(rr.FormId__c != null, 'Form ID should not be null');
        
    }
    
    public static void testRebateDetail(){
    	Rebate__c r = new Rebate__c(IsSentFromPdx__c = true, IsPdxValidated__c = true, PdxAccountNumber__c = ACCOUNT_NUMBER, FormCode__c = FORM_CODE);
        insert r;
        
        RebateDetail__c d = new RebateDetail__c(IsSentFromPdx__c = true, RebateId__c = r.id, MeasureCode__c = 'RF_75', ModelNumber__c = MODEL_NUMBER, Manufacturer__c = MANUFACTURER);
        insert d;
    }
    
    public static testMethod void testIt(){
        Test.startTest();
        testContactAssignment();
        testRebateAssignment();
        testRebateDetail();
        Test.stopTest();
    }
}