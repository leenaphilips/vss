/* Vitone:2012.02.17
 *
 *  Re-sets the manufacturer for insert/updated models using the mapping in the DataCleanup object.  Required because Paradox is dirtier than
 *    prostitute's mouth
 *
 * Vitone:2012.02.20::Changed to make case insensitive for original values
 */
trigger Model_CleanManufacturer on Model__c (before insert, before update) {

    MapList models = new MapList(false);
    
    for(Model__c m : Trigger.new){
        if( m.manufacturer__c != null && m.manufacturer__c.trim() != ''){
            models.addObject( m.manufacturer__c.toLowerCase(), m );
        }
    }
    
    if( models.isEmpty() ) return;
    
    //-- this will return case-insensitive matches.  we must check the values
    for(DataCleanup__c dc : [select originalValue__c, newValue__c from DataCleanup__c where classification__c = 'Manufacturer' and originalValue__c IN :models.keySet()]){
        
        if( !models.containsKey(dc.originalValue__c.toLowerCase()))
            continue;
        
        for(Object o : models.get(dc.originalValue__c.toLowerCase())){
            Model__c m = (Model__c)o;
            m.manufacturer__c = dc.newValue__c;
        }
    }
}