trigger NcaLetter_SendEmail on NcaLetter__c (before insert, before update) {
    
    NcaEmailMgr nMgr = new NcaEmailMgr();
    for(NcaLetter__c letter : Trigger.new){
        
        if( letter.SendNcaEmail__c ){
            letter.SendNcaEmail__c = false;
            nMgr.sendEmail( letter.id );
        }
    }
    
}