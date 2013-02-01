/*
 * 2012.07.12:CEV::orders before triggers in a cleaner manner. 
 *
 */
trigger RebateDetail_BeforeLauncher on RebateDetail__c (before insert, before update) {

    System.debug('TRIGGER RUNNING');
    Trigger_Class[] handlers = new Trigger_Class[]{
        new Trigger_RebateDetail_SendEmail(),    //--sends status emails
        new Trigger_RebateDetail_UpdateLookups() //--sets modelID and measureID, resets isSentFromPDX
    };
    
    for(Trigger_Class tc : handlers){
       System.debug('HANDLER');
       if( tc.canHandle() )
           tc.process();
    }
}