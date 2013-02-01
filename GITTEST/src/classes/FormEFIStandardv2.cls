public virtual class FormEFIStandardv2 {

	public String thisFormCode = 'FORM'; // need to override
	public String thisFormID; // determined from form
	public String thisAccountID;  // determined from form
	public String thisClientCode; // determined from form
	// thisUserCode is a parameter
    public ID frmOwnerId; // determined from user
    // thisUtilityCode is a parameter
    public String thisRecordCode; // set in the custom controller (temporary solution, until multi-detail form)
        
	public Boolean debugging = false;  // write some details to log when desired
	public String debugText {get; set; }
	public Boolean writeRecs = true; // can turn off for some testing/debugging
	public Boolean testMode = false; // populate form w/test values, otherwise initial values
	public Boolean showIcons = false; // show error icons, to test layout
	public String pCustCheck = 'soft'; // check account number in PCust (requires Zip code) = 'hard', 'soft', 'none'
	public String storeEntry = 'both'; // select, enter or both
	public String mailEntry = 'enter'; // same, enter or both
	        
	public String frmLoadMessage {get; set; }
    public String frmReadOnly {get; set; } // for non-VF inputs
	public String frmShowInvoice {get; set; } // for dialog    
	public String frmStatus {get; set; }
	public String frmRebateNum {get; set; }
	public String frmRebateID;
	public String frmPostalCode; // only used for showRebate, regular variable needed since may not be present on form

	public String frmButtonLabel {get; set; }
    public Boolean disableDE {get; set; } // to enable/disable data entry
    public String editClass {get; set; }
    public String displayClass {get; set; }

    public Boolean foundError;
    public Integer frmErrLevel;
    public Boolean wasError;  // was there an error when the form was previously checked

    public String saveSessionID;    // for session management
    public String saveRebateNum;
    public String saveMailZip;

	public class SetupException extends Exception {}
	
    public List<selectOption> stateList {get; set; }
	public List<SelectOption> storeList = new List<SelectOption>(); 
	public List<SelectOption> modelList = new List<selectOption>();
        
	/*
	The following fields are initialized as params:
		initialStatus, 		thisUserCode,		thisUtilityCode
		buttonTextInit,		buttonTextError, 	buttonTextWarn,		buttonTextOk, 		buttonTextView,		buttonTextReload
		messageTextOk,		messageTextError,	messageTextWarn,	messageTextDupe,	messageTextView,	messageTextReload
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
       	public String rangeStop {get; set; }
       	public String scaleStop {get; set; }
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
       		if (dataType == 'Boolean') { booleanValue = (stringValue == 'true'); }
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
    
    public class DetailInfo {
    	public String recordCode {get; set; }
    	public String modelEntry {get; set; }
    	public Boolean mfrLoaded {get; set; }
    	public List<selectOption> mfrList {get; set;}
    	public String modelMfr {get; set; } 			// which manufacturer was the model list generated from?
    	public List<selectOption> modelList {get; set; }
    	public DetailInfo (String rcode, String metype) {
    		recordCode = rcode;
    		modelEntry = metype;
    		mfrLoaded = false;
    		mfrList = new List<selectOption>();
    		modelMfr = '-x-';							// use a value that is not likely, to force initialization
    		modelList = new List<selectOption>();
    	}
    }

	public Map<String, DetailInfo> details {get; set; }
	
	// the following are old 'new' items, delete when converted.
	// public Map<String,String> modelEntry = new Map<String, String>(); // select, enter or both for each
	// public Map<String, List<selectOption>> mfrList {get; set; }	// hold list for each measure type

	public FormEFIStandardv2() {
		String fn;
		details = new Map<String, DetailInfo>(); // initialize this first, so initializeConstructor has access
		params = new Map<String, String>();
		fieldHardLimits = new Map<String, Decimal>();
		formFields = new Map<String, FormField>();
		initializeConstructor();
		if (debugging) system.debug('EFILOG: Entered Base Constructor');
		// mfrList	= new Map<String, List<selectOption>>();
		getFormParameters();		// no longer hard-coded
		getFormFields();			// no longer hard-coded
		frmRebateNum = ApexPages.currentPage().getParameters().get('RebateNumber');
		frmPostalCode = ApexPages.currentPage().getParameters().get('PostalCode');
		if (frmRebateNum != null && frmRebateNum  != '') {
		        frmButtonLabel = params.get('buttonTextView');
		        frmLoadMessage = params.get('messageTextView');
		        showRebate();
		        return;
		}
		disableDE = false;
		frmReadOnly = 'no';
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
		// frmButtonLabel = params.get('buttonTextOk'); // default before error found
		frmLoadMessage = '';
		frmShowInvoice = '';
		frmButtonLabel = params.get('buttonTextInit'); // override default for first view
		// determine owner ID for created records
		frmOwnerID = null;
		for (User u : [select ID, Name from User where UserCode__c = :params.get('thisUserCode')] ) {
			frmOwnerId = u.ID;
		}
		stateList = makeStateList();
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
		makeModelList();			// can initialize, once all the fields are known (including initialization)
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

	/*
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
	    for (Form__c f: [select ID, FormCode__c, AccountID__c, ClientCode__c from Form__c 
            where FormCode__c = :thisFormCode] ) {
            thisFormID = f.ID;
            thisAccountID = f.AccountID__c;
            thisClientCode = f.ClientCode__c;
	    }
	    if (thisFormID == null) throw new SetupException('Form not defined!');
	    // then get the parameters
	    for (FormParameter__c fp: [select ParameterName__c, SelectorName__c, ParameterValue__c
            from FormParameter__c where FormID__c = :thisFormID]) {
            Params.put(fp.ParameterName__c, fp.ParameterValue__c);
	    }
	    // then get the hard limits
	    for (FieldHardLimit__c fhl: [select FieldName__c, FieldLimit__c from FieldHardLimit__c]) {
	    	fieldHardLimits.put(fhl.FieldName__c, fhl.FieldLimit__c);
	    }
	}
	
	public void getFormFields() {
		String tempKey;
		detailRecs = new Set<String>(); // initialize
		for (FormFields__c f: [select ID, FieldName__c, RecordCode__c, TargetTable__c, DataType__c, TestValue__c, InitValue__c,
			VisibleWith__c, VisibleState__c, BlankStop__c, RangeStop__c, ScaleStop__c, RangeMin__c, RangeMax__c, ScaleMax__c, 
			BlankMessage__c, RangeMessage__c, ScaleMessage__c, InvalidMessage__c, FieldLabel__c, DoNotSave__c, SkipPdoxSend__c
			from FormFields__c where FormID__c = :thisFormID]) {
			tempKey = f.targetTable__c+'.'+f.FieldName__c+((f.targetTable__c == 'RebateDetail__c') ? '.'+f.RecordCode__c : '');
			formFields.put(tempKey, new FormField(f.ID, f.FieldName__c, f.RecordCode__c, f.TargetTable__c, f.DataType__c, 
				f.TestValue__c, f.InitValue__c, f.VisibleWith__c, f.VisibleState__c, f.BlankStop__c, f.RangeStop__c, f.ScaleStop__c,
				f.RangeMin__c, f.RangeMax__c, f.ScaleMax__c, f.BlankMessage__c, f.RangeMessage__c, f.ScaleMessage__c, 
				f.InvalidMessage__c, f.FieldLabel__c, f.DoNotSave__c, f.SkipPdoxSend__c));
			if (f.TargetTable__c == 'RebateDetail__c' && !Utils.isEmpty(f.RecordCode__c)) {
				detailRecs.add(f.RecordCode__c); // duplicate adds are ok
				/*
				if (!modelEntry.containsKey(f.RecordCode__c)) modelEntry.put(f.RecordCode__c, 'enter'); // default value, no lookup
				if ((modelEntry.get(f.RecordCode__c) == 'select' || modelEntry.get(f.RecordCode__c) == 'both') &&
					!mfrList.containsKey(f.RecordCode__c)) makeManufacturerList(f.RecordCode__c);
				*/
				// main already have been initialized ... if not initialize here
				if (!details.containsKey(f.RecordCode__c)) details.put(f.RecordCode__c, new DetailInfo(f.RecordCode__c,'enter'));
				if (!details.get(f.RecordCode__c).mfrLoaded) { // load manufacturer list if it isn't already loaded
					if (details.get(f.RecordCode__c).modelEntry == 'select' || details.get(f.RecordCode__c).modelEntry == 'both')
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
        List<Rebate__c> rebs = [select ID, AccountNumber__c, ContactID__c, 
			MailingFirstName__c, MailingLastName__c, MailingAddress1__c,
			MailingAddress2__c, MailingCity__c, MailingState__c, MailingZipCode__c,
			StoreID__c, StoreName__c, StoreAddress1__c, StoreAddress2__c, StoreCity__c,
			StoreState__c, StoreZipCode__c, StorePhone__c, 
			PurchaseDate__c, RebateStatus__c, CustomerComment__c,
			TermsConditions__c, UtilityCode__c
			from Rebate__c where RebateNumber__c = :frmRebateNum
	        and MailingZipCode__c = :frmPostalCode
	        and FormCode__c = :thisFormCode];
	        if (rebs.size() != 1) { frmRebateNum = 'not found'; return; }
	        Rebate__c reb = rebs.get(0);
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
		if (reb.RebateStatus__c != 'eSubmit') { frmStatus = 'Other'; return; }
        contID = reb.ContactID__c;
        rebID = reb.ID;
		for (String ff: fieldSet) {
			f = formFields.get(ff);
			if (f.TargetTable == 'Rebate__c' && !f.doNotSave) {
				if (f.DataType == 'String') {
					f.stringValue = (String)reb.get(f.fieldName);
				}
				if (f.DataType == 'Date') {
					if (reb.get(f.fieldName) == null) {
						f.dateValue = null;
						f.stringValue = '';
					} else {
						f.dateValue = (Date)reb.get(f.fieldName); // not sure if this is needed here
						f.stringValue = ((Date)reb.get(f.fieldName)).format(); // this one is displayed
					}
				}
			}
		}
		k = 'Rebate__c.ManualStoreFlag';
		if (fieldSet.contains(k)) formFields.get(k).booleanValue = true;
		k = 'Rebate__c.MailSameFlag';
		if (fieldSet.contains(k)) formFields.get(k).booleanValue = false;
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
			Contact cont = conts.get(0);
			for (String ff: fieldSet) {
				f = formFields.get(ff);
				if (f.TargetTable == 'Contact' && !f.doNotSave) {
					if (f.DataType == 'String') {
						f.stringValue = (String)cont.get(f.fieldName);
					}
					if (f.DataType == 'Boolean') {
						f.booleanValue = (Boolean)cont.get(f.fieldName);
						f.stringValue = (f.booleanValue) ? 'Y' : '';
					}
				}
			}
		}
		for (RebateDetail__c rd: [select Manufacturer__c, ModelNumber__c, AmountTendered__c, InstallDate__c, MeasureCode__c,
			MeasureRebateAmount__c, Quantity__c, RecordCode__c, ReplacedManufacturer__c, ReplacedModelNumber__c
			from RebateDetail__c
			where RebateID__c = :rebID]) {
				showRebateDetail(rd, 'Manufacturer__c');
				showRebateDetail(rd, 'ModelNumber__c');
				showRebateDetail(rd, 'AmountTendered__c');
				showRebateDetail(rd, 'MeasureCode__c');
				showRebateDetail(rd, 'MeasureRebateAmount__c');
				showRebateDetail(rd, 'Quantity__c');
				showRebateDetail(rd, 'InstallDate__c');
				showRebateDetail(rd, 'ReplacedManufacturer__c');
				showRebateDetail(rd, 'ReplacedModelNumber__c');
				k = 'RebateDetail__c.ManualModelFlag.'+rd.RecordCode__c;  // always display as manual model
				if (fieldSet.contains(k)) formFields.get(k).booleanValue = true;
				k = 'RebateDetail__c.MeasureSelected.'+rd.RecordCode__c;  // enable display of this measure
				if (fieldSet.contains(k)) formFields.get(k).booleanValue = true;
		}
		for (RebateSurvey__c rs: [select ColumnName__c, Answer__c
			from RebateSurvey__c where RebateID__c = :rebID]) {
			if (formFields.containsKey('RebateSurvey__c.'+rs.ColumnName__c)) {
				f = formFields.get('RebateSurvey__c.'+rs.ColumnName__c);
				f.stringValue = (rs.Answer__c == null) ? '' : rs.Answer__c;
				if (f.dataType == 'Boolean') f.BooleanValue = (f.stringValue == 'Y'); // for checkboxes
			}
		}
		disableDE = true;
		frmReadOnly = 'yes';
		afterShowRebate();
	}

	public void showRebateDetail(RebateDetail__c rd, String fld) {
		String k = 'RebateDetail__c.'+fld+'.'+rd.RecordCode__c;
		if (!fieldSet.contains(k)) return;
		String t = formFields.get(k).dataType;
		if (t == 'String' || t == 'ID') { formFields.get(k).stringValue = (String)rd.get(fld); return; }
		if (t == 'Decimal') {
			formFields.get(k).decimalValue = (Decimal)rd.get(fld);
			if (formFields.get(k).decimalValue != null) formFields.get(k).stringValue = formFields.get(k).decimalValue.format();
		}
		if (t == 'Date') {
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
			if (f.dataType == 'String') { 
				f.stringValue = f.testValue;
	       		if (f.stringValue == null) f.stringValue = '';
			}
			if (f.dataType == 'Boolean') {
				f.booleanValue = (f.testValue == 'true');
				f.stringValue = f.booleanValue ? 'Y' : '';
			}
			if (f.dataType == 'Date') {
				f.stringValue = f.testValue;
				try {
					f.dateValue = Date.parse(f.testValue);					
				} catch (Exception e) {
					f.dateValue = null;
					f.stringValue = ''; // if invalid, initialize to blank
				}
			} 
			if (f.dataType == 'Decimal') { 
				f.stringValue = f.testValue;
				try {
					f.decimalValue = Decimal.valueOf(f.testValue);					
				} catch (Exception e) {
					f.decimalValue = null;
					f.stringValue = ''; // if invalid, initialize to blank
				}
			}
		}
		if (storeEntry.toLowerCase() != 'enter') makeStoreList();
		afterTestInit();
	}
        
	public virtual void beforeTestInit() {
		// override to place custom code before showRebate()
	}
	
	public virtual void afterTestInit() {
		// override to place custom code before showRebate()
	}
	
	/*
	// need to update this to populate a list for each RebateDetail.  (Use a Map, generate one for each RecordCode)
	public List<selectOption> getManufacturerList() {
	    List<SelectOption> options = new List<SelectOption>();
	    options.add(new SelectOption('','Please Select ...'));
	    for (Manufacturer__c m: [select ID, Manufacturer__c from Manufacturer__c 
			where ID in (select ManufacturerID__c from FormXManufacturer__c where FormID__c = :thisFormID) order by Manufacturer__c] ) {
			options.add(new SelectOption(m.Manufacturer__c, m.Manufacturer__c));
	    }
	    return options; 
	}
	*/

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

	/*
	// need to update this to populate a list for each RebateDetail.  (Use a Map, generate one for each RecordCode)
	public List<selectOption> getModelList() {
		List<SelectOption> options = new List<SelectOption>();
		String mfrfld = 'RebateDetail__c.SelManufacturer.'+thisRecordCode;
		options.add(new SelectOption('','Please Select ...'));
		if (formFields.get(mfrfld).stringValue != '' && formFields.get(mfrfld).stringValue != null) {
			for (Model__c m: [select ID, Manufacturer__c, ModelNumber__c from Model__c 
				where Manufacturer__c = :formFields.get(mfrfld).stringValue and
				ID in (select ModelID__c from FormXModel__c where FormID__c = :thisFormID) order by ModelNumber__c] ) {
				options.add(new SelectOption(m.ID,m.ModelNumber__c));
			}
		}
		return options; 
	}
	*/
	
	// this is the new approach (object-based), scan to check for changes since can't pass argument
	public void makeModelList() {
		for (DetailInfo d: details.values()) {
			List<SelectOption> options = new List<SelectOption>();
			String mfrfld = 'RebateDetail__c.SelManufacturer.'+d.recordCode;
			String mfr = formFields.get(mfrfld).stringValue;
			if (mfr == d.modelMfr) continue; // skip this one if same as generated previously
			options.add(new SelectOption('','Please Select ...')); 			// this choice, even if none to choose
			// options.add(new SelectOption('mfr',':'+mfr)); for diagnostics (only issue for Thermostats?)
			if (!Utils.isEmpty(mfr)) {		// search if a manufacturer provided
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
		if (listType.toLowerCase() != 'radio') options.add(new SelectOption('','Please Select ...'));
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
		if (ss.stringValue != null && ss.stringValue != '' && sc.stringValue != null && sc.StringValue != '') {
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
		if (level == 'hard') {
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
		if (debugging) system.debug('EFILOG: Entered CheckMe');
		debugText = '';
		getSessionData(); // detect reload or back button
		if (saveRebateNum != '' && saveRebateNum != null) {
			frmRebateNum = saveRebateNum;
			formFields.get('Rebate__c.MailingZipcode__c').stringValue = saveMailZip;
			showRebate();
			frmButtonLabel = params.get('buttonTextReload');
			frmLoadMessage = params.get('messageTextReload');
			return null;
		}
		clearErrorIcons(); // reset error variables;
		frmButtonLabel = params.get('buttonTextOk'); // default before error found
		frmLoadMessage = '';
		frmShowInvoice = '';
		foundError = false;
		frmErrLevel = 0;
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
			if (f.dataType == 'Boolean') { f.stringValue = f.booleanValue ? 'Y' : ''; }
			if (!Utils.isEmpty(f.visibleWith)) { // is this field sometimes invisible?
				if (!(f.visibleState == formFields.get(f.visibleWith).booleanValue)) continue; // if so, skip validation
			}
			if ((f.targetTable == 'RebateDetail__c') && fieldSet.contains('RebateDetail__c.MeasureSelected.'+f.recordCode)) { // is this field associated with an invisible measure?
				if (!formFields.get('RebateDetail__c.MeasureSelected.'+f.recordCode).booleanValue) continue; //if so, skip validation
			}
			// then create date value, hard error if fails
			if (f.dataType == 'Date') {
				if (f.stringValue == '') { f.dateValue = null; }
				else {
					try { f.dateValue = Date.parse(f.stringValue); }
					catch (Exception e) {
						f.errorMsg = (f.invalidMessage == '') ? 'Error: Invalid date.' : f.invalidMessage;
						recordError(f, 'hard');
						continue; // no need to do any more with this field
					}
				}
				if (f.rangeMin == '') { minDate = null; }
				else if (f.rangeMin == 'today') { minDate = Date.today(); }
				else {
					try { minDate = date.parse(f.rangeMin); }
					catch (Exception e) { minDate = null; }
				}
				if (f.rangeMax == '') { maxDate = null; }
				else if (f.rangeMax == 'today') { maxDate = Date.today(); }
				else {
					try { maxDate = date.parse(f.rangeMax); }
					catch (Exception e) { maxDate = null; }
				}
			}
			if (f.dataType == 'Decimal') {
				if (f.stringValue == '') { f.decimalValue = null; }
				else {
					try { f.decimalValue = Decimal.valueOf(f.stringValue); }
					catch (Exception e) {
						f.errorMsg = (f.invalidMessage == '') ? 'Error: Invalid number.' : f.invalidMessage;
						recordError(f, 'hard');
						continue; // no need to do any more with this field
					}
				}
				if (f.rangeMin == '') { minDecimal = null; }
				else {
					try { minDecimal = Decimal.valueOf(f.rangeMin); }
					catch (Exception e) { minDecimal = null; }
				}
				if (f.rangeMax == '') { maxDecimal = null; }
				else {
					try { maxDecimal = Decimal.valueOf(f.rangeMax); }
					catch (Exception e) { maxDecimal = null; }
				}
			}
			// then set flag if soft error and value not changed
			f.seenSoftError = ((f.errorLevel == 10) && (f.stringValue == f.errorValue)) ? true : false;
			if (!f.seenSoftError) {
				f.errorLevel = 0; // initialize
				if (f.dataType == 'String') { // validate hard and soft errors
					if (f.stringValue == '') handleBlankError(f); 
					if ((f.errorLevel < 20) && (fieldHardLimits.containsKey(f.fieldName)) && 
						(f.stringValue.length() > fieldHardLimits.get(f.fieldName))) {
						f.errorMsg = 'Error: Field content too long.';
						recordError(f, 'hard');
					}
					if ((f.fieldName == 'AccountNumber__c') && (pCustCheck != 'none') && (!Utils.isEmpty(f.stringValue)) &&
						fieldSet.contains('Contact.ServiceZipcode__c')) {
						accountPCustLookup(f);
					}
					if (f.fieldName == 'Email') { // always check for well-formed email address
						if (!Utils.isValidEmail(f.stringValue)) {
							f.errorMsg = 'Error: Invalid email address.';
							recordError(f, 'hard');
						}								
					}
				}
				if (formFields.get(ff).dataType == 'Decimal') {
					// f.decimalValue, minDecimal, maxDecimal all set above
					if (f.decimalValue == null) handleBlankError(f);
					if ((f.decimalValue != null) && (minDecimal != null) && (f.decimalValue < minDecimal)) handleRangeError(f,'min');
					if ((f.decimalValue != null) && (maxDecimal != null) && (f.decimalValue > maxDecimal)) handleRangeError(f,'max');
					if ((f.decimalValue != null) && (f.scaleMax != null) && (f.decimalValue.scale() > f.scaleMax)) handleScaleError(f);
				}
				if (formFields.get(ff).dataType == 'Date') {
					// f.dateValue, minDate, maxDate all set above
					if (f.dateValue == null) handleBlankError(f);
					if ((f.dateValue != null) && (minDate != null) && (f.dateValue < minDate)) handleRangeError(f,'min');
					if ((f.dateValue != null) && (maxDate != null) && (f.dateValue > maxDate)) handleRangeError(f,'max');
				}
				if (formFields.get(ff).dataType == 'Boolean') {
					// no standard boolean validations for now
				}
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
		Contact rcont = new Contact (
			AccountID = thisAccountID,
			OwnerID = frmOwnerID
		);
		for (String ff: fieldSet) {
			f = formFields.get(ff);
			if (f.targetTable == 'Contact' && !f.doNotSave) { // except for ReceiveEmail__c, all Contact fields we use are Strings
				if (f.fieldName == 'LastName') {
					rcont.put(f.fieldName, (f.stringValue == '') ? '.' : f.stringValue);
				} else if (f.fieldName.contains('Address1')) { // strip out 'Line #' help text, if present
		            rcont.put(f.fieldName, (f.stringValue == 'Line 1') ? '' : f.stringValue);
				} else if (f.fieldName.contains('Address2')) {
		            rcont.put(f.fieldName, (f.stringValue == 'Line 2') ? '' : f.stringValue);
				} else if (f.datatype == 'Boolean') {
					rcont.put(f.fieldName, f.booleanValue);
				} else if (f.datatype == 'Date') {
					rcont.put(f.fieldName, f.dateValue);
				} else if (f.datatype == 'Decimal') {
					rcont.put(f.fieldName, f.decimalValue);
				} else {
					rcont.put(f.fieldName, f.stringValue);
				}
			}
		}
		if (writeRecs) insert rcont;
		// Rebate
		Rebate__c rreb = new Rebate__c(
			Name = thisFormCode + ' | ' + formFields.get('Contact.AccountNumber__c').stringValue,
			ContactID__c = rcont.ID,
			FormID__c = thisFormID,
			FormCode__c = thisFormCode,
			UtilityCode__c = params.get('thisUtilityCode'),  
			Origin__c = 'FDC',
			OwnerID = frmOwnerID
		);
		for (String ff: fieldSet) {
			f = formFields.get(ff);
			if (f.targetTable == 'Rebate__c' && !f.doNotSave) { // except for PurchaseDate__c, all Contact fields we use are Strings
				if (f.fieldName.contains('Address1')) { // strip out 'Line #' help text, if present
		            rreb.put(f.fieldName, (f.stringValue == 'Line 1') ? '' : f.stringValue);
				} else if (f.fieldName.contains('Address2')) {
		            rreb.put(f.fieldName, (f.stringValue == 'Line 2') ? '' : f.stringValue);
				} else if (f.datatype == 'Boolean') {
					rreb.put(f.fieldName, f.booleanValue);
				} else if (f.datatype == 'Date') {
					rreb.put(f.fieldName, f.dateValue);
				} else if (f.datatype == 'Decimal') {
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
		if (writeRecs) insert rreb;
		// Retrieve fields from rebate record
		for (Rebate__c r: [select ID, RebateNumber__c, MailingZipcode__c from Rebate__c where ID = :rreb.ID] ) {
			frmRebateNum = r.RebateNumber__c;  // from retrieved record, won't be updated in rreb
			Utils.saveSessionData(saveSessionID, 'RebateNumber', frmRebateNum);
			Utils.saveSessionData(saveSessionID, 'MailZipcode', r.MailingZipcode__c);
		}
		// RebateDetail
		for (String dr: detailRecs) {
			if (decideWriteDetailRecord(dr)) {
				RebateDetail__c rdet = new RebateDetail__c (
					Name = rreb.Name + ' | ' + formFields.get('RebateDetail__c.MeasureCode__c.'+dr).stringValue,
					RebateID__c = rreb.ID,
					DetailStatus__c = params.get('initialStatus'),
					RecordCode__c = dr,
					Quantity__c = 1 // initialize, might be overridden
				);
				for (String ff: fieldSet) {
					f = formFields.get(ff);
					if (f.targetTable == 'RebateDetail__c' && f.recordCode == dr && !f.doNotSave) {
						if (f.dataType == 'Decimal') {
							rdet.put(f.fieldName, f.decimalValue);
						} else if (f.datatype == 'Date') {
							rdet.put(f.fieldName, f.dateValue);
						} else if (f.datatype == 'Boolean') {
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
		for (String ff: fieldSet) {
			f = formFields.get(ff);
			if (f.targetTable == 'RebateSurvey__c') {
				addSurveyRecord(rreb.ID, f);
			}
		}
		frmLoadMessage = params.get('messageTextOk');
		disableDE = true;
		frmReadOnly = 'yes';
		// send email, unless test value
		if (formFields.containsKey('Contact.Email')) {
			if (formFields.get('Contact.Email').stringValue != 'test@test.test' && formFields.get('Contact.Email').stringValue != '') {
				RebateEmailMgr remgr = New RebateEmailMgr();
				remgr.sendEmail(rreb.id);
			}
		}
		return null;
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
		if (ua == '') {
			f.warnMsg = ((pCustCheck == 'soft') ? 'Warning' : 'Error') + ': Account number doesn\'t match our records.';
			recordError(f, pCustCheck);
			frmShowInvoice = 'Yes';
		}
	}
	
	public void handleBlankError(formField f) {
		if (f.blankStop == 'none') return;
		if (f.blankStop == 'hard') {
			f.errorMsg = (f.blankMessage == '') ? 'Error: Field is blank, please provide.' : f.blankMessage;
		}
		if (f.blankStop == 'soft') {
			f.warnMsg = (f.blankMessage == '') ? 'Warning: Field is blank, please provide if available.' : f.blankMessage;
		}
		recordError(f, f.blankStop);
	}
	
	public void handleRangeError(formField f, String dir) {
		String msg;
		if (f.rangeStop == 'none') return;
		if (f.dataType == 'Date') {
			msg = (dir == 'min') ? 'Field is before ' + f.rangeMin : 'Field is after ' + f.rangeMax;
		} else {
			msg = (dir == 'min') ? 'Field is less than ' + f.rangeMin : 'Field is more than ' + f.rangeMax;
		}
		if (f.rangeStop == 'hard') {
			f.errorMsg = (f.rangeMessage == '') ? 'Error: ' + msg : f.rangeMessage;
		}
		if (f.rangeStop == 'soft') {
			f.warnMsg = (f.rangeMessage == '') ? 'Warning: ' + msg : f.rangeMessage;
		}
		recordError(f, f.rangeStop);
	}
	
	public void handleScaleError(formField f) {
		String msg;
		if (f.scaleStop == 'none') return;
		msg = 'Field may have up to '+String.valueOf(f.scaleMax)+' decimal Places.';
		if (f.scaleStop == 'hard') {
			f.errorMsg = (f.scaleMessage == '') ? 'Error: '+msg : f.scaleMessage;
		}
		if (f.scaleStop == 'soft') {
			f.warnMsg = (f.scaleMessage == '') ? 'Warning: '+msg : f.scaleMessage;
		}
		recordError(f, f.scaleStop);
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

// @isTest(SeeAllData=True)
	static testMethod void test(){   // was public static void
		// create the account we're using for the test cases
		Account a = new Account(Name='Test Account', ClientCode__c='CLIENT');
		insert a;
		// create the form we're using for the test cases
		Form__c f = new Form__c(Name='Test Form', FormCode__c = 'FORM', AccountID__c = a.ID);		
		insert f;
		// create the user we're using for the test cases
		User u = [select ID, UserCode__c from User where ID = :UserInfo.getUserId()];
		u.UserCode__c = 'UTIL1'; 
		update u;
		// create state record
		insert new States__c(State__c='MA', StateName__c='Massachusetts');
		// create form parameters for the test cases
		insert new FormParameter__c(FormID__c=f.ID, ParameterName__c='thisUtilityCode', ParameterValue__c='UTIL');
		insert new FormParameter__c(FormID__c=f.ID, ParameterName__c='thisUserCode', ParameterValue__c='UTIL1');
		insert new FormParameter__c(FormID__c=f.ID, ParameterName__c='initialStatus', ParameterValue__c='eSubmit');
		// create a form list entry
		insert new FormList__c(ListName__c='Test', InternalValue__c='A', DisplayValue__c='Another');
		// create form fields for the test cases
		insert new FormFields__c(FormID__c=f.ID, DataType__c='String', FieldName__c='LastName', TargetTable__c='Contact', 
			BlankStop__c='hard');
		insert new FormFields__c(FormID__c=f.ID, DataType__c='String', FieldName__c='AccountNumber__c', TargetTable__c='Contact', 
			BlankStop__c='none', TestValue__c='1234');
		insert new FormFields__c(FormID__c=f.ID, DataType__c='Boolean', FieldName__c='ManualStoreFlag', TargetTable__c='Rebate__c',
			BlankStop__c='none', TestValue__c='true', DoNotSave__c=true);
		insert new FormFields__c(FormID__c=f.ID, DataType__c='Boolean', FieldName__c='SelStoreState', TargetTable__c='Rebate__c',
			BlankStop__c='none', TestValue__c='MA', DoNotSave__c=true);
		insert new FormFields__c(FormID__c=f.ID, DataType__c='Boolean', FieldName__c='SelStoreCity', TargetTable__c='Rebate__c',
			BlankStop__c='none', TestValue__c='Boston', DoNotSave__c=true);
		insert new FormFields__c(FormID__c=f.ID, DataType__c='String', FieldName__c='StoreID__c', TargetTable__c='Rebate__c',
			BlankStop__c='none');
		insert new FormFields__c(FormID__c=f.ID, DataType__c='Date', FieldName__c='PurchaseDate__c', TargetTable__c='Rebate__c',
			BlankStop__c='none');
		insert new FormFields__c(FormID__c=f.ID, DataType__c='Boolean', FieldName__c='ManualModelFlag', TargetTable__c='RebateDetail__c',
			RecordCode__c='M', BlankStop__c='none', TestValue__c='true', DoNotSave__c=true);
		insert new FormFields__c(FormID__c=f.ID, DataType__c='String', FieldName__c='MeasureCode__c', 
			TargetTable__c='RebateDetail__c', RecordCode__c='M', BlankStop__c='soft', TestValue__c='M');
		insert new FormFields__c(FormID__c=f.ID, DataType__c='String', FieldName__c='Manufacturer__c', 
			TargetTable__c='RebateDetail__c', RecordCode__c='M', BlankStop__c='soft', TestValue__c='KENMORE');
		insert new FormFields__c( FormID__c=f.ID, DataType__c='String', FieldName__c='ModelNumber__c', 
			TargetTable__c='RebateDetail__c', RecordCode__c='M', BlankStop__c='soft', TestValue__c='XYZ');
		insert new FormFields__c( FormID__c=f.ID, DataType__c='Decimal', FieldName__c='MeasureRebateAmount__c', 
			TargetTable__c='RebateDetail__c', RecordCode__c='M', BlankStop__c='none', TestValue__c='100');
		insert new FormFields__c(FormID__c=f.ID, DataType__c='Boolean', FieldName__c='SelManufacturer', TargetTable__c='RebateDetail__c',
			RecordCode__c='M', BlankStop__c='none', DoNotSave__c=true);
		insert new FormFields__c(FormID__c=f.ID, DataType__c='String', FieldName__c='ModelID__c', TargetTable__c='RebateDetail__c',
			RecordCode__c='M', BlankStop__c='none');
		insert new FormFields__c(FormID__c=f.ID, DataType__c='String', FieldName__c='HouseType', TargetTable__c='RebateSurvey__c',
			BlankStop__c='none', TestValue__c='SF');
		insert new FormFields__c(FormID__c=f.ID, DataType__c='Decimal', FieldName__c='HouseUnits', TargetTable__c='RebateSurvey__c',
			BlankStop__c='none', TestValue__c='1');
		FormEFIStandardv2 c = new FormEFIStandardv2();				// create the controller instance for the test suite
		Test.startTest();
		// The official test starts here
		c.showErrorIcons();
		c.clearErrorIcons();
		List<selectOption> tl = c.makeFormList('Test','dropdown');
		c.storeEntry = 'enter';								// no lookup option	
		c.makeStoreList();									// but make store list anyway
		c.getStoreList();								
		c.testInit();				
		c.makeManufacturerList('M');
		c.getStateList();					
		c.initializeSession();
		c.getSessionData();
		c.actionCheckMe();									// display validation errors
		c.formFields.get('Contact.LastName').stringValue = 'Smith';
		c.actionCheckMe();									// submit a form, overrides soft stops
		c.showRebate();										// run code to display an existing rebate
		Test.stopTest();
	}			
}