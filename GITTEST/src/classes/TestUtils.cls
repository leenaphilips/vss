@isTest
public class TestUtils{
    
    public static final String CLIENT_CODE = 'SGE';
    public static final String FORM_CODE = 'SGEHE2012';

    public Account client { get; private set; }
    public Contact customer { get; private set; }
    public Form__c form { get; private set; }
    public Rebate__c rebate { get; private set; }
    public List<RebateDetail__c> details { get; private set; }
    public List<RebateSurvey__c> surveys { get; private set; }
    public List<RebateDocument__c> documents {get; private set; }
    
    public Rebate__c createRebate(){
        client = [select id from Account where clientCode__c =: CLIENT_CODE];
        form = [select id from Form__c where formCode__c =: FORM_CODE];
        customer = new Contact(AccountId = client.id, FirstName = 'Chris', LastName = 'Vitone', Email = 'cvitone@gmail.com');
        insert customer;
        
        rebate = new Rebate__c(ContactId__c = customer.id, FormId__c = form.id, Name = 'TEST REBATE', FormCode__c = FORM_CODE);
        insert rebate;
        
        details = new List<RebateDetail__c>();
        details.add( new RebateDetail__c(rebateId__c = rebate.id, ModelNumber__c = 'ABC', Manufacturer__c = '123', MeasureRebateAmount__c = 500.00));
        insert details[0];
        
        surveys = new List<RebateSurvey__c>();
        for(FormFields__c f :  [select id from FormFields__c where TargetTable__c = 'RebateSurvey__c' and FormID__c =: form.id]){
            surveys.add( new RebateSurvey__c(FormFieldId__c = f.id, Answer__c = 'TEST', RebateId__c = rebate.id) );
        }
        
        if( surveys.size() > 0 ) insert surveys;
        
        documents = new List<RebateDocument__c>();
        documents.add( new RebateDocument__c(rebateId__c = rebate.id, DocumentRepository__c = 'ImageSilo', RepositoryProject__c = 'V3 TEST', ExternalDocumentId__c = '512', FileSize__c = 10240, FileName__c = 'test.doc'));
        insert documents[0];
        
        return rebate;
    }
    
}