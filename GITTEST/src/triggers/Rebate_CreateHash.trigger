trigger Rebate_CreateHash on Rebate__c (after insert) {
    
    List<Rebate__c> rebates = new List<Rebate__c>();
    for(Rebate__c oldRebate : Trigger.new){
        Rebate__c newRebate = new Rebate__c( id = oldRebate.id );
        newRebate.HashCode__c = EncodingUtil.base64Encode(Crypto.generateDigest( 'SHA-256', Blob.valueOf(oldRebate.id) ));
        rebates.add(newRebate);
    }
    
    if( !rebates.isEmpty() ){
        update rebates;
    }
}