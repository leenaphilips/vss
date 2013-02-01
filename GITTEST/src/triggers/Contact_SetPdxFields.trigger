/*
    Set the lookup values based upon the fields that PDX sets
*/
trigger Contact_SetPdxFields on Contact (before update, before insert) {
    
    //-- Map of Program -> List of Contacts
    //Map<String, List<Contact>> toUpdate = new Map<String, List<Contact>>();
    MapList toUpdate = new MapList();
    
    if( Trigger.isInsert){
        for(Contact c : Trigger.new){
            
            //-- any new Contact sent from PDX automatically needs to update its values
            if( c.IsSentFromPdx__c ){
                c.IsSentFromPdx__c = false;
                
                //-- only those which have been blessed by PDX (could be implicit but this can be used as an escape)
                if( c.IsPdxValidated__c){
                    if( !Utils.isEmpty(c.PdoxProgramCode__c) ){
                        toUpdate.addObject( c.PdoxProgramCode__c, c );
                    } else {
                        c.AccountId = null;
                    }
                }
            }
        }
    } else {
        for(Integer i=0; i < Trigger.size; i++){
            Contact oldContact = Trigger.old[i];
            Contact newContact = Trigger.new[i];
            
            if( newContact.IsSentFromPdx__c){
                newContact.IsSentFromPdx__c = false;
                
                //-- a change in the PDX Program Code will switch the Account (maybe)
                if(newContact.IsPdxValidated__c && oldContact.PdoxProgramCode__c != newContact.PdoxProgramCode__c){
                    if( Utils.isEmpty( newContact.PdoxProgramCode__c )){
                        newContact.AccountId = null;
                    } else {
                        toUpdate.addObject( newContact.PdoxProgramCode__c, newContact );
                    }
                }
            }
        }
    }
    
    if( !toUpdate.isEmpty() ){
        //-- load all Forms (SF Programs) that match the new PDX Program values
        Map<String, String> formMap = new Map<String, String>();
        for(Form__c form: [select AccountId__c, PdoxProgramCode__c from Form__c where PdoxProgramCode__c IN :toUpdate.keySet()]){
            formMap.put( form.PdoxProgramCode__c.toLowerCase(), form.AccountId__c);
        }
        
        //-- update the Account accordingly
        for(String program : toUpdate.keySet() ){
            for(Object s : toUpdate.get( program )){
                Contact c = (Contact)s;
                c.AccountId = formMap.get( program );
            }
        }
    }
}