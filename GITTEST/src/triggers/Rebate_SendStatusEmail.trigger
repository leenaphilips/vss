trigger Rebate_SendStatusEmail on Rebate__c (before update) {
  
  RebateEmailMgr emailMgr = new RebateEmailMgr();
  for(Integer i=0; i < Trigger.size; i++){
      Rebate__c oldRebate = Trigger.old[i];
      Rebate__c newRebate = Trigger.new[i];
      
      if( oldRebate.SendStatusEmail__c && !newRebate.SendStatusEmail__c ){
          emailMgr.sendEmail(newRebate.id);
          newRebate.IsReminderEmail__c = false;
      }
  }

}