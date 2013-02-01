public class RebateApplication{

    private String rebateId;
    
    public String pdxProgram {get; set;}
    public Contact contact {get; set;}
    public Rebate__c rebate {get; set;}
    public List<RebateDetail__c> details {get; set;}
    public List<RebateSurvey__c> surveys {get; set;}
    
    public RebateApplication(){
        
        rebateId = ApexPages.currentPage().getParameters().get('id');
        System.debug('LOADING rebate with id "'+rebateId+'"');
        init();
    } 
    
    private void init(){
        
        loadRebate();
        loadContact();
        loadDetails();
        loadSurveys();
    } 
    
    private void loadRebate(){
        
        String query = Utils.buildSQL('Rebate__c')+' WHERE id = \''+rebateId+'\'';
        System.debug('QUERY: '+query);
        List<Rebate__c> rebates = Database.query( query );
        if( rebates.isEmpty() ){
            System.debug('No rebates found!!!');
            return;
        }
        rebate = rebates[0];
        System.debug('REBATE: '+rebate);
        
        List<Form__c> forms = [select id, PdoxProgramCode__c from Form__c where Id = :rebate.FormId__c];
        if( !forms.isEmpty() ){
            pdxProgram = forms[0].PdoxProgramCode__c;
        }
        
    }
    
    private void loadContact(){
        
        if( rebate == null ) return;
        List<Contact> contacts = Database.query( Utils.buildSQL('Contact') + ' WHERE id = \''+rebate.ContactId__c+'\'');
        if( contacts.isEmpty() ){
            return;
        }
        
        contact = contacts[0];
    }
    
    private void loadDetails(){
        if( rebate == null ) return;
        details = Database.query( Utils.buildSQL('RebateDetail__c') + ' WHERE rebateId__c = \'' + rebate.id + '\'');
    }
    
    private void loadSurveys(){
        if( rebate == null ) return;
        surveys = Database.query( Utils.buildSQL('RebateSurvey__c') + ' WHERE rebateId__c = \'' + rebate.id + '\'');
    }
    
    @isTest(SeeAllData=true)
    public static void testIt(){
    
        TestUtils u = new TestUtils();
        u.createRebate();
        
        PageReference p = Page.RebateApplication;
        p.getParameters().put('id', u.rebate.id);
        
        Test.setCurrentPage(p);
        Test.startTest();
        
        RebateApplication a = new RebateApplication();
    }
}