trigger FormField_SetName on FormFields__c (before insert, before update) {
    
    MapList formFields = new MapList(true);
    for(FormFields__c ff : Trigger.new){
        System.debug('ADDING: '+ff.FormId__c);
        formFields.addObject(ff.FormId__c, ff);
    }
    
    if( formFields.isEmpty() ) return;
    
    List<Form__c> forms = [select id, formCode__c from Form__c where ID in :formFields.keySet()];
    Map<String ,String> formMap = new Map<String, String>();
    
    for(Form__c f : forms){
        formMap.put(f.id, f.formCode__c);
    }
    
    for(String formId : formFields.keySet()){
        String code = formMap.get(formId);
        for(Object o : formFields.get(formId)){
            FormFields__c ff = (FormFields__c)o;
            ff.Name = (code != null ? code : '<null>') + ' | ' + ff.TargetTable__c + ' | ' + ff.FieldName__C;
        }
    }
}