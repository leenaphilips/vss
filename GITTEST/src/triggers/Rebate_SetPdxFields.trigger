/*
    Sets the following lookups if and when PDX synchronizes a Rebate w/ SF
        1. ContactID
        2. FormID
*/

trigger Rebate_SetPdxFields on Rebate__c (before insert, before update) {

    MapList forms = new MapList();
    MapList contacts = new MapList();
    
    //-- For inserts, all need to be linked if they are valid & sent from PDX
    if( Trigger.isInsert ){
        for(Rebate__c r: Trigger.new){
            if( r.IsSentFromPdx__c ){
                r.IsSentFromPdx__c = false;
                
                if( r.IsPdxValidated__c){
                    if( r.FormCode__c == null ){
                        r.FormID__c = null;
                    } else {
                        forms.addObject(r.FormCode__c, r);
                    }
                    System.debug('FormCode__c: '+r.FormCode__c);
                    if( Utils.isEmpty(r.FormCode__c) ){
                       r.ContactId__c = null;
                    } else {
                        contacts.addObject( r.PdxAccountNumber__c, r);
                    }
                }
            }
        }
    }
    
    //-- for updates, check the fields that would cause the lookups to become valid
    //      this is essentially the PDX keys for the related objects
    if( Trigger.isUpdate ){
        for(Integer i=0; i < Trigger.size; i++){
            Rebate__c oRebate = Trigger.old[i];
            Rebate__c nRebate = Trigger.new[i];
            
            Boolean formChange = false;
            
            if( nRebate.IsSentFromPdx__c){
                nRebate.IsSentFromPdx__c = false;
                
                System.debug('Rebate is PDX Validated: '+nRebate.IsPdxValidated__c);
                if( nRebate.IsPdxValidated__c ){
                    if( oRebate.FormCode__c != nRebate.FormCode__c ){
                        System.debug('Form Code Changed: '+nRebate.FormCode__c);
                        //-- changing the form code invalidates both the Form and (potentially) the account
                        if( nRebate.FormCode__c != null ){
                            forms.addObject( nRebate.FormCode__c, nRebate);
                            //contacts.addObject( Utils.isEmpty(nRebate.PdxAccountNumber__c) ? '' : nRebate.FormCode__c+'|'+nRebate.PdxAccountNumber__c, nRebate);
                        } else {
                            nRebate.FormID__c = null; 
                            //nrebate.ContactID__c = null;
                        }
                    }
                    //-- changing the account number invalidates the Contact
                    if( oRebate.PdxAccountNumber__c != nRebate.PdxAccountNumber__c || oRebate.FormCode__c != nRebate.FormCode__c  ){
                        System.debug('Account Number Changed: '+nRebate.PdxAccountNumber__c);
                        //Utils.isEmpty(nRebate.PdxAccountNumber__c) || 
                        if( Utils.isEmpty(nRebate.FormCode__c) ){
                            nRebate.ContactId__c = null;
                        } else {
                            contacts.addObject(nRebate.PdxAccountNumber__c, nRebate);
                            System.debug('Current contact map: '+contacts);
                        }
                    }
                }
            }
        }
    }
   
    //-- update the form links first because they influence the lookup for the Contact
    if( !forms.isEmpty() ){
        
        System.debug('FORM CODES: '+forms.keySet());
        Map<String, Form__c> matchedForms = new Map<String, Form__c>();
        for(Form__c f : [select Id, FormCode__c, AccountId__c from Form__c where FormCode__c IN :forms.keySet()]){
            System.debug('RETRIEVED FORM: '+f);
            matchedForms.put( f.FormCode__c.toLowerCase(), f);
        }
        
        Map<ID, ID> rebateToAccountMap = new Map<ID, ID>();
        for(String formCode : forms.keySet()){
            Form__c matchedForm = matchedForms.get(formCode);
            
            System.debug('FOUND FORM: '+matchedForm);
            for(Object s : forms.get(formCode)){
                Rebate__c r = (Rebate__c)s;
                
                if( matchedForm == null ){
                    r.FormId__c = null;
                    r.ContactID__c = null;
                } else {
                    r.FormId__c = matchedForm.Id;
                    System.debug('FOUND FORM ID: '+r.FormId__c);
                }
            }
        }
    }
    
    //-- update contacts - a little more involved due to the multi-field key
    if( !contacts.isEmpty() ){
        Set<String> formCodes = new Set<String>();
        for(Object s : contacts.getAllValues()){
            Rebate__c r = (Rebate__c)s;
            formCodes.add(r.FormCode__c);
        }
        
        //-- load forms w/ AccountId --
        Map<String, String> formMap = new Map<String, String>();
        for(Form__c f : [select formCode__c, PdoxProgramCode__c from Form__c where FormCode__c IN :formCodes]){
            formMap.put( f.formCode__c.toLowerCase(), f.PdoxProgramCode__c );
        }
        System.debug('LOADED FORMS: '+formMap);
        
        MapList pdxContactIds = new MapList();
        for(Object o : contacts.getAllValues()){
            Rebate__c r = (Rebate__c)o;
            System.debug('Looking for form with code: '+r.FormCode__c);
            String programCode = formMap.get( r.FormCode__c.toLowerCase() );
            if( Utils.isEmpty(programCode) )
                r.ContactId__c = null;
            else{
                System.debug('Looking for Contact with PDX ID: '+programCode+'|'+(r.PdxAccountNumber__c == null ? '' : r.PdxAccountNumber__c));
               pdxContactIds.addObject( programCode+'|'+(r.PdxAccountNumber__c == null ? '' : r.PdxAccountNumber__c), r);
            }
        }
        
        Map<String, String> contactMap = new Map<String, String>();
        for(Contact c : [select id, PdxId__c from Contact where IsPdxValidated__c = true AND PdxId__c IN :pdxContactIds.keySet()]){
            contactMap.put( c.pdxId__c.toLowerCase(), c.id );
        }
        System.debug('Contacts: '+contactMap);
        
        for(String pdxId : pdxContactIds.keySet()){
            String contactId = contactMap.get(pdxId.toLowerCase());
            System.debug('Found Contact ID '+contactId+' for pdxID '+pdxId);
            for(Object o : pdxContactIds.get(pdxId)){
                Rebate__c r = (Rebate__c)o;
                r.ContactId__c = contactId;
            }
        }
     }

        //-- account number is unique across an account, not globally
/*        System.debug('Looking for Contacts matching account numbers: '+contacts.keySet());
        MapList mContacts = new MapList();
        for(Contact c : [select Id, AccountNumber__c, AccountId FROM Contact where IsPdxValidated__c = true AND AccountNumber__c IN :contacts.keySet()]){
            System.debug('Adding contact: '+c);
            mContacts.addObject( Utils.nullValue(c.AccountNumber__c, ''), c);
        }
        
        //-- try to match each account num on rebate with account num on Form
        for(String accountNumber : contacts.keySet()){
            //-- possible matches which all share same account num but potentially different accountIds
            List<Object> pContacts = mContacts.get(accountNumber);
            System.debug('Potential Matched: '+pContacts);
            
            //-- multiple rebates may share same actnum
            for(Object s : contacts.get(accountNumber)){
                Rebate__c r = (Rebate__c)s;
                
                if( pContacts == null ){
                    //-- no contacts returned - delete lookup
                    r.ContactID__c = null;
                    break;
                } else {
                    Contact matchedContact = null;
                    
                    //-- looks through pot. matches and find one that shares actID
                    for(Object po : pContacts){
                        Contact pc = (Contact)po;
                        
                        System.debug('Looking for Form with id: '+r.FormId__c);
                        if( formMap.get(r.FormId__c) != null && formMap.get(r.FormId__c).AccountId__c == pc.AccountId){
                            matchedContact = pc;
                            break;
                        }
                    }
                    
                    //-- may still not find one
                    r.ContactID__c = matchedContact != null ? matchedContact.Id : null;
                }
            }
        }
    }
    */
}