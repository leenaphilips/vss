/*
 * 2012.07.02:Vitone::Move reminders here for now.  EVT requires custom ReplyTo which cannot be done via workflow.  May want to track Reminder # so we can swap template
 * 2012.06.25:Vitone::Allow for form specific senders.  Add replyto.
 * 2012.06.20:Vitone::Change to support Std. Email Package.  Global emails are named for the DetailStatus__c values
 */
public class EmailMgr{

    public Boolean isApexTest = false;
    
    //-- TODO:Don't assume form exists in rebate.  Add param
    public boolean sendEmail(ID whatId, ID contactId, String formCode, String clientCode, String statusType, boolean isReminder, String replyTo){
    
        String templateId = null;
        for(String baseName : new String[]{formCode+' - ', clientCode+' - ', ''}){
          String templateName = baseName + statusType + (isReminder ? ' - Reminder' : '');
          if( (templateId = getTemplateId(templateName)) != null )
            break;
        }
        
        if( Utils.isEmpty(templateId)){
          return false;
        }
        
        ID senderId = Utils.getEmailOrgId(formCode);
        send(whatId, contactId, templateId, senderId, replyTo);
        return true;
      }
      
  
  public static ID getTemplateId(String templateName){
    System.debug('LOOKING FOR EMAIL TEMPLATE NAMED '+templateName);
    EmailTemplate t = (EmailTemplate)Utils.getFirstOrNull([select Id, Name from EmailTemplate where name =: templateName]);
    return t != null ? t.id : null;
  }
  
  public static ID getOrgEmailId(String name){
        ID senderId = null;
        for(OrgWideEmailAddress owa : [select id, address from OrgWideEmailAddress]){
            if( owa.address.equalsIgnoreCase(name)){
                return owa.id;
            }
        }
        return null;
  }
  
  public void send(ID whatId, ID contactId, ID templateId, ID orgEmailId, String replyTo){

      Messaging.SingleEmailMessage m = new Messaging.SingleEmailMessage();
      //m.setSenderDisplayName( name );
      if( !Utils.isEmpty(replyTo)) 
          m.setReplyTo(replyTo);
          
      m.setOrgWideEmailAddressId(orgEmailId);
      m.setWhatId(whatId);
      m.setTemplateId(templateId);
      m.setTargetObjectId( contactId );
      
      System.debug('EMAIL MESSAGE: '+m);
      Messaging.SendEmailResult res = Messaging.SendEmail( new Messaging.Email[]{ m } )[0];
      
      if(!res.isSuccess() || isApexTest ){
          String[] messages = new List<String>();
          for(Messaging.SendEmailError e : res.getErrors()){
            messages.add( e.getMessage() );
          }
          
          EmailException e = new EmailException( Utils.concat(messages) );
          e.errors = res.getErrors();
          
          if( !isApexTest ) throw e;
      }
  }

}