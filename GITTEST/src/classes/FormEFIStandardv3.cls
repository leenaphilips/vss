public virtual class FormEFIStandardv3 {

    public String thisFormCode = 'FORM'; // need to override
    public String thisFormID; // determined from form
    public String thisAccountID;  // determined from form
    public String thisClientCode; // determined from form
    // thisUserCode is a parameter
    public ID frmOwnerId; // determined from user
    // thisUtilityCode is a parameter
    public String thisRecordCode; // set in the custom controller (temporary solution, until multi-detail form)
    public String existingStatus {get; set; } // determine when you are creating vs. updating
    public String existingType {get; set; }
    public Contact rcont;   // same variable for showRebate and actionCheckMe
    public Rebate__c rreb;
    public Boolean reservationFlag;
    public ID budgetDSID;
    public Boolean formOpen {get; set; }
    public String totalAmountSaved {get; set; }
    public Decimal totalAmountSavedNum;
    public String totalAmountEdit {get; set; }
    public Decimal totalAmountEditNum;
    public Decimal totalAmountWarned;
    public String checklistContent {get; set; }
    public String documentCount {get; set; }
        
    public Boolean debugging = false;  // write some details to log when desired
    public String debugText {get; set; }
    public Boolean writeRecs = true; // can turn off for some testing/debugging
    public Boolean testMode = false; // populate form w/test values, otherwise initial values
    public Boolean showIcons = false; // show error icons, to test layout
    public String pCustCheck = 'soft'; // check account number in PCust (requires Zip code) = 'hard', 'soft', 'none'
    public String storeEntry = 'both'; // select, enter or both
    public String mailEntry = 'enter'; // same, enter or both
    
    public String resLabel {get; set; }
    public String appLabel {get; set; }
    public String viaElectLabel {get; set; }
    public String viaMailLabel {get; set; }
    public String emailRequestLabel {get; set; }
    public String softStopMessage {get; set; }
    public String hardStopMessage {get; set; }
            
    public String frmLoadMessage {get; set; }
    public String frmReadOnly {get; set; } // for non-VF inputs
    public String frmShowInvoice {get; set; } // for dialog    
    public String frmStatus {get; set; }
    public String frmRebateNum {get; set; }
    public String frmRebateID;
    public String frmPostalCode; // only used for showRebate, regular variable needed since may not be present on form
    public String frmHashCode;
    public String frmLimitedRebate {get; set; }
    public String frmMessageClosed {get; set; }
    public String frmColor1 {get; set; }
    public String frmColor2 {get; set; }
    public String frmColor3 {get; set; }

    public String frmButtonLabel {get; set; }
    public Boolean disableDE {get; set; } // to enable/disable data entry
    public String editClass {get; set; }
    public String displayClass {get; set; }

    public Boolean foundError;
    public Integer frmErrLevel;
    public Boolean wasError;  // was there an error when the form was previously checked

    public String saveSessionID {get; set; }    // for session management
    public String saveRebateNum;
    public String saveMailZip;

    public class SetupException extends Exception {}
    
    public List<selectOption> stateList {get; set; }
    public List<SelectOption> storeList = new List<SelectOption>(); 
    public List<SelectOption> modelList = new List<selectOption>();
        
    /*
    The following fields are initialized as params:
        initialStatus,      thisUserCode,       thisUtilityCode
        buttonTextInit,     buttonTextError,    buttonTextWarn,     buttonTextOk,       buttonTextView,     buttonTextReload
        messageTextOk,      messageTextError,   messageTextWarn,    messageTextDupe,    messageTextView,    messageTextReload
        messageClosed,      limitedRebate,      buttonTextOkRes,    messageTextOkRes,   buttonTextOkElect,  messageTextOkRes
    */
    
    public Map<String, String> params;

    public class FormField {
        public ID fieldID {get; set; }
        public String fieldName {get; set; }
        public String recordCode {get; set; }
        public String targetTable {get; set; }
        public String dataType {get; set; }
        public String stringValue {get; set; }
        public Decimal decimalValue {get; set; }
        public Date dateValue {get; set; }
        public Boolean booleanValue {get; set; }
        public String testValue {get; set; }
        public String initValue {get; set; }
        public String visibleWith {get; set; }
        public Boolean visibleState {get; set; }
        public String blankStop {get; set; }
        public String effBlankStop {get; set; }
        public String rangeStop {get; set; }
        public String effRangeStop {get; set; }
        public String scaleStop {get; set; }
        public String effScaleStop {get; set; }
        public String rangeMin {get; set; }
        public String rangeMax {get; set; }
        public Decimal scaleMax {get; set; }
        public String blankMessage {get; set; }
        public String rangeMessage {get; set; }
        public String scaleMessage {get; set; }
        public String invalidMessage {get; set; }
        public String warnMsg {get; set; }
        public String warnStyle {get; set; }
        public String errorMsg {get; set; }
        public String errorStyle {get; set; }
        public String errorValue {get; set; }
        public Decimal errorLevel {get; set; }
        public Boolean seenSoftError {get; set; }
        public String fieldLabel {get; set; }
        public Boolean doNotSave {get; set; }
        public Boolean skipPdoxSend {get; set; }
        public FormField (ID id, String fn, String rc, String tt, String dt, String tv, String iv, String vw, Boolean vs,
            String bs, String rs, String ss, String min, String max, Decimal sc, String bm, String rm, String sm, String im, 
            String fl, Boolean dns, Boolean sps) {
            fieldID = id;
            fieldName = fn;
            recordCode = rc;
            targetTable = tt;
            dataType = dt;
            stringValue = iv; // initialized
            if (stringValue == null) stringValue = '';
            decimalValue = null;
            dateValue = null;
            if ('Boolean'.equalsIgnoreCase(dataType)) { booleanValue = ('true'.equalsIgnoreCase(stringValue)); }
            testValue = tv;
            initValue = iv;
            visibleWith = vw;
            visibleState = vs;
            blankStop = bs;
            rangeStop = rs;
            scaleStop = ss;
            rangeMin = min;
            rangeMax = max;
            scaleMax = sc;
            blankMessage = (bm == null) ? '' : bm;
            rangeMessage = (rm == null) ? '' : rm;
            scaleMessage = (sm == null) ? '' : sm;
            invalidMessage = (im == null) ? '' : im;
            warnMsg = '';
            warnStyle = '';
            errorMsg = '';
            errorStyle = '';
            errorValue = '';
            errorLevel = 0;
            seenSoftError = false;
            fieldLabel = (fl == null) ? '' : fl;
            doNotSave = (dns == null) ? false : dns;
            skipPdoxSend = (sps == null) ? false : sps;
        }
    }
         
    public Map<String, FormField> formFields {get; set; }
    public Set<String> fieldSet;
    public Map<String, Decimal> fieldHardLimits;
    public Set<String> detailRecs;
    public Map<String, Decimal> measureAmount;
    
    public class DetailInfo {
        public String recordCode {get; set; }
        public String modelEntry {get; set; }
        public Boolean mfrLoaded {get; set; }
        public List<selectOption> mfrList {get; set;}
        public String modelMfr {get; set; }             // which manufacturer was the model list generated from?
        public List<selectOption> modelList {get; set; }
        public DetailInfo (String rcode, String metype) {
            recordCode = rcode;
            modelEntry = metype;
            mfrLoaded = false;
            mfrList = new List<selectOption>();
            modelMfr = '-x-';                           // use a value that is not likely, to force initialization
            modelList = new List<selectOption>();
        }
    }

    public Map<String, DetailInfo> details {get; set; }
    
    // the following are old 'new' items, delete when converted.
    // public Map<String,String> modelEntry = new Map<String, String>(); // select, enter or both for each
    // public Map<String, List<selectOption>> mfrList {get; set; }  // hold list for each measure type

    public FormEFIStandardv3() {
        String fn;
        debugText = '';
        details = new Map<String, DetailInfo>(); // initialize this first, so initializeConstructor has access
        params = new Map<String, String>();
        fieldHardLimits = new Map<String, Decimal>();
        formFields = new Map<String, FormField>();
        measureAmount = new Map<String, Decimal>();
        initializeConstructor();
        if (debugging) system.debug('EFILOG: Entered Base Constructor');
        // mfrList  = new Map<String, List<selectOption>>();
        getFormParameters();        // no longer hard-coded
        getFormFields();            // no longer hard-coded
        existingStatus = '';            // start as blank (creating a new reservation/rebate)
        existingType = '';
        totalAmountSaved = '';
        totalAmountSavedNum = 0;
        totalAmountEdit = '$0.00';
        totalAmountEditNum = 0;
        totalAmountWarned = 0;
        documentCount = '0';
        checklistContent = params.get('EmailBody.unsubmitted');
        softStopMessage = '';
        hardStopMessage = '';
        // initialize store amd model info
        stateList = makeStateList();
        // initialize reservation/application and submission options
        resLabel = params.get('ResLabelStd');
        appLabel = params.get('AppLabelStd');
        viaElectLabel = params.get('ViaElectLabel');
        viaMailLabel = params.get('ViaMailLabel');
        frmLimitedRebate = ''; // initialize
        frmMessageClosed = params.get('messageClosed');
        // frmRebateNum = ApexPages.currentPage().getParameters().get('RebateNumber');
        // frmPostalCode = ApexPages.currentPage().getParameters().get('PostalCode');
        frmHashCode = ApexPages.currentPage().getParameters().get('Auth');
        if (!Utils.isEmpty(frmHashCode)) {
                showRebate();
                return;
        }
        disableDE = formOpen ? false : true;
        frmReadOnly = formOpen ? 'no' : 'yes';
        displayClass = 'displayfield';
        editClass = 'editenabled';
        frmRebateID = 'not checked';
        frmRebateNum = '';
        if (showIcons) {
            showErrorIcons();               
        } else {
            clearErrorIcons();
        }
        clearErrorLevels();
        foundError = false;
        frmErrLevel = 0;
        frmLoadMessage = '';
        frmShowInvoice = '';
        frmButtonLabel = params.get('buttonTextInit'); // override default for first view
        // determine owner ID for created records
        frmOwnerID = null;
        for (User u : [select ID, Name from User where UserCode__c = :params.get('thisUserCode')] ) {
            frmOwnerId = u.ID;
        }
        fn = 'Rebate__c.ManualStoreFlag';
        if (fieldSet.contains(fn)) formFields.get(fn).booleanValue = false; // start unchecked
        for (String dr: detailRecs) {
            fn = 'RebateDetail__c.ManualModelFlag.'+dr;
            if (fieldSet.contains(fn)) formFields.get(fn).booleanValue = false;
            fn = 'RebateDetail__c.MeasureCode__c.'+dr;
            if (fieldSet.contains(fn)) formFields.get(fn).stringValue = formFields.get(fn).initValue; 
            fn = 'RebateDetail__c.MeasureRebateAmount__c.'+dr;
            if (fieldSet.contains(fn)) {
                formFields.get(fn).stringValue = formFields.get(fn).initValue;
                try { formFields.get(fn).decimalValue = Decimal.valueOf(formFields.get(fn).stringValue); }
                catch (Exception e) {formFields.get(fn).decimalValue = 0; }
            } 
        }
        if (testMode) testInit();  // initialize form with test data
        makeModelList();            // can initialize, once all the fields are known (including initialization)
    }
        
    public virtual void initializeConstructor () {
        // override in extension to place code before constructor body
    }

    public void initializeSession() {
        saveSessionID = Utils.createSessionID(); // get it the new way
        Utils.saveSessionData(saveSessionID, 'RebateNumber', '');
        Utils.saveSessionData(saveSessionID, 'MailZipcode', '');
    }
 
    public void getSessionData() {
        saveRebateNum = Utils.getSessionData(saveSessionID, 'RebateNumber');
        saveMailZip = Utils.getSessionData(saveSessionID,'MailZipcode');
    }

    /* supports 'select *' functionality, but there is a rights issue preventing its use on the public sites
    public String buildSQL(String objName){
        String[] fields = new List<String>();
        for(Schema.Sobjectfield f : Schema.getGlobalDescribe().get(objName.toLowerCase()).getDescribe().Fields.getMap().values()){
            if( f.getDescribe().isCreateable()){
                fields.add( f.getDescribe().getName() );
            }
        }
        return 'SELECT '+Utils.concat(fields, ', ')+' FROM '+objName;
    }
    */
        
    public void getFormParameters() {
        // get form ID from form code
        thisFormID  = null;
        for (Form__c f: [select ID, FormCode__c, AccountID__c, ClientCode__c, ReservationFlag__c, BudgetDSID__c,
            PrimaryColor__c, SecondaryColor__c, TertiaryColor__c from Form__c 
            where FormCode__c = :thisFormCode] ) {
            thisFormID = f.ID;
            thisAccountID = f.AccountID__c;
            thisClientCode = f.ClientCode__c;
            reservationFlag = f.ReservationFlag__c;
            budgetDSID = f.BudgetDSID__c;
            frmColor1 = f.PrimaryColor__c;
            frmColor2 = f.SecondaryColor__c;
            frmColor3 = f.TertiaryColor__c;
        }
        if (thisFormID == null) throw new SetupException('Form not defined!');
        // then get the parameters
        for (FormParameter__c fp: [select ParameterName__c, SelectorName__c, ParameterValue__c
            from FormParameter__c where FormID__c = :thisFormID]) {
            Params.put(fp.ParameterName__c+(Utils.isEmpty(fp.SelectorName__c) ? '' : '.'+fp.SelectorName__c), fp.ParameterValue__c);
        }
        // initialize required parameters, if missing (just in case)
        if (!params.containsKey('EmailBody.unsubmitted')) params.put('EmailBody.unsubmitted', 'Unsubmitted body not defined.');
        if (!params.containsKey('EmailBody.reservation')) params.put('EmailBody.reservation', 'Reservation body not defined.');
        if (!params.containsKey('EmailBody.esubmit-electronic')) params.put('EmailBody.esubmit-electronic', 'Electronic rebate body not defined.');
        if (!params.containsKey('EmailBody.esubmit-mail')) params.put('EmailBody.esubmit-mail', 'Mail rebate body not defined.');
        if (!params.containsKey('noAttachmentsError')) params.put('noAttachmentsError', '"No Attachments" error not defined.');
        // then get the hard limits
        for (FieldHardLimit__c fhl: [select FieldName__c, FieldLimit__c from FieldHardLimit__c]) {
            fieldHardLimits.put(fhl.FieldName__c, fhl.FieldLimit__c);
        }
        // then get form measure amounts
        for (Measure__c m: [select ID, MeasureCode__c, RebateAmount__c from Measure__c where FormID__c = :thisFormID]) {
        	measureAmount.put(m.MeasureCode__c, m.RebateAmount__c);
        }
        // then the budget status
        if (budgetDSID == null) {
            formOpen = true;
        } else {
            for (BudgetDS__c bds: [select ReservationOpen__c, RebateOpen__c from BudgetDS__c where ID = :budgetDSID]) {
                formOpen = reservationFlag ? bds.ReservationOpen__c : bds.RebateOpen__c;
            }
        }
    }
    
    public void getFormFields() {
        String tempKey;
        detailRecs = new Set<String>(); // initialize
        for (FormFields__c f: [select ID, FieldName__c, RecordCode__c, TargetTable__c, DataType__c, TestValue__c, InitValue__c,
            VisibleWith__c, VisibleState__c, BlankStop__c, RangeStop__c, ScaleStop__c, RangeMin__c, RangeMax__c, ScaleMax__c, 
            BlankMessage__c, RangeMessage__c, ScaleMessage__c, InvalidMessage__c, FieldLabel__c, DoNotSave__c, SkipPdoxSend__c
            from FormFields__c where FormID__c = :thisFormID]) {
            tempKey = f.targetTable__c+'.'+f.FieldName__c+(('RebateDetail__c'.equalsIgnoreCase(f.targetTable__c)) ? '.'+f.RecordCode__c : '');
            formFields.put(tempKey, new FormField(f.ID, f.FieldName__c, f.RecordCode__c, f.TargetTable__c, f.DataType__c, 
                f.TestValue__c, f.InitValue__c, f.VisibleWith__c, f.VisibleState__c, f.BlankStop__c, f.RangeStop__c, f.ScaleStop__c,
                f.RangeMin__c, f.RangeMax__c, f.ScaleMax__c, f.BlankMessage__c, f.RangeMessage__c, f.ScaleMessage__c, 
                f.InvalidMessage__c, f.FieldLabel__c, f.DoNotSave__c, f.SkipPdoxSend__c));
            if ('RebateDetail__c'.equalsIgnoreCase(f.TargetTable__c) && !Utils.isEmpty(f.RecordCode__c)) {
                detailRecs.add(f.RecordCode__c); // duplicate adds are ok
                // main already have been initialized ... if not initialize here
                if (!details.containsKey(f.RecordCode__c)) details.put(f.RecordCode__c, new DetailInfo(f.RecordCode__c,'enter'));
                if (!details.get(f.RecordCode__c).mfrLoaded) { // load manufacturer list if it isn't already loaded
                    if ('select'.equalsIgnoreCase(details.get(f.RecordCode__c).modelEntry) || 'both'.equalsIgnoreCase(details.get(f.RecordCode__c).modelEntry))
                        makeManufacturerList(f.RecordCode__c);
                }
            }
        }
        fieldSet = formFields.keySet(); 
    }
        
    public void showRebate() {
        formField f;
        String k;
        ID contID;
        ID rebID;
        if (debugging) system.debug('EFILOG: Entered showRebate');
        clearErrorIcons();
        foundError = false;
        frmErrLevel = 0;
        beforeShowRebate();
        // get rebate record
        // start of old method
        List<Rebate__c> rebs = [select ID, AccountNumber__c, ContactID__c, RebateNumber__c,
            MailingFirstName__c, MailingLastName__c, MailingAddress1__c,
            MailingAddress2__c, MailingCity__c, MailingState__c, MailingZipCode__c,
            StoreID__c, StoreName__c, StoreAddress1__c, StoreAddress2__c, StoreCity__c,
            StoreState__c, StoreZipCode__c, StorePhone__c, 
            PurchaseDate__c, RebateStatus__c, CustomerComment__c, PostmarkDate__c,
            TermsConditions__c, UtilityCode__c, RebateStatusMM__c, 
            SubmitVia__c, MailSameFlag__c, EmailRequest__c, CustomerPayableAmount__c
            from Rebate__c where HashCode__c = :frmHashCode
            and FormCode__c = :thisFormCode];
        if (rebs.size() != 1) { frmRebateNum = 'not found'; return; }
        rreb = rebs.get(0);
        frmRebateNum = rreb.RebateNumber__c;
        totalAmountSaved = Utils.toCurrency((Double)rreb.CustomerPayableAmount__c);
        totalAmountSavedNum = rreb.CustomerPayableAmount__c;
        if (params.containsKey('limitedRebate')) {
	        frmLimitedRebate = params.get('limitedRebate').replace('{a}', totalAmountSaved); // insert amount
        } else {
        	frmLimitedRebate = 'limitedRebate text not defined';
        }
        // end of old method
        /*
        // start of new method
        if (debugging) system.debug(buildSQL('Rebate__c'));
        List<sObject> objs = Database.query(buildSQL('Rebate__c')+
            ' where RebateNumber__c = \''+String.escapeSingleQuotes(frmRebateNum)+'\' '+
            'and MailingZipCode__c = \''+String.escapeSingleQuotes(frmPostalCode)+'\' '+
            'and FormCode__c = \''+thisFormCode+'\'');
        if (objs.size() != 1) {frmRebateNum = 'not found'; return; }
        Rebate__c reb = (Rebate__c)objs.get(0);
        // end of new method
        */
        existingStatus = rreb.RebateStatusMM__c;  // remember current status value
        if ('eSubmit'.equalsIgnoreCase(existingStatus)) { // viewing, not editable
            frmButtonLabel = params.get('buttonTextView');
            frmLoadMessage = params.get('messageTextView');
            formFields.get('Rebate__c.SubmitAs').stringValue = 'Rebate';
            disableDE = true;
            frmReadOnly = 'yes';
            existingType = 'Rebate';
        } else if ('Reservation'.equalsIgnoreCase(existingStatus)) { // viewing to edit
            frmLoadMessage = '';
            frmButtonLabel = params.get('buttonTextInit'); // override default for first view
            formFields.get('Rebate__c.SubmitAs').stringValue = 'Reservation';
            disableDE = false;  // may be limited if closed
            frmReadOnly = 'no';
            existingType = 'Reservation';
        } else { 
            frmStatus = 'Other'; return;  // in process, can't view now
        }
        frmShowInvoice = '';
        contID = rreb.ContactID__c;
        rebID = rreb.ID;
        for (String ff: fieldSet) {
            f = formFields.get(ff);
            if ('Rebate__c'.equalsIgnoreCase(f.TargetTable) && !f.doNotSave) {
                if ('String'.equalsIgnoreCase(f.DataType)) {
                    f.stringValue = (String)rreb.get(f.fieldName);
                }
                if ('Date'.equalsIgnoreCase(f.DataType)) {
                    if (rreb.get(f.fieldName) == null) {
                        f.dateValue = null;
                        f.stringValue = '';
                    } else {
                        f.dateValue = (Date)rreb.get(f.fieldName); // not sure if this is needed here
                        f.stringValue = ((Date)rreb.get(f.fieldName)).format(); // this one is displayed
                    }
                }
            }
        }
        List<Contact> conts = [select ID, FirstName, LastName, HomePhone, WorkPhone__c, Email, ReceiveEmail__c,
            ServiceAddress1__c, ServiceAddress2__c, ServiceCity__c, ServiceState__c,
            ServiceZipcode__c,  AccountNumber__c
            from Contact where ID = :contID];
        if (conts.size() != 1) {
            if (formFields.containsKey('Contact.AccountNumber__c')) {
                formFields.get('Contact.AccountNumber__c').stringValue = 'not found';
                // return; // for now, continue and fill what we can
            }
        } else {
            rcont = conts.get(0);
            for (String ff: fieldSet) {
                f = formFields.get(ff);
                if ('Contact'.equalsIgnoreCase(f.TargetTable) && !f.doNotSave) {
                    if ('String'.equalsIgnoreCase(f.DataType)) {
                        f.stringValue = (String)rcont.get(f.fieldName);
                    }
                    if ('Boolean'.equalsIgnoreCase(f.DataType)) {
                        f.booleanValue = (Boolean)rcont.get(f.fieldName);
                        f.stringValue = (f.booleanValue) ? 'Y' : '';
                    }
                }
            }
        }
        for (RebateDetail__c rd: [select ModelID__c, Manufacturer__c, ModelNumber__c, AmountTendered__c, InstallDate__c, 
            MeasureCode__c, MeasureRebateAmount__c, Quantity__c, RecordCode__c, ReplacedManufacturer__c, ReplacedModelNumber__c
            from RebateDetail__c
            where RebateID__c = :rebID]) {
                showRebateDetail(rd, 'Manufacturer__c');
                showRebateDetail(rd, 'ModelNumber__c');
                showRebateDetail(rd, 'ModelID__c');
                showRebateDetail(rd, 'AmountTendered__c');
                showRebateDetail(rd, 'MeasureCode__c');
                showRebateDetail(rd, 'MeasureRebateAmount__c');
                showRebateDetail(rd, 'Quantity__c');
                showRebateDetail(rd, 'InstallDate__c');
                showRebateDetail(rd, 'ReplacedManufacturer__c');
                showRebateDetail(rd, 'ReplacedModelNumber__c');
                k = 'RebateDetail__c.ManualModelFlag.'+rd.RecordCode__c;  // display as manual model by default
                if (fieldSet.contains(k)) formFields.get(k).booleanValue = true;
                k = 'RebateDetail__c.MeasureSelected.'+rd.RecordCode__c;  // enable display of this measure
                if (fieldSet.contains(k)) formFields.get(k).booleanValue = true;
        }
        for (RebateSurvey__c rs: [select ColumnName__c, Answer__c
            from RebateSurvey__c where RebateID__c = :rebID]) {
            if (formFields.containsKey('RebateSurvey__c.'+rs.ColumnName__c)) {
                f = formFields.get('RebateSurvey__c.'+rs.ColumnName__c);
                f.stringValue = (rs.Answer__c == null) ? '' : rs.Answer__c;
                if ('Boolean'.equalsIgnoreCase(f.dataType)) f.BooleanValue = ('Y'.equalsIgnoreCase(f.stringValue)); // for checkboxes
            }
        }
        // general fields that aren't in the database (need all database fields first!)
        // ManualStoreFlag (required)
        if ('enter'.equalsIgnoreCase(storeEntry)) { 
            setBooleanField('Rebate__c.ManualStoreFlag', true);
        } else if ('select'.equalsIgnoreCase(storeEntry)) {
            setBooleanField('Rebate__c.ManualStoreFlag', false);
        } else {
            if (!Utils.isEmpty(formFields.get('Rebate__c.StoreID__c').stringValue)) { // a value was selected
                setBooleanField('Rebate__c.ManualStoreFlag', false);
            } else if (Utils.isEmpty(formFields.get('Rebate__c.StoreName__c').stringValue) && 
                Utils.isEmpty(formFields.get('RebateDetail__c.StoreAddress1__c').stringValue) && 
                Utils.isEmpty(formFields.get('RebateDetail__c.StoreAddress2__c').stringValue) && 
                Utils.isEmpty(formFields.get('RebateDetail__c.StoreCity__c').stringValue) && 
                Utils.isEmpty(formFields.get('RebateDetail__c.StoreZipcode__c').stringValue)) { // no value entered
                setBooleanField('Rebate__c.ManualStoreFlag', false);
            } else { // a value was entered
                setBooleanField('Rebate__c.ManualStoreFlag', true);
            }
        }
        // SelStoreState (optional) and SelStoreCity (optional) - will be present except if storeEntry = enter
        if (!'enter'.equalsIgnoreCase(storeEntry) && !Utils.isEmpty(formFields.get('Rebate__c.StoreID__c').stringValue)) {
            formFields.get('Rebate__c.SelStoreState').stringValue = ''; // initialize
            formFields.get('Rebate__c.SelStoreCity').stringValue = '';
            for (Store__c s: [select ID, StoreCity__c, StoreState__c from Store__c 
                where ID = :formFields.get('Rebate__c.StoreID__c').stringValue] ) {
                formFields.get('Rebate__c.SelStoreState').stringValue = s.StoreState__c;
                formFields.get('Rebate__c.SelStoreCity').stringValue = s.StoreCity__c;
                makeStoreList();                
            }
        }
        // detail fields that aren't in the database
        for (String dr: detailRecs) {
            // ManualModelFlag (required)
            if ('enter'.equalsIgnoreCase(details.get(dr).modelEntry)) { 
                setBooleanField('Rebate__c.ManualStoreFlag', true);
            } else if ('select'.equalsIgnoreCase(details.get(dr).modelEntry)) {
                setBooleanField('Rebate__c.ManualStoreFlag', false);
            } else {
                if (!Utils.isEmpty(formFields.get('RebateDetail__c.ModelID__c.'+dr).stringValue)) { // a value was selected
                    setBooleanField('RebateDetail__c.ManualModelFlag.'+dr, false);
                } else if (Utils.isEmpty(formFields.get('RebateDetail__c.Manufacturer__c.'+dr).stringValue) && 
                    Utils.isEmpty(formFields.get('RebateDetail__c.ModelNumber__c.'+dr).stringValue)) { // no value entered
                    setBooleanField('RebateDetail__c.ManualModelFlag.'+dr, false);
                } else { // a value was entered
                    setBooleanField('RebateDetail__c.ManualModelFlag.'+dr, true);
                }
            }
            // debugText = debugText + 'ManualModelFlag:'+dr+':'+((formFields.get('RebateDetail__c.ManualModelFlag.'+dr).booleanValue)?'Y':'N')+'\n';
            // SelManufacturer (optional)
            if (formFields.containsKey('RebateDetail__c.SelManufacturer.'+dr)) {
                if (Utils.isEmpty(formFields.get('RebateDetail__c.ModelID__c.'+dr).stringValue)) {
                    formFields.get('RebateDetail__c.SelManufacturer.'+dr).stringValue = 
                        formFields.get('RebateDetail__c.Manufacturer__c.'+dr).stringValue;
                } else {
                    formFields.get('RebateDetail__c.SelManufacturer.'+dr).stringValue = ''; // initialize
                    for (Model__c m: [select ID, Manufacturer__c, ModelNumber__c from Model__c 
                        where ID = :formFields.get('RebateDetail__c.ModelID__c.'+dr).stringValue] ) {
                        formFields.get('RebateDetail__c.SelManufacturer.'+dr).stringValue = m.Manufacturer__c;
                    }
                }
            }
        }
        makeModelList();            // can initialize, once all the fields are known (including initialization)
        afterShowRebate();
    }
    
    public void setBooleanField(String fname, Boolean val) {
        FormField f;
        f = formFields.get(fname);
        f.booleanValue = val;
        f.stringValue = f.booleanValue ? 'Y' : '';
    }
    
    public void setStringField(String fname, String val) {
        FormField f;
        f = formFields.get(fname);
        f.stringValue = val;
    }
    
    public String getStringField(String fname) {
        FormField f;
        f = formFields.get(fname);
        return f.stringValue;
    }
    
    public Boolean blankOrDefaultField(String fname) {
        FormField f;
        String dValue;
        f = formFields.get(fname);
        if (Utils.isEmpty(f.stringValue)) return true;
        dValue = testMode ? f.testValue : f.initValue; // default value
        if (f.stringValue.equalsIgnoreCase(dValue)) return true;
        return false; // value not blank and not default
    }
    
    public void showRebateDetail(RebateDetail__c rd, String fld) {
        String k = 'RebateDetail__c.'+fld+'.'+rd.RecordCode__c;
        if (!fieldSet.contains(k)) return;
        String t = formFields.get(k).dataType;
        if ('String'.equalsIgnoreCase(t) || 'ID'.equalsIgnoreCase(t)) { formFields.get(k).stringValue = (String)rd.get(fld); return; }
        if ('Decimal'.equalsIgnoreCase(t)) {
            formFields.get(k).decimalValue = (Decimal)rd.get(fld);
            if (formFields.get(k).decimalValue != null) formFields.get(k).stringValue = formFields.get(k).decimalValue.format();
        }
        if ('Date'.equalsIgnoreCase(t)) {
            formFields.get(k).dateValue = (Date)rd.get(fld);
            if (formFields.get(k).dateValue != null) formFields.get(k).stringValue = formFields.get(k).dateValue.format();
        }
    }
    
    public virtual void beforeShowRebate() {
        // override to place custom code before showRebate()
    }        
        
    public virtual void afterShowRebate() {
        // override to place custom code after showRebate()
    }
        
    public void showErrorIcons() {
        for (String ff: fieldSet) {
            formFields.get(ff).warnMsg = 'Warning message';
            formFields.get(ff).warnStyle = 'display:inline';
            formFields.get(ff).errorMsg = 'Error message';
            formFields.get(ff).errorStyle = 'display:inline';
        }
    }

    public void clearErrorIcons() {
        // don't clear field error levels ... need them to validate overrides by user.
        for (String ff: fieldSet) {
            formFields.get(ff).WarnMsg = '';
            formFields.get(ff).WarnStyle = 'display:none';
            formFields.get(ff).ErrorMsg = '';
            formFields.get(ff).ErrorStyle = 'display:none';
        }
    }

    public void clearErrorLevels() {
        for (String ff: fieldSet) {
            formFields.get(ff).errorLevel = 0;
        }
    }
        
    public void testInit() {
        FormField f;
        beforeTestInit();
        for (String ff: fieldSet) {
            f = formFields.get(ff);
            if ('String'.equalsIgnoreCase(f.dataType)) { 
                f.stringValue = f.testValue;
                if (f.stringValue == null) f.stringValue = '';
            }
            if ('Boolean'.equalsIgnoreCase(f.dataType)) {
                f.booleanValue = ('true'.equalsIgnoreCase(f.testValue));
                f.stringValue = f.booleanValue ? 'Y' : '';
            }
            if ('Date'.equalsIgnoreCase(f.dataType)) {
                f.stringValue = f.testValue;
                try {
                    f.dateValue = Date.parse(f.testValue);                  
                } catch (Exception e) {
                    f.dateValue = null;
                    f.stringValue = ''; // if invalid, initialize to blank
                }
            } 
            if ('Decimal'.equalsIgnoreCase(f.dataType)) { 
                f.stringValue = f.testValue;
                try {
                    f.decimalValue = Decimal.valueOf(f.testValue);                  
                } catch (Exception e) {
                    f.decimalValue = null;
                    f.stringValue = ''; // if invalid, initialize to blank
                }
            }
        }
        if (!'enter'.equalsIgnoreCase(storeEntry.toLowerCase())) makeStoreList();
        afterTestInit();
    }
        
    public virtual void beforeTestInit() {
        // override to place custom code before showRebate()
    }
    
    public virtual void afterTestInit() {
        // override to place custom code before showRebate()
    }
    
    // this is the new approach (object-based)
    public void makeManufacturerList(String rcode) {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('','Please Select ...'));
        for (Manufacturer__c m: [select ID, Manufacturer__c from Manufacturer__c 
            where ID in (select ManufacturerID__c from FormXManufacturer__c where FormID__c = :thisFormID and RecordCode__c = :rcode) order by Manufacturer__c] ) {
            options.add(new SelectOption(m.Manufacturer__c, m.Manufacturer__c));
        }
        // mfrList.put(rcode, options);
        details.get(rcode).mfrList = options;
        details.get(rcode).mfrLoaded = true; 
    }

    // this is the new approach (object-based), scan to check for changes since can't pass argument
    public void makeModelList() {
        for (DetailInfo d: details.values()) {
            List<SelectOption> options = new List<SelectOption>();
            String mfrfld = 'RebateDetail__c.SelManufacturer.'+d.recordCode;
            String mfr = formFields.get(mfrfld).stringValue;
            if (Utils.isEmpty(mfr) && Utils.isEmpty(d.modelMfr)) continue;
            if (!Utils.isEmpty(mfr) && mfr.equalsIgnoreCase(d.modelMfr)) continue; // skip this one if same as generated previously
            options.add(new SelectOption('','Please Select ...'));          // this choice, even if none to choose
            // options.add(new SelectOption('mfr',':'+mfr)); for diagnostics (only issue for Thermostats?)
            if (!Utils.isEmpty(mfr)) {      // search if a manufacturer provided
                for (Model__c m: [select ID, Manufacturer__c, ModelNumber__c from Model__c 
                    where Manufacturer__c = :mfr and
                    ID in (select ModelID__c from FormXModel__c where FormID__c = :thisFormID and RecordCode__c = :d.recordCode) order by ModelNumber__c] ) {
                    options.add(new SelectOption(m.ID,m.ModelNumber__c));
                }
            }
            d.modelList = options;
            d.modelMfr = mfr;
        }
    }   

    public List<selectOption> makeStateList() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('','Please Select ...'));
        for (States__c s: [select ID, State__c, StateName__c from States__c order by StateName__c] ) {
            options.add(new SelectOption(s.State__c, s.StateName__c));
        }
        return options; 
    }   
    
    public List<selectOption> getStateList() {
        return stateList;
    }

    public List<SelectOption> makeFormList(String listName, string listType) {
        List<SelectOption> options = new List<SelectOption>();
        if (!'radio'.equalsIgnoreCase(listType.toLowerCase())) options.add(new SelectOption('','Please Select ...'));
        for (FormList__c f: [select ID, InternalValue__c, DisplayValue__c from FormList__c 
            where formID__c = :thisFormID and ListName__c = :listName
            order by DisplayValue__c] ) {
            options.add(new SelectOption(f.InternalValue__c, f.DisplayValue__c));
        }
        return options;
    }

    public void makeStoreList() {
        storeList.clear();
        Integer storeCount = 0;
        FormField ss = formFields.get('Rebate__c.SelStoreState');
        FormField sc = formFields.get('Rebate__c.SelStoreCity');
        if (!Utils.isEmpty(ss.stringValue) && !Utils.isEmpty(sc.stringValue)) {
            storeList.add(new SelectOption('','Please Select ...'));
            for (Store__c s: [select ID, StoreName__c, StoreAddress1__c, StoreCity__c, StoreState__c, StoreZipcode__c from Store__c 
                where StoreCity__c = :sc.stringValue and StoreState__c = :ss.stringValue and InitialProgram__c = :thisClientCode
                order by StoreName__c] ) {
                storeList.add(new SelectOption(s.ID,s.StoreName__c+', '+s.StoreAddress1__c+', '+s.StoreCity__c+', '+s.StoreState__c+', '+s.StoreZipcode__c));
                storeCount += 1;
            }
            if (storeCount == 0) { // warning if none found
                sc.WarnMsg = 'Warning: There are no stores for this city/state.  City might be misspelled.';
                sc.WarnStyle = 'display:inline';
            } else {
                sc.WarnMsg = '';
                sc.WarnStyle = 'display:none';
            }
        } else {
            storeList.add(new SelectOption('','Please enter State and City above ...'));
        }
    }

    public List<selectOption> getStoreList() {
            return storeList;       
    }

    // since we're now object-based, moved a lot of standard code here (used to be alertErrors())
    public void recordError(FormField f, String level) {
        f.errorValue = f.stringValue;
        if ('hard'.equalsIgnoreCase(level)) {
            f.errorStyle = 'display:inline';
            f.errorLevel = 20;
            frmErrLevel = 20;
            // clear any soft error - avoid showing both
            f.warnStyle = 'display:none';
            f.warnMsg = '';
        } else { // soft
            f.warnStyle = 'display:inline';
            f.errorLevel = 10;
            if (frmErrLevel < 10) frmErrLevel = 10;
        }
        // if (errLevel > frmErrLevel) frmErrLevel = errLevel; // use maximum
        if (frmErrLevel == 10) { 
            frmLoadMessage = params.get('messageTextWarn');
            frmButtonLabel = params.get('buttonTextWarn');
        }
        if (frmErrLevel == 20) { 
            frmLoadMessage = params.get('messageTextError');
            frmButtonLabel = params.get('buttonTextError');
        }
        foundError = true;
        if (debugging) {
            debugText = debugText + 'Error: '+f.targetTable +'.'+ f.fieldName +'.'+ f.recordCode + (String) +'='+ f.errorLevel + '\n';
        }
    }
    
    public PageReference actionCheckMe() {
        FormField f;
        String submitAs;
        if (debugging) system.debug('EFILOG: Entered CheckMe');
        debugText = '';
        getSessionData(); // detect reload or back button
        if (!Utils.isEmpty(saveRebateNum)) {
            frmRebateNum = saveRebateNum;
            formFields.get('Rebate__c.MailingZipcode__c').stringValue = saveMailZip;
            showRebate();
            frmButtonLabel = params.get('buttonTextReload');
            frmLoadMessage = params.get('messageTextReload');
            return null;
        }
        clearErrorIcons(); // reset error variables;
        frmButtonLabel = ''; // was params.get('buttonTextOk'); // default before error found (set below now)
        frmLoadMessage = '';
        frmShowInvoice = '';
        foundError = false;
        frmErrLevel = 0;
        softStopMessage = '';
        hardStopMessage = '';
        // is this a reservation or a rebate submission?
        submitAs = formFields.get('Rebate__c.SubmitAs').stringValue;
        // set effective stop levels based on submitAs
        for (String ff: fieldSet) {
            f = formFields.get(ff);
            f.effBlankStop = effectiveLevel(submitAs, f.blankStop);
            f.effRangeStop = effectiveLevel(submitAs, f.rangeStop);
            f.effScaleStop = effectiveLevel(submitAs, f.scaleStop);
        }
        beforeStandardValidation(); // hook for extensions to precede standard validation
        for (String dr: detailRecs) {
            if (formFields.get('RebateDetail__c.ManualModelFlag.'+dr).booleanValue) { // expect present and correct, even if not visible
                // process manual model, make sure ID is null
                if (fieldSet.contains('RebateDetail__c.ModelID__c.'+dr)) 
                    formFields.get('RebateDetail__c.ModelID__c.'+dr).stringValue = null; // make sure this is null
            } else {
                // process selected model, copying data to manual fields
                formFields.get('RebateDetail__c.Manufacturer__c.'+dr).stringValue = 
                    formFields.get('RebateDetail__c.SelManufacturer.'+dr).stringValue; 
                formFields.get('RebateDetail__c.ModelNumber__c.'+dr).stringValue = '';
                for (Model__c m: [select ID, ModelNumber__c from Model__c 
                    where ID = :formFields.get('RebateDetail__c.ModelID__c.'+dr).stringValue] ) {
                    formFields.get('RebateDetail__c.ModelNumber__c.'+dr).stringValue = m.ModelNumber__c;
                }
                // then look up measure details for RebateDetail record
                for (Measure__c me: [select ID, MeasureCode__c, RebateAmount__c from Measure__c 
                    where ID in (select MeasureID__c from FormXModel__c 
                        where FormID__c = :thisFormID
                        and ModelID__c = :formFields.get('RebateDetail__c.ModelID__c.'+dr).stringValue)]) {
                    formFields.get('RebateDetail__c.MeasureID__c.'+dr).stringValue = me.ID;
                    formFields.get('RebateDetail__c.MeasureCode__c.'+dr).stringValue = me.MeasureCode__c;
                    formFields.get('RebateDetail__c.MeasureRebateAmount__c.'+dr).decimalValue = me.RebateAmount__c;
                    formFields.get('RebateDetail__c.MeasureRebateAmount__c.'+dr).stringValue =
                        (me.RebateAmount__c == null) ? '' : me.RebateAmount__c.format();
                }
            }               
        }
        if (formFields.get('Rebate__c.ManualStoreFlag').booleanValue) { // process manual vs. selected Store
            formFields.get('Rebate__c.StoreID__c').stringValue = null; // make sure this is null for Rebate record
        } else {
            for (Store__c s: [select ID, StoreName__c, StoreAddress1__c, StoreAddress2__c, StoreCity__c, StoreState__c, StoreZipcode__c from Store__c 
                where ID = :formFields.get('Rebate__c.StoreID__c').stringValue] ) {
                if (formFields.containsKey('Rebate__c.StoreName__c')) formFields.get('Rebate__c.StoreName__c').stringValue = s.StoreName__c;
                if (formFields.containsKey('Rebate__c.StoreAddress1__c')) formFields.get('Rebate__c.StoreAddress1__c').stringValue = s.StoreAddress1__c;
                if (formFields.containsKey('Rebate__c.StoreAddress2__c')) formFields.get('Rebate__c.StoreAddress2__c').stringValue = s.StoreAddress2__c;
                if (formFields.containsKey('Rebate__c.StoreCity__c')) formFields.get('Rebate__c.StoreCity__c').stringValue = s.StoreCity__c;
                if (formFields.containsKey('Rebate__c.StoreState__c')) formFields.get('Rebate__c.StoreState__c').stringValue = s.StoreState__c;
                if (formFields.containsKey('Rebate__c.StoreZipcode__c')) formFields.get('Rebate__c.StoreZipcode__c').stringValue = s.StoreZipcode__c;
            }
        }
        // standard validation
        for (String ff: fieldSet) {
            f = formFields.get(ff);
            Date minDate, maxDate;
            Decimal minDecimal, maxDecimal;
            // first adjustments - fix strings and set boolean string values
            if (f.stringValue == null) f.stringValue = ''; // replace nulls with blanks (keep it simple)
            if ('Boolean'.equalsIgnoreCase(f.dataType)) { f.stringValue = f.booleanValue ? 'Y' : ''; }
            if (!Utils.isEmpty(f.visibleWith)) { // is this field sometimes invisible?
                if (!(f.visibleState == formFields.get(f.visibleWith).booleanValue)) continue; // if so, skip validation
            }
            if (('RebateDetail__c'.equalsIgnoreCase(f.targetTable)) && fieldSet.contains('RebateDetail__c.MeasureSelected.'+f.recordCode)) { // is this field associated with an invisible measure?
                if (!formFields.get('RebateDetail__c.MeasureSelected.'+f.recordCode).booleanValue) continue; //if so, skip validation
            }
            // then create date value, hard error if fails
            if ('Date'.equalsIgnoreCase(f.dataType)) {
                if (Utils.isEmpty(f.stringValue)) { f.dateValue = null; }
                else {
                    try { f.dateValue = Date.parse(f.stringValue); }
                    catch (Exception e) {
                        f.errorMsg = (Utils.isEmpty(f.invalidMessage)) ? 'Error: Invalid date.' : f.invalidMessage;
                        recordError(f, 'hard');
                        continue; // no need to do any more with this field
                    }
                }
                if (Utils.isEmpty(f.rangeMin)) { minDate = null; }
                else if ('today'.equalsIgnoreCase(f.rangeMin)) { minDate = Date.today(); }
                else {
                    try { minDate = date.parse(f.rangeMin); }
                    catch (Exception e) { minDate = null; }
                }
                if (Utils.isEmpty(f.rangeMax)) { maxDate = null; }
                else if ('today'.equalsIgnoreCase(f.rangeMax)) { maxDate = Date.today(); }
                else {
                    try { maxDate = date.parse(f.rangeMax); }
                    catch (Exception e) { maxDate = null; }
                }
            }
            if ('Decimal'.equalsIgnoreCase(f.dataType)) {
                if (Utils.isEmpty(f.stringValue)) { f.decimalValue = null; }
                else {
                    try { f.decimalValue = Decimal.valueOf(f.stringValue); }
                    catch (Exception e) {
                        f.errorMsg = (Utils.isEmpty(f.invalidMessage)) ? 'Error: Invalid number.' : f.invalidMessage;
                        recordError(f, 'hard');
                        continue; // no need to do any more with this field
                    }
                }
                if (Utils.isEmpty(f.rangeMin)) { minDecimal = null; }
                else {
                    try { minDecimal = Decimal.valueOf(f.rangeMin); }
                    catch (Exception e) { minDecimal = null; }
                }
                if (Utils.isEmpty(f.rangeMax)) { maxDecimal = null; }
                else {
                    try { maxDecimal = Decimal.valueOf(f.rangeMax); }
                    catch (Exception e) { maxDecimal = null; }
                }
            }
            // then set flag if soft error and value not changed
            f.seenSoftError = ((f.errorLevel == 10) && (f.stringValue == f.errorValue)) ? true : false;
            if (!f.seenSoftError) {
                f.errorLevel = 0; // initialize
                if ('String'.equalsIgnoreCase(f.dataType)) { // validate hard and soft errors
                    if ((Utils.isEmpty(f.stringValue)) || 
                        (f.fieldName.contains('Address1') && 'Line 1'.equalsIgnoreCase(f.stringValue)) || 
                        (f.fieldName.contains('Address2') && 'Line 2'.equalsIgnoreCase(f.stringValue))) { 
                        handleBlankError(f);
                    } 
                    if ((f.errorLevel < 20) && (fieldHardLimits.containsKey(f.fieldName)) && 
                        (f.stringValue.length() > fieldHardLimits.get(f.fieldName))) {
                        f.errorMsg = 'Error: Field content too long.';
                        recordError(f, 'hard');
                    }
                    if (('AccountNumber__c'.equalsIgnoreCase(f.fieldName)) && (!'none'.equalsIgnoreCase(pCustCheck)) && (!Utils.isEmpty(f.stringValue)) &&
                        fieldSet.contains('Contact.ServiceZipcode__c')) {
                        accountPCustLookup(f);
                    }
                    if ('Email'.equalsIgnoreCase(f.fieldName)) { // always check for well-formed email address
                        if (!Utils.isValidEmail(f.stringValue)) {
                            f.errorMsg = 'Error: Invalid email address.';
                            recordError(f, 'hard');
                        }                               
                    }
                }
                if ('Decimal'.equalsIgnoreCase(formFields.get(ff).dataType)) {
                    // f.decimalValue, minDecimal, maxDecimal all set above
                    if (f.decimalValue == null) handleBlankError(f);
                    if ((f.decimalValue != null) && (minDecimal != null) && (f.decimalValue < minDecimal)) handleRangeError(f,'min');
                    if ((f.decimalValue != null) && (maxDecimal != null) && (f.decimalValue > maxDecimal)) handleRangeError(f,'max');
                    if ((f.decimalValue != null) && (f.scaleMax != null) && (f.decimalValue.scale() > f.scaleMax)) handleScaleError(f);
                }
                if ('Date'.equalsIgnoreCase(formFields.get(ff).dataType)) {
                    // f.dateValue, minDate, maxDate all set above
                    if (f.dateValue == null) handleBlankError(f);
                    if ((f.dateValue != null) && (minDate != null) && (f.dateValue < minDate)) handleRangeError(f,'min');
                    if ((f.dateValue != null) && (maxDate != null) && (f.dateValue > maxDate)) handleRangeError(f,'max');
                }
                if ('Boolean'.equalsIgnoreCase(formFields.get(ff).dataType)) {
                    // no standard boolean validations for now
                }
            } 
        }
        // soft stop for rebates over reservation amount if program is closed
        // first figure totalAmountEdit, then test if appropriate
        totalAmountEditNum = 0; // initialize
		/*
        for (String ff: fieldSet) {
            FormField qf;
            f = formFields.get(ff);
            if ('MeasureSelected'.equalsIgnoreCase(f.fieldName) && 'RebateDetail__c'.equalsIgnoreCase(f.targetTable) && (f.booleanValue)) { // for selected measures
                qf = formFields.get('RebateDetail__c.Quantity__c.'+f.recordCode); // this is the quantity field
                if (qf.decimalValue != null) {
                    if ('FRN'.equalsIgnoreCase(f.recordCode) || 'WHTRI'.equalsIgnoreCase(f.recordCode)) { totalAmountEditNum += 250 * qf.decimalValue; }
                    else if ('FRNECM'.equalsIgnoreCase(f.recordCode) || 'BOILHW'.equalsIgnoreCase(f.recordCode)) { totalAmountEditNum += 350 * qf.decimalValue; }
                    else if ('BOILST'.equalsIgnoreCase(f.recordCode)) { totalAmountEditNum += 200 * qf.decimalValue; }
                    else { totalAmountEditNum += 25 * qf.decimalValue; } // PTSTAT 
                }
            }
        }
        */
        for (String dr: detailRecs) {
        	FormField msf = formFields.get('RebateDetail__c.MeasureSelected.'+dr);
        	FormField qf = formFields.get('RebateDetail__c.Quantity__c.'+dr);
        	FormField mcf = formFields.get('RebateDetail__c.MeasureCode__c.'+dr);
        	if (msf.booleanValue && !Utils.isEmpty(qf.stringValue) && measureAmount.containsKey(mcf.stringValue)) {
        		totalAmountEditNum += qf.decimalValue * measureAmount.get(mcf.stringValue);
        	}
        }
        if (!formOpen && 'Reservation'.equalsIgnoreCase(existingType) && 'Rebate'.equalsIgnoreCase(formFields.get('Rebate__c.SubmitAs').stringValue)) {
            if ((totalAmountEditNum > totalAmountSavedNum) && (totalAmountEditNum <> totalAmountWarned)) {
                totalAmountWarned = totalAmountEditNum ; // for next time, if any
                for (String ff: fieldSet) { // set warning on any quantity fields 
                    FormField qf;
                    f = formFields.get(ff);
                    if ('MeasureSelected'.equalsIgnoreCase(f.fieldName) && 'RebateDetail__c'.equalsIgnoreCase(f.targetTable) && (f.booleanValue)) { // for selected measures
                        qf = formFields.get('RebateDetail__c.Quantity__c.'+f.recordCode); // this is the quantity field
                        if (qf.errorLevel < 20) { // only if not already a hard stop
                            qf.warnMsg = 'Warning: Total requested rebate amount of '+Utils.toCurrency((Double)totalAmountEditNum)+
                                ' exceeds reservation amount of '+totalAmountSaved;
                            recordError(qf, 'soft');
                        }
                    }
                }
            }
            
        }
        totalAmountEdit = Utils.toCurrency((Double)totalAmountEditNum);
        if( 'rebate'.equalsIgnoreCase(formFields.get('Rebate__c.SubmitAs').stringValue) && 
        	'electronic'.equalsIgnoreCase(formFields.get('Rebate__c.SubmitVia__c').stringValue)) {
			// for electronic rebates, must upload documents or request email
	        if( formFields.containsKey('Rebate__c.EmailRequest__c') && !formFields.get('Rebate__c.EmailRequest__c').booleanValue &&
				'0'.equals(documentCount)) {
				hardStopMessage = params.get('noAttachmentsError');
				frmErrLevel = 20;
				foundError = true;
	            frmLoadMessage = params.get('messageTextError');
	            frmButtonLabel = params.get('buttonTextError');
			}
        }
        afterStandardValidation(); // hook for extensions to follow standard validation
        /* can log state of all fields for review, if needed (not usually needed)
        if (debugging) { // construct diagnostic text for page
            for (String ff: fieldSet) {
                f = formFields.get(ff);
                debugText = debugText + f.targetTable +'.'+ f.fieldName +'.'+ f.recordCode + (String) +'='+ f.errorLevel + '\n';
            }
        }
        */
        if (foundError) return null;
        // then write the necessary records
        // Customer
        if (Utils.isEmpty(existingStatus)) { // initialize
            rcont = new Contact (
                AccountID = thisAccountID,
                OwnerID = frmOwnerID
            );
        }
        for (String ff: fieldSet) {
            f = formFields.get(ff);
            if ('Contact'.equalsIgnoreCase(f.targetTable) && !f.doNotSave) { // except for ReceiveEmail__c, all Contact fields we use are Strings
                if ('LastName'.equalsIgnoreCase(f.fieldName)) {
                    rcont.put(f.fieldName, (Utils.isEmpty(f.stringValue)) ? '.' : f.stringValue);
                } else if (f.fieldName.contains('Address1')) { // strip out 'Line #' help text, if present
                    rcont.put(f.fieldName, ('Line 1'.equalsIgnoreCase(f.stringValue)) ? '' : f.stringValue);
                } else if (f.fieldName.contains('Address2')) {
                    rcont.put(f.fieldName, ('Line 2'.equalsIgnoreCase(f.stringValue)) ? '' : f.stringValue);
                } else if ('Boolean'.equalsIgnoreCase(f.datatype)) {
                    rcont.put(f.fieldName, f.booleanValue);
                } else if ('Date'.equalsIgnoreCase(f.datatype)) {
                    rcont.put(f.fieldName, f.dateValue);
                } else if ('Decimal'.equalsIgnoreCase(f.datatype)) {
                    rcont.put(f.fieldName, f.decimalValue);
                } else {
                    rcont.put(f.fieldName, f.stringValue);
                }
            }
        }
        if (writeRecs) {
            if (Utils.isEmpty(existingStatus)) { insert rcont; } else { update rcont; }
        }
        // Rebate
        if (Utils.isEmpty(existingStatus)) { // initialize
            rreb = new Rebate__c(
                Name = thisFormCode + ' | ' + formFields.get('Contact.AccountNumber__c').stringValue,
                ContactID__c = rcont.ID,
                FormID__c = thisFormID,
                FormCode__c = thisFormCode,
                UtilityCode__c = params.get('thisUtilityCode'),  
                Origin__c = 'FDC',
                OwnerID = frmOwnerID
            );
        }
        for (String ff: fieldSet) {
            f = formFields.get(ff);
            if ('Rebate__c'.equalsIgnoreCase(f.targetTable) && !f.doNotSave) { // except for PurchaseDate__c, all Contact fields we use are Strings
                if (f.fieldName.contains('Address1')) { // strip out 'Line #' help text, if present
                    rreb.put(f.fieldName, ('Line 1'.equalsIgnoreCase(f.stringValue)) ? '' : f.stringValue);
                } else if (f.fieldName.contains('Address2')) {
                    rreb.put(f.fieldName, ('Line 2'.equalsIgnoreCase(f.stringValue)) ? '' : f.stringValue);
                } else if ('Boolean'.equalsIgnoreCase(f.datatype)) {
                    rreb.put(f.fieldName, f.booleanValue);
                } else if ('Date'.equalsIgnoreCase(f.datatype)) {
                    rreb.put(f.fieldName, f.dateValue);
                } else if ('Decimal'.equalsIgnoreCase(f.datatype)) {
                    rreb.put(f.fieldName, f.decimalValue);
                } else {
                    rreb.put(f.fieldName, f.stringValue);
                }
            }
        }
        // use contact first name if (a) no separate mailing name fields (b) mailing name fields are blank
        if ((!fieldSet.contains('Rebate__c.MailingFirstName__c') && !fieldSet.contains('Rebate__c.MailingLastName__c')) || 
            (Utils.isEmpty(rreb.MailingFirstName__c) && Utils.isEmpty(rreb.MailingLastName__c))){
            rreb.MailingFirstName__c = rcont.FirstName;
            rreb.MailingLastName__c = rcont.LastName;
        }
        Boolean msf;
        if (fieldSet.contains('Rebate__c.MailSameFlag')) {
            msf = formFields.get('Rebate__c.MailSameFlag').booleanValue; // get explicit value
        } else {
            // implicit value based on empty mailing address (ok if State is populated - might have been default)
            msf = (Utils.isEmpty(rreb.MailingAddress1__c) && Utils.isEmpty(rreb.MailingAddress2__c) &&  
                Utils.isEmpty(rreb.MailingCity__c) && Utils.isEmpty(rreb.MailingZipcode__c));
        }
        if (msf) {
            rreb.MailingAddress1__c = rcont.ServiceAddress1__c;
            rreb.MailingAddress2__c = rcont.ServiceAddress2__c;
            rreb.MailingCity__c = rcont.ServiceCity__c;
            rreb.MailingState__c = rcont.ServiceState__c;
            rreb.MailingZipcode__c = rcont.ServiceZipcode__c;
        }
        if (writeRecs) {
            if (Utils.isEmpty(existingStatus)) { insert rreb; } else { update rreb; }
        }
        // Retrieve fields from rebate record
        for (Rebate__c r: [select ID, HashCode__c, RebateNumber__c, MailingZipcode__c from Rebate__c where ID = :rreb.ID] ) {
            frmRebateNum = r.RebateNumber__c;  // from retrieved record, won't be updated in rreb
            frmHashCode = r.HashCode__c;    // this needs to be populated for the test script
            Utils.saveSessionData(saveSessionID, 'RebateNumber', frmRebateNum);
            Utils.saveSessionData(saveSessionID, 'MailZipcode', r.MailingZipcode__c);
        }
        // RebateDetail
        if (!Utils.isEmpty(existingStatus)) { // delete existing records first
            List<RebateDetail__c> rds = [select ID, Name, RebateID__c from RebateDetail__c where RebateID__c = :rreb.ID];
            if (rds.size() > 0) delete rds;
        }
        for (String dr: detailRecs) {
            if (decideWriteDetailRecord(dr)) {
                RebateDetail__c rdet = new RebateDetail__c (
                    Name = rreb.Name + ' | ' + formFields.get('RebateDetail__c.MeasureCode__c.'+dr).stringValue,
                    RebateID__c = rreb.ID,
                    IsSentFromPdx__c = true,  //-- CEV SAYS "MAKE THIS TRUE OR ELSE"
                    // DetailStatus__c = params.get('initialStatus'), // old approach
                    DetailStatus__c = ('Rebate'.equalsIgnoreCase(formFields.get('Rebate__c.SubmitAs').stringValue)) ? 'eSubmit' : 'Reservation',
                    RecordCode__c = dr,
                    Quantity__c = 1 // initialize, might be overridden
                );
                for (String ff: fieldSet) {
                    f = formFields.get(ff);
                    if ('RebateDetail__c'.equalsIgnoreCase(f.targetTable) && f.recordCode.equalsIgnoreCase(dr) && !f.doNotSave) {
                        if ('Decimal'.equalsIgnoreCase(f.dataType)) {
                            rdet.put(f.fieldName, f.decimalValue);
                        } else if ('Date'.equalsIgnoreCase(f.datatype)) {
                            rdet.put(f.fieldName, f.dateValue);
                        } else if ('Boolean'.equalsIgnoreCase(f.datatype)) {
                            rdet.put(f.fieldName, f.booleanValue);
                        } else {  // Strings
                            rdet.put(f.fieldName, f.stringValue);
                        }
                    }
                }
                if (writeRecs) insert rdet;
            }
        }
        // RebateSurvey
        if (!Utils.isEmpty(existingStatus)) { // delete existing records first
            List<RebateSurvey__c> rss = [select ID, Name, RebateID__c from RebateSurvey__c where RebateID__c = :rreb.ID];
            if (rss.size() > 0) delete rss;
        }
        for (String ff: fieldSet) {
            f = formFields.get(ff);
            if ('RebateSurvey__c'.equalsIgnoreCase(f.targetTable)) {
                addSurveyRecord(rreb.ID, f);
            }
        }
        if ('Reservation'.equalsIgnoreCase(formFields.get('Rebate__c.SubmitAs').stringValue)) { // reservation message
            frmLoadMessage = params.get('messageTextOkRes');
            frmButtonLabel = params.get('buttonTextOkRes');
            checklistContent = params.get('EmailBody.reservation');
        } else if ('Electronic'.equalsIgnoreCase(formFields.get('Rebate__c.SubmitVia__c').stringValue)) { // electronic rebates
            frmLoadMessage = params.get('messageTextOkElect');
            frmButtonLabel = params.get('buttonTextOkElect');
            checklistContent = params.get('EmailBody.esubmit-electronic');
        } else { // other = mailed rebates
            frmLoadMessage = params.get('messageTextOk');
            frmButtonLabel = params.get('buttonTextOk');
            checklistContent = params.get('EmailBody.esubmit-mail');
        }
        disableDE = true;
        frmReadOnly = 'yes';
        
        
        //-- trigger the sending of an email now that we have committed all records
        // this procedure (by CEV) ignores blank email and 
        update (new Rebate__c(id = rreb.id, SendStatusEmail__c = false));
        
        //return null;
        
        //  2010.10.08:CEV::Test cases for ImageSilo must be handcrafted.  Skipping for now
        //  2012.10.16:DLK::Enabled by DLK for Mark demo on 10/17
        
        //-- turns out that if the user first selects rebate & electronic and then changes to reservation, the electronic file is still set.
        if( !'rebate'.equalsIgnoreCase(formFields.get('Rebate__c.SubmitAs').stringValue) 
            || !formFields.containsKey('Rebate__c.SubmitVia__c') 
            || !'electronic'.equalsIgnoreCase(formFields.get('Rebate__c.SubmitVia__c').stringValue)){
            return null;
        }
        
        if( formFields.containsKey('Rebate__c.EmailRequest__c') && formFields.get('Rebate__c.EmailRequest__c').booleanValue ){
            RebateEmailMgr rem = new RebateEmailMgr();
            rem.sendAttachmentEmail(rreb.id);
        }
        
        //-- sets all the document ids now that the rebate has been saved
        updateDocuments(saveSessionId, rreb.id);

        //-- async call to set the indexes for the documents now the rebatenumber exists
        RebateDocumentIndexer.setIndexes(rreb.id);

        PageReference r = Page.RebatePdfCreator;
        r.getParameters().put('rebate_id', rreb.id);
        r.getParameters().put('return_url', Utils.getHierarcicalUrl(ApexPages.currentPage()));
        r.setRedirect(false);

        System.debug('CEV:Forwarding to App Creator');
        return r;
        // end of section that was commented for deployment */
    }
    
    // a is SubmitAs (Reservation or Rebate), s = stop level
    public String effectiveLevel(String a, String s) {
        if ('none'.equalsIgnoreCase(s)) return 'none';     // these three values always apply
        if ('hardres'.equalsIgnoreCase(s)) return 'hard';
        if ('softres'.equalsIgnoreCase(s)) return 'soft';
        if ('Reservation'.equalsIgnoreCase(a)) { return 'none'; } else { return s; } // for 'hard' and 'soft'
        return 'none'; // should not happen, just in case
    }

    public virtual void beforeStandardValidation() {
        // override to place custom code before standard validation
    }
    
    public virtual void afterStandardValidation() {
        // override to place custom code after standard validation
    }

    public virtual void accountPCustLookup(FormField f) {
        // standard version looks up account in PCust, with or without UtilityCode__c
        // override to use a custom PCust lookup procedure instead
        // return;
        String ua = ''; // utility account
        String can = formFields.get('Contact.AccountNumber__c').stringValue;
        String szc = formFields.get('Contact.ServiceZipcode__c').stringValue;
        String nac = (can == null) ? '' : can.replaceAll('\\s|-','');
        if (fieldSet.contains('Rebate__c.UtilityCode__c')) {
            String uc = formFields.get('Rebate__c.UtilityCode__c').stringValue;
            for (UtilityAccount__c u: [select ID, AccountNumber__c from UtilityAccount__c 
                where NormalizedAccountNumber__c = :nac and ClientCode__c = :thisClientCode and 
                UtilityCode__c = :uc and ServiceZipCode__c = :szc] ) {
                ua = u.AccountNumber__c;
            }
        } else {
            for (UtilityAccount__c u: [select ID, AccountNumber__c from UtilityAccount__c 
                where NormalizedAccountNumber__c = :nac and ClientCode__c = :thisClientCode and 
                ServiceZipCode__c = :szc] ) {
                ua = u.AccountNumber__c;
            }
        }
        if (Utils.isEmpty(ua)) {
            f.warnMsg = (('soft'.equalsIgnoreCase(pCustCheck)) ? 'Warning' : 'Error') + ': Account number doesn\'t match our records.';
            recordError(f, pCustCheck);
            frmShowInvoice = 'Yes';
        }
    }
    
    public void handleBlankError(formField f) {
        if ('none'.equalsIgnoreCase(f.effBlankStop)) return;
        if ('hard'.equalsIgnoreCase(f.effBlankStop)) {
            f.errorMsg = (Utils.isEmpty(f.blankMessage)) ? 'Error: Field is blank, please provide.' : f.blankMessage;
        }
        if ('soft'.equalsIgnoreCase(f.effBlankStop)) {
            f.warnMsg = (Utils.isEmpty(f.blankMessage)) ? 'Warning: Field is blank, please provide if available.' : f.blankMessage;
        }
        recordError(f, f.effBlankStop);
    }
    
    public void handleRangeError(formField f, String dir) {
        String msg;
        if ('none'.equalsIgnoreCase(f.effRangeStop)) return;
        if ('Date'.equalsIgnoreCase(f.dataType)) {
            msg = ('min'.equalsIgnoreCase(dir)) ? 'Field is before ' + f.rangeMin : 'Field is after ' + f.rangeMax;
        } else {
            msg = ('min'.equalsIgnoreCase(dir)) ? 'Field is less than ' + f.rangeMin : 'Field is more than ' + f.rangeMax;
        }
        if ('hard'.equalsIgnoreCase(f.effRangeStop)) {
            f.errorMsg = (Utils.isEmpty(f.rangeMessage)) ? 'Error: ' + msg : f.rangeMessage;
        }
        if ('soft'.equalsIgnoreCase(f.effRangeStop)) {
            f.warnMsg = (Utils.isEmpty(f.rangeMessage)) ? 'Warning: ' + msg : f.rangeMessage;
        }
        recordError(f, f.effRangeStop);
    }
    
    public void handleScaleError(formField f) {
        String msg;
        if ('none'.equalsIgnoreCase(f.effScaleStop)) return;
        msg = 'Field may have up to '+String.valueOf(f.scaleMax)+' decimal Places.';
        if ('hard'.equalsIgnoreCase(f.effScaleStop)) {
            f.errorMsg = (Utils.isEmpty(f.scaleMessage)) ? 'Error: '+msg : f.scaleMessage;
        }
        if ('soft'.equalsIgnoreCase(f.effScaleStop)) {
            f.warnMsg = (Utils.isEmpty(f.scaleMessage)) ? 'Warning: '+msg : f.scaleMessage;
        }
        recordError(f, f.effScaleStop);
    }
    
    public virtual Boolean decideWriteDetailRecord(String rcode) {
        return true; // default yes, if not overridden
    }
    
    public virtual Boolean decideWriteSurveyRecord(formField f) {
        return true; //  default yes, if not overridden
    }
    
    public void addSurveyRecord(ID rebID, formField f) {
        // for now, all are written as strings.  String, Date, Decimal are as entered.  Boolean true -> Y above
        if (f.doNotSave || Utils.isEmpty(f.stringValue) || !decideWriteSurveyRecord(f)) return;
        // write RebateSurvey record
        // don't write column name ... it is set automatically from the FormFieldID.
        RebateSurvey__c rsurv = new RebateSurvey__c (
            Name = thisFormCode + ' | ' + f.fieldName,
            RebateID__c = rebID,
            FormFieldID__c = f.fieldID,
            Answer__c = f.stringValue
        );      
        if (writeRecs) insert rsurv;
    }

    private void updateDocuments(String sessionId, String rebateId){
        System.debug('UPDATING ALL '+sessionId+' TO '+rebateId);
        RebateDocument__c[] docs = [SELECT id, DocumentRepository__c, RepositoryProject__c, ExternalDocumentId__c FROM RebateDocument__c 
            WHERE SessionId__c =: sessionId];
            
        if( docs == null || docs.size() == 0) return;
        
        for(RebateDocument__c d : docs){
            d.SessionId__c = null;
            d.RebateId__c = rebateId;
        }
        
        update docs;
    }            

    @isTest(SeeAllData=False)
    public static void test(){   // was public static void
        // create the account we're using for the test cases
        Account a = new Account(Name='Test Account', ClientCode__c='CLIENT');
        insert a;
        // create a downstream budget
        BudgetDS__c bds = new BudgetDS__c();
        insert bds;
        // create the form we're using for the test cases
        Form__c f = new Form__c(Name='Test Form', FormCode__c = 'FORM', AccountID__c = a.ID, BudgetDSID__c = bds.ID);       
        insert f;
        // create the user we're using for the test cases
        User u = [select ID, UserCode__c from User where ID = :UserInfo.getUserId()];
        u.UserCode__c = 'UTIL1'; 
        update u;
        // create a field hard limit
        FieldHardLimit__c fhl = new FieldHardLimit__c(FieldName__c = 'LimitField', FieldLimit__c = 20);
        insert fhl;
        // create state record
        insert new States__c(State__c='MA', StateName__c='Massachusetts');
        // create form parameters for the test cases
        insert new FormParameter__c(FormID__c=f.ID, ParameterName__c='thisUtilityCode', ParameterValue__c='UTIL');
        insert new FormParameter__c(FormID__c=f.ID, ParameterName__c='thisUserCode', ParameterValue__c='UTIL1');
        insert new FormParameter__c(FormID__c=f.ID, ParameterName__c='initialStatus', ParameterValue__c='eSubmit');
        insert new FormParameter__c(FormID__c=f.ID, ParameterName__c='limitedRebate', ParameterValue__c='Test {a} test');
        // create a form list entry
        insert new FormList__c(ListName__c='Test', InternalValue__c='A', DisplayValue__c='Another');
        // create form fields for the test cases
        insert new FormFields__c(FormID__c=f.ID, DataType__c='String', FieldName__c='LastName', TargetTable__c='Contact', 
            BlankStop__c='hardres');
        insert new FormFields__c(FormID__c=f.ID, DataType__c='String', FieldName__c='AccountNumber__c', TargetTable__c='Contact', 
            BlankStop__c='none', TestValue__c='1234');
        insert new FormFields__c(FormID__c=f.ID, DataType__c='Boolean', FieldName__c='ReceiveEmail__c', TargetTable__c='Contact', 
            BlankStop__c='none', TestValue__c='true');
        insert new FormFields__c(FormID__c=f.ID, DataType__c='String', FieldName__c='ServiceZipcode__c', TargetTable__c='Contact', 
            BlankStop__c='none', TestValue__c='12345'); // needed for pcust lookup code
        insert new FormFields__c(FormID__c=f.ID, DataType__c='Boolean', FieldName__c='ManualStoreFlag', TargetTable__c='Rebate__c',
            BlankStop__c='none', TestValue__c='true', DoNotSave__c=true);
        insert new FormFields__c(FormID__c=f.ID, DataType__c='Boolean', FieldName__c='SelStoreState', TargetTable__c='Rebate__c',
            BlankStop__c='none', TestValue__c='MA', DoNotSave__c=true);
        insert new FormFields__c(FormID__c=f.ID, DataType__c='Boolean', FieldName__c='SelStoreCity', TargetTable__c='Rebate__c',
            BlankStop__c='none', TestValue__c='Boston', DoNotSave__c=true);
        insert new FormFields__c(FormID__c=f.ID, DataType__c='String', FieldName__c='StoreID__c', TargetTable__c='Rebate__c',
            BlankStop__c='none');
        insert new FormFields__c(FormID__c=f.ID, DataType__c='Date', FieldName__c='PurchaseDate__c', TargetTable__c='Rebate__c',
            BlankStop__c='none', TestValue__c='5/1/2012');
        insert new FormFields__c(FormID__c=f.ID, DataType__c='Date', FieldName__c='PostmarkDate__c', TargetTable__c='Rebate__c',
            BlankStop__c='none'); // would not be on form, but need blank and non-blank dates for testing
        insert new FormFields__c(FormID__c=f.ID, DataType__c='String', FieldName__c='SubmitAs', TargetTable__c='Rebate__c',
            BlankStop__c='none', InitValue__c='Reservation', TestValue__c='Reservation', DoNotSave__c=true);
        insert new FormFields__c(FormID__c=f.ID, DataType__c='String', FieldName__c='SubmitVia__c', TargetTable__c='Rebate__c',
            BlankStop__c='none');
        insert new FormFields__c(FormID__c=f.ID, DataType__c='Boolean', FieldName__c='ManualModelFlag', 
            TargetTable__c='RebateDetail__c', RecordCode__c='M', BlankStop__c='none', TestValue__c='true', DoNotSave__c=true);
		insert new FormFields__c(FormID__c=f.ID, DataType__c='Boolean', FieldName__c='MeasureSelected', 
			TargetTable__c='RebateDetail__c', RecordCode__c='M', BlankStop__c='none', TestValue__c='false', DoNotSave__c=true);
        insert new FormFields__c(FormID__c=f.ID, DataType__c='String', FieldName__c='MeasureCode__c', 
            TargetTable__c='RebateDetail__c', RecordCode__c='M', BlankStop__c='soft', TestValue__c='M');
        insert new FormFields__c(FormID__c=f.ID, DataType__c='String', FieldName__c='Manufacturer__c', 
            TargetTable__c='RebateDetail__c', RecordCode__c='M', BlankStop__c='soft', TestValue__c='KENMORE');
        insert new FormFields__c( FormID__c=f.ID, DataType__c='String', FieldName__c='ModelNumber__c', 
            TargetTable__c='RebateDetail__c', RecordCode__c='M', BlankStop__c='soft', TestValue__c='XYZ');
        insert new FormFields__c( FormID__c=f.ID, DataType__c='Decimal', FieldName__c='MeasureRebateAmount__c', 
            TargetTable__c='RebateDetail__c', RecordCode__c='M', BlankStop__c='none', TestValue__c='100');
        insert new FormFields__c( FormID__c=f.ID, DataType__c='Decimal', FieldName__c='Quantity__c', 
            TargetTable__c='RebateDetail__c', RecordCode__c='M', BlankStop__c='none', TestValue__c='1',
            RangeStop__c='soft', RangeMin__c='1', RangeMax__c='2', ScaleStop__c='soft', ScaleMax__c=0);
        insert new FormFields__c(FormID__c=f.ID, DataType__c='Boolean', FieldName__c='SelManufacturer', TargetTable__c='RebateDetail__c',
            RecordCode__c='M', BlankStop__c='none', DoNotSave__c=true);
        insert new FormFields__c(FormID__c=f.ID, DataType__c='String', FieldName__c='ModelID__c', TargetTable__c='RebateDetail__c',
            RecordCode__c='M', BlankStop__c='none');
        insert new FormFields__c(FormID__c=f.ID, DataType__c='String', FieldName__c='HouseType', TargetTable__c='RebateSurvey__c',
            BlankStop__c='none', TestValue__c='SF');
        insert new FormFields__c(FormID__c=f.ID, DataType__c='Decimal', FieldName__c='HouseUnits', TargetTable__c='RebateSurvey__c',
            BlankStop__c='none', TestValue__c='1');
        insert new FormFields__c(FormID__c=f.ID, DataType__c='Date', FieldName__c='InstallDate', TargetTable__c='RebateSurvey__c',
            BlankStop__c='none', TestValue__c='5/1/2012');
        FormEFIStandardv3 c = new FormEFIStandardv3();              // create the controller instance for the test suite
        Test.startTest();
        // The official test starts here
        c.showErrorIcons();
        c.clearErrorIcons();
        List<selectOption> tl = c.makeFormList('Test','dropdown');
        c.storeEntry = 'enter';                             // no lookup option 
        c.makeStoreList();                                  // but make store list anyway
        c.getStoreList();
        c.setStringField('RebateSurvey__c.HouseType','XY');
        String testStr = c.getStringField('RebateSurvey__c.HouseType');
        Boolean testBool = c.blankOrDefaultField('RebateSurvey__c.HouseType');                               
        c.testInit();               
        c.makeManufacturerList('M');
        c.getStateList();                   
        c.initializeSession();
        c.getSessionData();
        c.actionCheckMe();                                  // display validation errors
        c.formFields.get('Contact.LastName').stringValue = 'Smith';
        c.actionCheckMe();                                  // submit a form, overrides soft stops (as Reservation)
        c.showRebate();                                     // show the reservation
        Rebate__c reb = [select ID, RebateStatusMM__c, HashCode__c from Rebate__c where HashCode__c = :c.frmHashCode];
        RebateDetail__c rd = [select ID, DetailStatus__c, RebateID__c from RebateDetail__c where RebateID__c = :reb.ID];
        rd.DetailStatus__c = 'eSubmit';                     // change it to rebate
        update rd;
        c.showRebate();                                     // show the rebate now
        c.formFields.get('RebateDetail__c.Quantity__c.M').effScaleStop = 'none';
        c.handleScaleError(c.formFields.get('RebateDetail__c.Quantity__c.M')); 
        c.formFields.get('RebateDetail__c.Quantity__c.M').effScaleStop = 'soft';
        c.handleScaleError(c.formFields.get('RebateDetail__c.Quantity__c.M')); 
        c.formFields.get('RebateDetail__c.Quantity__c.M').effScaleStop = 'hard';
        c.handleScaleError(c.formFields.get('RebateDetail__c.Quantity__c.M')); 
        c.formFields.get('RebateDetail__c.Quantity__c.M').effRangeStop = 'none';
        c.handleRangeError(c.formFields.get('RebateDetail__c.Quantity__c.M'),'min'); 
        c.formFields.get('RebateDetail__c.Quantity__c.M').effRangeStop = 'soft';
        c.handleRangeError(c.formFields.get('RebateDetail__c.Quantity__c.M'),'min'); 
        c.formFields.get('RebateDetail__c.Quantity__c.M').effRangeStop = 'hard';
        c.handleRangeError(c.formFields.get('RebateDetail__c.Quantity__c.M'),'max'); 
        Test.stopTest();
    }
}