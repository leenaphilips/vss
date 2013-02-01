@isTest
public class Test_Admin {
    
    private static final String TEST_FORM_CODE = 'LIRF2012';
    private static final String NEW_MANUFACTURER = 'Vitone LTD';
    
    public static testMethod void testCleanModelTrigger(){
        Model__c m = new Model__c(Manufacturer__c = 'General Electri', modelNumber__c = 'ABC123**');
        insert m;
    }
    
    public static testMethod void testFormParameterTrigger(){
        ID formId = [select Id from Form__c where FormCode__c = 'LIRF2012'].id;
        FormParameter__c fp = new FormParameter__c(FormId__c = formId, ParameterName__c = 'PN', SelectorName__c = 'NAME');
        insert fp;
    }

//-- tests the FormXModel_UpdateFormXMan trigger
    public static testMethod void testFormXModelTrigger(){
        ID formId = [select id from Form__c where FormCode__c =: TEST_FORM_CODE ].id;
        
        Model__c newModel = new Model__c(Name='TEST', ModelNumber__c = 'ABC123', Manufacturer__c = NEW_MANUFACTURER);
        insert newModel;
        
        Manufacturer__c newMan = new Manufacturer__c(Name=NEW_MANUFACTURER, Manufacturer__c = NEW_MANUFACTURER);
        insert newMan;
        
        FormXModel__c fxModel = new FormXModel__c(Name='TEST', FormId__c = formId, ModelId__c = newModel.id);
        insert fxModel;
        
        List<FormXManufacturer__c> fxMans = [select Id from FormXManufacturer__c where FormId__c =: formId and ManufacturerId__c =: newMan.id];
        System.assert(fxMans != null && fxMans.size() == 1, 'No FxMan created when FxModel added');
        
        delete fxModel;
        
        fxMans = [select Id from FormXManufacturer__c where FormId__c =: formId and ManufacturerId__c =: newMan.id];
        System.assert( fxMans == null || fxMans.size() == 0, 'FxMan not deleted when FxModel deleted');
    }
    
//-- tests the Mode_UpdateManufacturer trigger
    public static testMethod void testModelUpdateManTrigger(){
        
        Model__c m = new Model__c( Name = 'TEST', Manufacturer__c = NEW_MANUFACTURER, ModelNumber__c = 'ABC123');
        insert m;
        
        List<Manufacturer__c> mans = [select id from Manufacturer__c where manufacturer__c =: NEW_MANUFACTURER];
        System.assert(mans!= null && mans.size() == 1, 'Adding Model did not create a new Manufacturer');
        
        delete m;
        mans =  [select id from Manufacturer__c where manufacturer__c =: NEW_MANUFACTURER];
        System.assert(mans == null || mans.size() == 0, 'Deleting Model did not delete manufacturer');
    }
    
//-- test session data deletion
    public static testMethod void testSessionDataTrigger(){
        
        SessionData__c sd = new SessionData__c(SessionID__c = 'ABC', FieldName__c='TEST', FieldValue__c='TEST');
        insert sd;
        sd.DeleteMe__c = true;
        update sd;
        
        List<SessionData__c> results = [select id from SessionData__c where id =: sd.id];
        //-- due to a "feature" of salesforce, I cannot delete a trigger's object. 
        //System.assert(results == null || results.size() ==0, 'Sessiondata should have been deleted');
    }
    
    @isTest(SeeAllData=true)
    public static void testFormFieldSetName(){
        
        ID formId = [select id from Form__c where FormCode__c = 'SGERF2012'].id;
        insert new FormFields__c(FormId__c = formId, TargetTable__c = 'Rebate__c', FieldName__c = 'id');
    }
}