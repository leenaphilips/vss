/**
    Man, I wrote this like an idiot.
*/
trigger FormParameter_Maint on FormParameter__c (before insert, before update) {
    MapList formParamMap = new MapList();
    for (FormParameter__c fp: Trigger.new) {
        formParamMap.addObject(fp.FormId__c, fp);
        /*fid = fp.FormID__c;
        for (Form__c f: [select FormCode__c from Form__c where ID = :fid]) {
            fp.Name = f.FormCode__c + ' | ' + fp.ParameterName__c + ' | ' + fp.SelectorName__c;     
        }*/
    }
    
    Map<ID, Form__c> forms = new Map<ID, Form__c>([select id, FormCode__c FROM Form__c where ID IN :formParamMap.keySet()]);
    for(String formId : formParamMap.keySet()){
        Form__c f = forms.get(formId);
        if(f == null ){
            continue;
        }
        
        for(Object o : formParamMap.get(formId)){
            FormParameter__c fp = (FormParameter__c)o;
            fp.Name = f.FormCode__c + ' | ' + fp.ParameterName__c + ' | ' + fp.SelectorName__c;
        }
    }
}