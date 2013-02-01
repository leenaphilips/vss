trigger CustomReport_SetAccount on CustomReport__c (before insert, before update) {

    MapList reportsByForm = new MapList(true);
    
    for(CustomReport__c r : Trigger.new){
        if( r.FormID__c != null ){
            System.debug('Adding new custom report for form '+r.FormId__c+': '+r);
            reportsByForm.addObject( r.FormId__c, r );
        }
    }
    
    if( reportsByForm.isEmpty() ){
        System.debug('No custom reports');
        return;
    }
        
    Map<ID, Form__c> forms = new Map<ID, Form__c>();
    
    System.debug('Loading forms that match custom reports');
    for(Form__c f : [select Id, AccountID__c from Form__c where ID IN :reportsByForm.keySet()]){
        System.debug('Adding form '+f.id+': '+f);
        forms.put( f.id, f );
    }
    
    for(ID formID : forms.keySet()){
         System.debug('Iterating over forms: '+formId);
         for(Object r : reportsByForm.get(formId)){
             System.debug('Iterating over reports: '+r);
             CustomReport__c c = (CustomReport__c)r;
             c.AccountID__c = forms.get(formId).accountId__c;
         }
    }
}