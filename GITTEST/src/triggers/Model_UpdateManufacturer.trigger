trigger Model_UpdateManufacturer on Model__c (after delete, after insert, after update) {

    Set<String> addMans = new Set<String>();
    Set<String> remMans = new Set<String>();
    
    Set<String> remModels = new Set<String>();
    
    for(Integer i=0; i < Trigger.size; i++){
        
        if( Trigger.isInsert || (Trigger.isUpdate && Trigger.old[i].Manufacturer__c != Trigger.new[i].Manufacturer__c)){
            addMans.add( Trigger.new[i].Manufacturer__c);
        }
        
        if(Trigger.isDelete || (Trigger.isUpdate && Trigger.old[i].Manufacturer__c != Trigger.new[i].Manufacturer__c) ){
            remMans.add( Trigger.old[i].Manufacturer__c);
            
            if( Trigger.isDelete )  
                remModels.add( Trigger.old[i].Id );
        }
    }
    
    if( addMans.size() > 0 ){
        
        Set<String> dbMans = new Set<String>();
        for(Manufacturer__c man : [select Id, Manufacturer__c from Manufacturer__c where Manufacturer__c IN :addMans]){
            dbMans.add( man.Manufacturer__c);
        }
        
        Manufacturer__c[] newMans = new List<Manufacturer__c>();
        for(String man : addMans){
            if( !dbMans.contains(man) ){
                newMans.add( new Manufacturer__c(Name=man, Manufacturer__c = man));
            }
        }
        
        if( newMans.size() > 0) insert newMans;
    }
    
    
    if( remMans.size() > 0){
        Map<String, Manufacturer__c> dbMans = new Map<String, Manufacturer__c>();
        for(Manufacturer__c man : [select id, manufacturer__c from Manufacturer__c where Manufacturer__c in: remMans]){
            dbMans.put( man.manufacturer__c, man);
        }
        
        Set<String> dbModelMans = new Set<String>();
        for(Model__c m : [select id, Manufacturer__c from Model__c where Manufacturer__c IN :remMans]){
            dbModelMans.add( m.manufacturer__c);
        }
        
        Manufacturer__c[] delMans = new List<Manufacturer__c>();
        for(String man : remMans){
            if( !dbModelMans.contains(man) && dbMans.containsKey(man)){
                delMans.add( dbMans.get(man));
            } else if( dbModelMans.contains(man) && !dbMans.containsKey(man)){
                System.debug('wtf is this!: '+man);
            }
        }
        
        if( delMans.size() > 0 ){
            
            delete delMans;
        }
    }
    
    if( remModels.size() > 0 ){
        delete [select id from FormXModel__c where ModelId__c IN :remModels];
    }
}