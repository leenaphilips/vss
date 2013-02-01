/*
 * Sends an email to the customer related to the rebate related to the NCA if:
 *    1. The related Form isActive
 *    2. The Form isLegacy AND the rebate is in a NCA status and there exists a corresponding formparam with a true value.
 *    3. The Form is NOT legacy AND one of the details is in an NCA status and there exists a corresponding form param w/ a true value
 */
 
public class NcaEmailMgr {
  
  private boolean isTest = false;
  private EmailMgr emailMgr = new EmailMgr();
  
  public NcaEmailMgr(){
      this(false);
  }
  
  private NcaEmailMgr(boolean isTest){
      this.isTest = isTest;
      emailMgr.isApexTest = isTest;
  }
  
  public Boolean sendEmail(ID ncaLetterId){
    
    NcaLetter__c letter = [select Id, NcaId__c FROM NcaLetter__c WHERE id = :ncaLetterId];
    System.debug('LETTER: '+letter);
    
    Rebate__c[] rebates = [select Id, RebateStatusMM__c, ContactId__c, ContactId__r.Email, FormId__r.Id, FormId__r.FormCode__c, FormId__r.IsLegacy__c,
        FormId__r.ClientCode__c, FormId__r.IsActive__c, IsReminderEmail__c, FormId__r.EmailReplyTo__c, (SELECT Id, DetailStatus__c FROM RebateDetails__r 
            WHERE IsCustomerPayable__c = true and DetailStatus__c IN ('Non-Compliant', 'Denied', 'Expired') )
        FROM Rebate__c WHERE RebateStatusMM__c IN ('Non-Compliant', 'Denied', 'Expired', 'Processing') AND ncaId__c = :letter.NcaId__c]; // AND FormId__r.IsActive__c = true
   
    System.debug('Rebates: '+rebates);
    
    if( rebates == null || rebates.isEmpty() )
        return false;
        
    Rebate__c rebate = null;
    for(Rebate__c r : rebates){
        if( r.ContactId__r == null || r.FormId__r == null || Utils.isEmpty(r.ContactId__r.Email) || r.ContactId__r.Email.equals('test@test.test') || (!isTest && !r.FormID__r.IsActive__c))
            continue;
        
        rebate = r;
        break;
    }
    
    if( rebate == null ) return false;
    
    //-- select all StatusEmail formparams that pertain to this form.
    FormParameter__c[] params = [select SelectorName__c, ParameterValue__c 
        from FormParameter__c 
        where formId__c = :rebate.FormId__r.id AND ParameterName__c = 'NcaEmail'];
  
    if( params.isEmpty() ) return false;
    
    //-- create map status->sendEmail?
    Map<String, Boolean> statusMap = new Map<String, Boolean>();
    for(FormParameter__c p : params){
        Boolean process = false;
        try{
            process = Boolean.valueOf( p.ParameterValue__c );
        } catch(Exception e){}
        
        statusMap.put( p.SelectorName__c.toLowerCase() , process );
    }
    
    //-- check for a NCA, customer-payable detail whose status exists as sendable in the map  
    String statusType = null;
    if( !rebate.FormId__r.IsLegacy__c ){
        if( rebate.RebateDetails__r != null ){
            for(RebateDetail__c d : rebate.RebateDetails__r){
                if( statusMap.get( d.DetailStatus__c.toLowerCase() ) != null && statusMap.get(d.DetailStatus__c.toLowerCase() )){
                    //return sendEmail(ncaLetterId, rebate);
                    statusType = d.DetailStatus__c;
                    break;
                }
            } 
        }
    } else {
    
        if( statusMap.get( rebate.RebateStatusMM__c.toLowerCase() ) != null && statusMap.get( rebate.RebateStatusMM__c.toLowerCase() )){
            //return sendEmail(ncaLetterId, rebate);
            statusType = rebate.RebateStatusMM__c;
        }
    }
    
    return statusType != null ?
        emailMgr.sendEmail(ncaLetterId, rebates[0].ContactId__c, rebates[0].FormId__r.FormCode__c, rebates[0].FormId__r.ClientCode__c, statusType, false, rebates[0].FormId__r.EmailReplyTo__c) :
        false;
        
   
     
    return false;
  }
 
  @isTest(SeeAllData=true)
  private static void doIt(){
    Contact c = new Contact(FirstName='Chris', LastName ='Vitone', Email='Cvitone@gmail.com');
    insert c;
    
    Rebate__c r = new Rebate__c();
    r.FormCode__c = 'SGERF2012';
    r.Name = 'TEST'; 
    r.ContactID__c = c.id;
    insert r;
    
    RebateDetail__c rd = new RebateDetail__c( RebateId__c = r.id, Manufacturer__c = 'TEST', ModelNumber__c = '123', DetailStatus__c = 'Non-Compliant' );
    insert rd;
    
    r = [select id, formId__c from Rebate__c where id =: r.id];
    System.assert(r.formId__c != null, 'FormID is null');
    
    NCA__c n = new NCA__c(Name='TestNCA', PdxId__c = 'TEST');
    insert n;
    
    r.ncaId__c = n.id;
    update r;
    
    NcaLetter__c l = new NcaLetter__c(ncaId__c = n.id, letter__c = 'Letter_1', name = 'TEST LETTER 1', HasDetails__c = false, Type__c = 'C', Header__c = 'Header', Footer__c = 'Footer', PdxId__c = 'TEST LETTER 1');
    insert l;

    NcaEmailMgr nMgr = new NcaEmailMgr(true);
    System.assert(nMgr.sendEmail(l.id));
  }
}