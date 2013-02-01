public class FormStatusControllerMM {

    private static final String StyleError = 'display:inline';
    private static final String StyleOK = 'display:none';
    
    private String RebateId;
    
    public String RebateNumber {get; set; }
    public String PostalCode {get; set; }
    public String FormCode {get; set;}
    
    public Date RebateDate {get; set; }
    public String RebateStatus {get; set; }
    public String RebateDescription {get; set;}
    public Double RebateAmount {get; set; }
    public String MailingAddress {get; private set; }
    
    public List<String> statusCodes {get; private set; }
    public Integer NumStatusCodes {get; private set; }
    public Map<String, String> statusMessages {get; private set; }
    
    public String StyleRebateNumber{get; set; }
    public String StylePostalCode{get; set; }
    
    public Boolean NoResultsReturned {get; private set; }
    public String NoResultsText {get; private set; }
    
    private List<DetailStatus> details = null;
    
    public FormStatusControllerMM(){
        NoResultsReturned = false;
        StyleRebateNumber = StyleOK;
        StylePostalCode = StyleOK;
        
        RebateNumber = ApexPages.currentPage().getParameters().get('RebateNumber');
        PostalCode = ApexPages.currentPage().getParameters().get('PostalCode');
        FormCode = ApexPages.currentPage().getParameters().get('FormCode');
        
        if( !Utils.isEmpty(RebateNumber) && !Utils.isEmpty(FormCode)){
            findRebate();
        }
    }
    
    public PageReference findRebate(){
        NoResultsReturned = false;
        RebateStatus = null;
        details = null;
        
        if( Utils.isEmpty(FormCode)){
            ApexPages.addMessage( Utils.createErrorMessage('The FormCode variable has not been specified.  Please contact EFI'));
            return null;
        }
        
        if( !validate() ){
            ApexPages.addMessage( Utils.createErrorMessage('Please correct the errors below'));
            return null;
        }
        
        List<Rebate__c> rebates = [select Id, CreatedDate, RebateStatusMM__c, CustomerPayableAmount__c, CheckMailDate__c, FormId__c
            FROM Rebate__c where MailingZipcode__c = :PostalCode AND RebateNumber__c = :RebateNumber and FormID__r.FormCode__c = :FormCode];
            
        if( rebates.size() != 1){
            showNoResults();
            return null;
        }
        
        Form__c f = [select id, MailingName__c, MailingStreet1__c, MailingStreet2__c, MailingCity__c, MailingState__c, MailingZipCode__c FROM Form__c where formCode__c =: FormCode][0];
        
        MailingAddress = f.MailingName__c + '<br/>' + f.MailingStreet1__c + '<br/>' + 
            (Utils.IsEmpty(f.MailingStreet2__c) ? '' : f.MailingStreet2__c+'<br/>') + f.MailingCity__c + ', ' + f.MailingState__c + ' ' +f.MailingZipCode__c;
       
       
        Rebate__c r = rebates.get(0);
        
        RebateId = r.id;
        RebateAmount = r.CustomerPayableAmount__c;
        RebateStatus = r.RebateStatusMM__c;
        RebateDate = r.CreatedDate.date();
        
        loadDetails();
        
        if( details == null ) return null;
        
        Set<String> statuses = new Set<String>();
        for(DetailStatus ds : details){
            statuses.add( ds.Status );
        }
        
        buildDescription( r.FormId__c, statuses );
        
        //-- if single status, then don't display codes, just display description
        if( statusCodes.size() == 1 ){
            RebateDescription = statusMessages.get( statusCodes.get(0) );
        } else {
            RebateStatus = '*see below*';
        }
        
        return null; 
    }
    
    private void loadDetails(){
       if( Utils.isEmpty(RebateId) ) return;
        
        List<RebateDetail__c> rds = [select Id, DetailStatus__c, ModelNumber__c, Manufacturer__c, CheckMailDate__c, 
            PayableMeasureAmount__c, Quantity__c, PayableAmount__c, MeasureCategory__c
            FROM RebateDetail__c WHERE RebateId__c =: RebateId and IsCustomerPayable__c =: true];

        if( rds == null ) return;
        details = new List<DetailStatus>();

        for(RebateDetail__c rd : rds){
            DetailStatus s = new DetailStatus();
            s.ModelNumber = rd.ModelNumber__c;
            s.Manufacturer = rd.Manufacturer__c;
            s.PayableMeasureAmount = rd.PayableMeasureAmount__c;
            s.Quantity = rd.Quantity__c;
            s.PayableAmount = rd.PayableAmount__c;
            s.MeasureCategory = rd.MeasureCategory__c;
            s.Status = rd.DetailStatus__c;
            s.CheckMailDate = rd.CheckMailDate__c;
            details.add(s);
        }
        
    }
    
    private void buildDescription(String formId, Set<String> statuses){
    
        Map<string, schema.sobjectfield> fieldsMap = Schema.SObjectType.RebateDetail__c.fields.getMap();
        List<String> detailStatusCodes = new List<String>();
        
        for (Schema.PicklistEntry p : fieldsMap.get('DetailStatus__c').getDescribe().getPicklistValues()){
            detailStatusCodes.add( p.getValue() );
        }

        List<FormParameter__c> params = [select id, SelectorName__c, ParameterValue__c from FormParameter__c 
                where FormID__c =: formId and ParameterName__c = 'RebateStatus' and SelectorName__c IN: statuses];
        
        Map<String, String> paramMap = new Map<String, String>();
        for(FormParameter__c fp : params){
            paramMap.put( fp.SelectorName__c.toLowerCase(), fp.ParameterValue__c );
        }
        
        statusMessages = new Map<String, String>();
        statusCodes = new List<String>();
        
        for(String status : detailStatusCodes){
            
            if( paramMap.containsKey( status.toLowerCase() )){
                statusCodes.add( status );
                statusMessages.put( status, paramMap.get( status.toLowerCase() ));
            }
        }
        NumStatusCodes = statusCodes.size();
        
    }
    
    public List<DetailStatus> getDetailStatuses(){ return details; }
    
    private Boolean validate(){ 
        
        StyleRebateNumber = StyleOK;
        StylePostalCode = StyleOK;
        Boolean isValid = true;
        
        if( Utils.isEmpty(RebateNumber) ){
            StyleRebateNumber = StyleError;
            isValid = false;
        }
        return isValid;
    }
    
    private void showNoResults(){
        NoResultsReturned = true;
        
        FormParameter__c[] params = new List<FormParameter__c>(
          [select id, ParameterValue__c FROM FormParameter__c 
          WHERE ParameterName__c =: 'StatusPage' AND SelectorName__c =: 'NoResults' AND FormId__r.FormCode__c =: FormCode]);
                
        if( params == null || params.isEmpty() ){
          NoResultsText = 'We are unable to locate a rebate that matches the information provided.';
          return;
        }
        
        NoResultsText = params[0].ParameterValue__c;
    }
    
    @isTest(SeeAllData=true)
    public static void testIt(){
        PageReference pageRef = Page.FormLIPA2011RF_Status;
        Test.setCurrentPage(pageRef);
        Rebate__c r = new Rebate__c();
        r.PdxAccountNumber__c = '111111111';
        r.RebateStatus__c = 'Submitted';
        r.MailingZipcode__c = '01430';
        r.FormCode__c = 'SGERF2012';
        
        insert r;
        r = [select id, rebateNumber__c from Rebate__c where id = :r.id];
        
        RebateDetail__c d = new RebateDetail__c(RebateId__c = r.id, DetailStatus__c = 'eSubmit', ModelNumber__c = '1234', Manufacturer__c = 'Amana');
        insert d;
        
        FormStatusControllerMM controller = new FormStatusControllerMM();
        Test.startTest();
        controller.findRebate();
        
        controller.PostalCode = '01430';
        controller.RebateNumber = '12345';
        controller.FormCode = 'SGERF2012';
        controller.findRebate();
        
        controller.RebateNumber = r.RebateNumber__c;
        controller.findRebate();
        
        Test.stopTest();
    }

    class DetailStatus{
        
        public String ModelNumber {get; set;}
        public String Manufacturer {get; set;}
        public Double PayableAmount {get; set;}
        public Double Quantity {get; set; }
        public Double PayableMeasureAmount {get; set; }
        public String Status {get; set;}
        public String MeasureCategory {get;set;}
        public Date CheckMailDate {get; set;}
    }
}