trigger FormXModel_UpdateFxManufacturer on FormXModel__c (after delete, after insert, after update) {
    
    IndexedMap addFormMans = new IndexedMap(true);
    IndexedMap remFormMans = new IndexedMap(true);
    Set<String> addMans = new Set<String>();
    Set<String> remMans = new Set<String>();
    
    for(Integer i=0; i < Trigger.size; i++){
        
        //-- find candidates to add
        if(Trigger.isInsert || 
            (Trigger.isUpdate && 
                (Trigger.old[i].Manufacturer__c != Trigger.new[i].Manufacturer__c ||
                 Trigger.old[i].RecordCode__c != Trigger.new[i].RecordCode__c))){
                 
            addFormMans.setObject( Trigger.new[i].FormID__c, Trigger.new[i].Manufacturer__c + ':' + Trigger.new[i].RecordCode__c, 
                new ManRecordCode(Trigger.new[i].Manufacturer__c, Trigger.new[i].RecordCode__c) );
                
            addMans.add( Trigger.new[i].Manufacturer__c);
        }
        
        //-- find candidates to delete
         if(Trigger.isDelete || 
            (Trigger.isUpdate && 
                (Trigger.old[i].Manufacturer__c != Trigger.new[i].Manufacturer__c ||
                 Trigger.old[i].RecordCode__c != Trigger.new[i].RecordCode__c))){
                 
            remFormMans.setObject( Trigger.old[i].FormID__c, Trigger.old[i].Manufacturer__c + ':' + Trigger.old[i].RecordCode__c,
                new ManRecordCode(Trigger.old[i].Manufacturer__c, Trigger.old[i].RecordCode__c) );
                
            remMans.add( Trigger.old[i].Manufacturer__c );
        }
    }
    
    if( addMans.size() > 0 ){
        
        //-- load the manufacturer Ids so we can create the FxMan
        Map<String, String> manIds = new Map<String, String>();
        for(Manufacturer__c m : [select id, manufacturer__c from manufacturer__c where manufacturer__c in :addMans]){
            manIds.put( m.manufacturer__c, m.id);
        }
        
        //-- Check for existing FxMans.  An exact query would be tough to construct.  Use 'fuzzy' search and weed out in code
        IndexedMap dbFormMans = new IndexedMap();
        for( FormXManufacturer__c fxMan : [select Id, FormId__c, RecordCode__c, ManufacturerId__r.Manufacturer__c FROM FormXManufacturer__c WHERE FormID__c IN :addFormMans.keySet() AND ManufacturerId__r.Manufacturer__c IN :addMans]){
            dbFormMans.setObject( fxMan.FormID__c, fxMan.ManufacturerId__r.Manufacturer__c + ':' + fxMan.RecordCode__c, 
                new ManRecordCode(fxMan.ManufacturerId__r.Manufacturer__c,fxMan.RecordCode__c) );
        }
        
        //-- look for (formid, manufacturer) in db results.  Create if not found
        List<FormXManufacturer__c> newFxMans = new List<FormXManufacturer__c>();
        for(String formId : addFormMans.keySet()){
            //Set<Object> dbFxMans = dbFormMans.get(formId);
            for(Object manName : addFormMans.keySet(formId)){
                if( dbFormMans.getValue(formId, (String)manName) == null ){
                    System.debug('Looking for '+formId+', '+manName);
                    ManRecordCode fxm = (ManRecordCode)addFormMans.getValue( formId, (String)manName );
                    System.debug( 'INDEXES: '+ addFormMans.keySet() );
                    System.debug( 'KEYS: '+addFormMans.keySet(formId));
                    System.debug('FXM: '+fxm);
                    newFxMans.add( new FormXManufacturer__c(FormId__c = formId, RecordCode__c = fxm.RecordCode, ManufacturerId__c = manIds.get(fxm.Manufacturer)));
                }
            }
        }
        
        if( newFxMans.size() > 0)
            insert newFxMans;
    }
    
    if( remMans.size() > 0 ){
        
        //-- load existing FxMan.  Exact match tough - fuzzy match and weed out in code
        IndexedMap fxManMap = new IndexedMap();
        for(FormXManufacturer__c fxMan : [select Id, FormId__c, RecordCode__c, ManufacturerId__r.Manufacturer__c from FormXManufacturer__c where FormID__c in :remFormMans.keySet() AND ManufacturerId__r.Manufacturer__c in :remMans]){
            fxManMap.setObject( fxMan.FormId__c, fxMan.ManufacturerId__r.Manufacturer__c + ':' +fxMan.RecordCode__c, fxMan);
        }
        
        //-- check and see if there are any other Models that call for the same manufacturer (fuzzy match)
        MapSet dbFormMans = new MapSet();
        for(FormXModel__c fxModel : [select Id, FormId__c, RecordCode__c, Manufacturer__c from FormXModel__c where FormID__c IN :remFormMans.keySet() AND Manufacturer__c IN :remMans]){
            dbFormMans.addObject( fxModel.FormId__c, fxModel.manufacturer__c+':'+fxModel.RecordCode__c);
        }
        
        //-- if there is no other FxModel that shares the same man, then delete the FxMan
        List<FormXManufacturer__c> remFxMans = new List<FormXManufacturer__c>();
        for(String formId : remFormMans.keySet()){
            for(Object manName : remFormMans.keySet(formId)){
                if( !dbFormMans.containsValue(formId, (String)manName) ){
                    String sManName = (String)manName;
                    if( fxManMap.getValue(formId, sManName) != null ){
                        remFxMans.add( (FormXManufacturer__c)fxManMap.getValue(formId, sManName) );
                    }
                }
            }
        }
        
        if( remFxMans.size() > 0)
            delete remFxMans;
    }
    
    class ManRecordCode{
        public String Manufacturer {get; set;}
        public String RecordCode {get; set;}
        
        public ManRecordCode(String man, String rCode){
            Manufacturer = man;
            RecordCode = rCode;
        }
    }
}