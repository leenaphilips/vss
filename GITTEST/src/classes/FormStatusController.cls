public without sharing class FormStatusController {

    private static final String StyleError = 'display:inline';
    private static final String StyleOK = 'display:none';
    
    public String RebateNumber {get; set; }
    public String PostalCode {get; set; }
    public String FormCode {get; set;}
    
    public String Status {get; set; }
    public String Description {get; set;}
    public Date ReceivedDate {get; set; }
    public Double RebateAmount {get; set; }
    public String MailingAddress {get; private set; }
    
    public String StyleRebateNumber{get; set; }
    public String StylePostalCode{get; set; }
    
    public Boolean NoResultsReturned {get; private set; }
    public String NoResultsText {get; private set; }
    
    public FormStatusController(){
        NoResultsReturned = false;
        StyleRebateNumber = StyleOK;
        StylePostalCode = StyleOK;
        
        RebateNumber = ApexPages.currentPage().getParameters().get('RebateNumber');
        PostalCode = ApexPages.currentPage().getParameters().get('PostalCode');
        FormCode = ApexPages.currentPage().getParameters().get('FormCode');
        
        //if( !Utils.isEmpty(RebateNumber) && !Utils.isEmpty(PostalCode) && !Utils.isEmpty(FormCode)){
        if( !Utils.isEmpty(RebateNumber) && !Utils.isEmpty(FormCode)){
            findRebate();
        }
    }
    
    public PageReference findRebate(){
        NoResultsReturned = false;
        Status = null;
        
        if( Utils.isEmpty(FormCode)){
            ApexPages.addMessage( Utils.createErrorMessage('The FormCode variable has not been specified.  Please contact EFI'));
            return null;
        }
        
        if( !validate() ){
            ApexPages.addMessage( Utils.createErrorMessage('Please correct the errors below'));
            return null;
        }
        
        List<Rebate__c> rebates = [select Id, RebateStatus__c, TotalRebateAmount__c, CustomerRebateAmount__c, CheckMailDate__c, ReceivedDate__c, FormID__c
            FROM Rebate__c where MailingZipcode__c = :PostalCode AND RebateNumber__c = :RebateNumber and FormID__r.FormCode__c = :FormCode];
            
        if( rebates.size() != 1){
            NoResultsReturned = true;
            
            FormParameter__c[] params = new List<FormParameter__c>([select id, ParameterValue__c FROM FormParameter__c WHERE ParameterName__c =: 'StatusPage' AND SelectorName__c =: 'NoResults' AND FormId__r.FormCode__c =: FormCode]);
            if( params == null || params.isEmpty() ){
                NoResultsText = 'We are unable to locate a rebate that matches the information provided.';
                return null;
            }
            
            NoResultsText = params[0].ParameterValue__c;
            
            return null;
        }
        
        Rebate__c r = rebates.get(0);
        
        List<FormParameter__c> rebateStatuses = [select id, ParameterValue__c from FormParameter__c 
                where FormID__c =: r.FormID__c and ParameterName__c = 'RebateStatus' and SelectorName__c =: r.RebateStatus__c];
         
        if( rebateStatuses.size() == 1){
                Description = rebateStatuses.get(0).ParameterValue__c;
        }
        
        String paidDate = '';
        if( r.CheckMailDate__c != null ){
            paidDate = r.CheckMailDate__c.Month()+'/'+r.CheckMailDate__c.Day()+'/'+r.CheckMailDate__c.Year();
        }
        
        if( Description != null ) Description = Description.replace('{!paidDate}', paidDate); //.replace('\n', '<br/>')
        
        Form__c f = [select id, MailingName__c, MailingStreet1__c, MailingStreet2__c, MailingCity__c, MailingState__c, MailingZipCode__c FROM Form__c where formCode__c =: FormCode][0];
        
        MailingAddress = f.MailingName__c + '<br/>' + f.MailingStreet1__c + '<br/>' + 
            (Utils.IsEmpty(f.MailingStreet2__c) ? '' : f.MailingStreet2__c+'<br/>') + f.MailingCity__c + ', ' + f.MailingState__c + ' ' +f.MailingZipCode__c;
        
        Status = r.RebateStatus__c;
        ReceivedDate = r.ReceivedDate__c;
        RebateAmount = r.CustomerRebateAmount__c;
        
        return null; 
    }
    
    private Boolean validate(){ 
        
        StyleRebateNumber = StyleOK;
        StylePostalCode = StyleOK;
        Boolean isValid = true;
        
        if( Utils.isEmpty(RebateNumber) ){
            StyleRebateNumber = StyleError;
            isValid = false;
        }
        /*
        if( Utils.isEmpty(PostalCode) ){
            StylePostalCode = StyleError;
            isValid = false;
        }
        */
        return isValid;
    }
    
    public static testMethod void testIt(){
        PageReference pageRef = Page.FormLIPA2011RF_Status;
        Test.setCurrentPage(pageRef);
        Rebate__c r = new Rebate__c();
        r.PdxAccountNumber__c = '111111111';
        r.RebateStatus__c = 'Submitted';
        r.MailingZipcode__c = '01430';
        r.FormCode__c = 'LIRF2012';
        
        insert r;
        r = [select id, rebateNumber__c from Rebate__c where id = :r.id];
        
        FormStatusController controller = new FormStatusController();
        Test.startTest();
        controller.findRebate();
        
        controller.PostalCode = '01430';
        controller.RebateNumber = r.RebateNumber__c;
        controller.FormCode = 'LIRF2012';
        controller.findRebate();
        
        Test.stopTest();
    }
}