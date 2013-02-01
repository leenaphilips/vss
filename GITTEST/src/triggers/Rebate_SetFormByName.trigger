/**
  * CEV::2011.11.23
  *
  * Sets the Form for the Rebate using the webform-supplied Form Code.  The form is required prior to saving the 	
  * rebate as it contains the information required to locate the template as well as to fill out template fields.
  *
  **/

trigger Rebate_SetFormByName on Rebate__c (before insert) {
	
	Map<String, ID> formMap = new Map<String, ID>();
	for(Rebate__c r : Trigger.new){
		if( r.FormCode__c != null && r.FormCode__c.trim() != '' ){
			formMap.put(r.FormCode__c.toLowerCase(), null);
		}
	}
	
	if( !formMap.isEmpty()){
		for(Form__c f : [select Id, FormCode__c from Form__c where FormCode__c IN :formMap.keySet()]){
			formMap.put( f.formcode__c.toLowerCase(), f.id );
		}
		
		for(Rebate__c r : Trigger.new){
			r.FormId__c = formMap.get( r.formCode__c != null ? r.formCode__c.toLowerCase() : null );
		}
	}
}