/* Vitone::2012.02.17
 * 
 * Deletes SessionData objects when their DeleteMe flag is set.  This field is commonly set by a workflow rule that is configured
 * to run 24 hours after the object has been created.
 *
 */
trigger SessionData_DeleteMe on SessionData__c (after update) {
    
    Set<ID> toDelete = new Set<ID>();
    for(SessionData__c s : Trigger.new){
        if( s.deleteMe__c )
            toDelete.add(s.id);
    }
    
    if( toDelete.size() > 0 ){
    	Utils.deleteSObjects(toDelete, 'SessionData__c');
    }
    
}