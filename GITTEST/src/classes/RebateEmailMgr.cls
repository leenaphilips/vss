/* 2011.12.15::Vitone
 * 
 * Sends an email to the Rebate's contact depending on the current status of the rebate.  This class does not track or deal
 * with the fact that an email for the current status may have been previously sent to the contact.  That responsibility is
 * up to the caller to enforce.
 *
 * TODO: What if a detail orginally sets this flag and before the email is sent, it falls out of this status?
 *
 * 2012.10.08:CEV:: Added Form.IsEmailActive__c to allow for disabling of emails for active programs
 *
 * 2012.07.16:CEV:: RebateDetail trigger now decides if an email should be sent and sets the flag.  We only need to check if the Form is still active.
 *
 * 2012.06.25:Vitone::Add support for ReplyTo
 *
 */
public class RebateEmailMgr {

  public EmailMgr eMgr = new EmailMgr();
  private boolean isTest = false;
  
  public RebateEmailMgr(){
      this(false);
  }
  
  private RebateEmailMgr(boolean isTest){
      this.isTest = isTest;
      eMgr.isApexTest = isTest;
  }
  
  public Boolean sendEmail(ID rebateId){
    
    Rebate__c rebate = loadRebate(rebateId);
    
    if( rebate == null ) return false;
   
    return eMgr.sendEmail(rebateId, rebate.ContactId__c, rebate.FormId__r.FormCode__c, rebate.FormId__r.ClientCode__c, rebate.RebateStatusMM__c, rebate.IsReminderEmail__c, rebate.FormId__r.EmailReplyTo__c);
  }
  
  public void sendAttachmentEmail(ID rebateId){
    Rebate__c rebate = loadRebate(rebateId);
    if( rebate == null ) return;
    
    ID senderId = EmailMgr.getOrgEmailId('documents-dev@efi.org');
    if( senderId == null ) return;
    
    ID templateId = EmailMgr.getTemplateId('Rebate Attachment');
    if(templateId == null ) return;
    
    eMgr.send(rebateId, rebate.contactId__c, templateId, senderId, null);  
  }
  
  private Rebate__c loadRebate(String rebateId){
    Rebate__c[] rebates = new List<Rebate__c>([select Id, Name, RebateStatusMM__c, FormId__r.Id, FormID__r.IsActive__c, 
        FormId__r.IsEmailActive__c, IsReminderEmail__c,
        FormId__r.FormCode__c, FormId__r.AccountId__r.Name, FormId__r.ClientCode__c, ContactId__c, ContactId__r.Email,
        FormId__r.EmailReplyTo__c 
        FROM Rebate__c where id =: rebateId AND contactId__c <> null AND contactId__r.Email <> null 
            AND contactId__r.Email <> '' AND contactId__r.Email <> 'test@test.test']);
    
    System.debug('RebateMgr::loadRebate::rebates: '+rebates);
    if( rebates == null || rebates.isEmpty() 
        || (!isTest && (!rebates[0].FormID__r.IsActive__c || !rebates[0].FormID__r.IsEmailActive__c))) 
        return null;
    return rebates[0];
  }
  
  @isTest(SeeAllData=true)
  static void test(){
    Contact c = new Contact(FirstName='Chris', LastName ='Vitone', Email='Cvitone@gmail.com');
    insert c;
    
    Rebate__c r = new Rebate__c();
    r.FormCode__c = 'LIRF2012';
    r.RebateStatus__c = 'eSubmit';
    r.Name = 'TEST';
    r.ContactID__c = c.id;
    insert r;

    RebateEmailMgr rMgr = new RebateEmailMgr(true);
    System.assert(rMgr.sendEmail(r.id));
    
  }
  
}