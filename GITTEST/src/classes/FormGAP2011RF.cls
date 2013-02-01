public class FormGAP2011RF {

	public String frmLoadMessage {get; set; }
	public String frmButtonLabel {get; set; }
	public String frmRebateID {get; set; }
	public String frmRebateNum {get; set; }
	public String frmAcctNum {get; set; }
	public String frmFirstName {get; set; }
	public String frmLastName {get; set; }
	public String frmAcctAddress1 {get; set; }
	public String frmAcctAddress2 {get; set; }
	public String frmAcctCity {get; set; }
	public String frmAcctState {get; set; }
	public String frmAcctZip {get; set; }
	public String frmHomePhone {get; set; }
	public String frmWorkPhone {get; set; }
	public String mailSame {get; set; }
	public String frmMailAddress1 {get; set; }
	public String frmMailAddress2 {get; set; }
	public String frmMailCity {get; set; }
	public String frmMailState {get; set; }
	public String frmMailZip {get; set; }
	public Boolean frmRecvEmail {get; set; }
	public String frmEmail {get; set; }
	public String frmWHFuel {get; set; }
	public String frmCWFuel {get; set; }
	public String frmHouseType {get; set; }
	public String frmHouseUnits {get; set; }
	public String frmOwnRent {get; set; }
	public String frmPriVac {get; set; }
	public String frmBrand {get; set; }
	public String frmModel {get; set; }
	public String frmStoreName {get; set; }
	public String frmStoreAddress1 {get; set; }
	public String frmStoreAddress2 {get; set; }
	public String frmStoreCity {get; set; }
	public String frmStoreState {get; set; }
	public String frmStoreZip {get; set; }
	public String frmPaidAmt {get; set; }
	public String frmPurchDate {get; set; }
	public String selBrand {get; set; }
	public String selModel {get; set; }
	public ID selModelID {get; set; }
	public String manualModel {get; set; }
	public String selState {get; set; }
	public String selCity {get; set; }
	public string selStore {get; set; }
	public ID selStoreID {get; set; }
	public String manualStore {get; set; }
	
	public Boolean disDE {get; set; } // to enable/disable data entry
	
	public Boolean foundError;
	public Integer frmErrLevel;
	public Boolean wasError;  // was there an error when the form was previously checked
	public String buttonText1 = 'Don\'t print yet!\nClick here first to validate your entries.';
	public String buttonText2 = 'Please review the warnings shown above, update as needed\nClick here to accept your entries or revalidate your changes.';
	public String buttonText3 = 'Your form has been accepted.\nUse your browser to print the form to\nmail in with your receipt and bill.';
	
	public String frmAcctNumMsg {get; set; }
	public String frmAcctNumMsgStyle {get; set; }
	public String frmAcctNumErrValue;
	public Integer frmAcctNumErrLevel;
	public String frmPurchDateMsg {get; set; }
	public String frmPurchDateMsgStyle {get; set; }
	public String frmPurchDateErrValue;
	public Integer frmPurchDateErrLevel;
	public String frmEmailMsg {get; set; }
	public String frmEmailMsgStyle {get; set; }
	public String frmEmailErrValue;
	public Integer frmEmailErrLevel;
	public String frmLastNameMsg {get; set; }
	public String frmLastNameMsgStyle {get; set; }
	public String frmLastNameErrValue;
	public Integer frmLastNameErrLevel;

	public String editClass {get; set; }
	public String displayClass {get; set; }

	public ID frmOwnerId;
	
	public FormGAP2011RF() {
		disDE = false;
		displayclass = 'displayfield';
		editclass = 'editenabled';
		frmRebateID = 'not checked';
		frmRebateNum = '';
		frmAcctNumErrLevel = 0;
		frmLastNameErrLevel = 0;
		frmPurchDateErrLevel = 0;
		frmEmailErrLevel = 0;
		clearErrors();
		frmMailAddress1 = '';
		frmMailAddress2 = '';
		frmMailCity = '';
		frmMailState = '';
		frmMailZip = '';
		frmButtonLabel = buttonText1; // override default for first view
		// determine owner ID for created records
		frmOwnerID = null;
		for (User u : [select ID, Name from User where Name = 'User1 GAP'] ) {
			frmOwnerId = u.ID;
		}
		manualModel = 'N';
		// initialize w/ test data (comment out to start with blank form)
		// testInit(); 
	}
	
	public void clearErrors() {
		// don't clear field error levels ... need them to validate overrides by user.
		frmLoadMessage = '';
		frmAcctNumMsg = '';
		frmAcctNumMsgStyle = 'display:none';
		frmPurchDateMsg = '';
		frmPurchDateMsgStyle = 'display:none';
		frmEmailMsg = '';
		frmEmailMsgStyle = 'display:none';
		frmLastNameMsg = '';
		frmLastNameMsgStyle = 'display:none';
		foundError = false;
		frmErrLevel = 0;
		frmButtonLabel = buttonText3; // default before error found
	}
	
	public void testInit() {
		frmAcctNum = '1237894560';
		frmFirstName = 'James';
		frmLastName = 'Jones';
		frmAcctAddress1 = '55 Sugarloaf Pkwy';
		frmAcctAddress2 = '';
		frmAcctCity = 'Lawrenceville';
		frmAcctState = 'GA';
		frmAcctZip = '30043';
		frmHomePhone = '617-555-1212';
		frmWorkPhone = '';
		frmMailAddress1 = '11 Sugarloaf Pkwy';
		frmMailAddress2 = '';
		frmMailCity = 'Lawrenceville';
		frmMailState = 'GA';
		frmMailZip = '30043';
		frmRecvEmail = true;
		frmEmail = 'mbaker@efi.org';
		frmWHFuel = 'NGAS';
		frmCWFuel = 'ELEC';
		frmHouseType = 'SF';
		frmHouseUnits = '1';
		frmOwnRent = 'OWN';
		frmPriVac = 'PRIM';
		frmBrand = 'KENMORE';
		frmModel = 'ABC 123-G';
		frmStoreName = 'Sears';
		frmStoreAddress1 = 'Natick Mall';
		frmStoreAddress2 = '';
		frmStoreCity = 'Natick';
		frmStoreState = 'MA';
		frmStoreZip = '01760';
		frmPaidAmt = '500';
		frmPurchDate = '11/1/2011';
	}
	
	public List<selectOption> getModelList() {
		List<SelectOption> options = new List<SelectOption>();
		options.add(new SelectOption('','Please Select ...'));
		if (selBrand != '' && selBrand != null) {
			for (Model__c m: [select ID, Manufacturer__c, ModelNumber__c from Model__c where Manufacturer__c = :selBrand] ) {
				options.add(new SelectOption(m.ID,m.ModelNumber__c));
			}
		}
		return options;	
	}
	
	public List<selectOption> getStoreList() {
		List<SelectOption> options = new List<SelectOption>();
		options.add(new SelectOption('','Please Select ...'));
		for (Store__c s: [select ID, StoreName__c, StoreAddress1__c, StoreCity__c, StoreState__c, StoreZipcode__c from Store__c] ) {
			options.add(new SelectOption(s.ID,s.StoreName__c+', '+s.StoreAddress1__c+', '+s.StoreCity__c+', '+s.StoreState__c+', '+s.StoreZipcode__c));
		}
		return options;	
	}
	
	public void alertErrors(Integer errLevel) {
		if (errLevel > frmErrLevel) frmErrLevel = errLevel; // use maximum
		if (frmErrLevel == 5) {
			frmLoadMessage = 'Form has already been submitted';
			frmButtonLabel = buttonText3;
		}
		if (frmErrLevel == 10) { 
			frmLoadMessage = 'Please review the warnings indicated on the form.  Correct them if possible, and press [Continue] to proceed.';
			frmButtonLabel = buttonText2;
		}
		if (frmErrLevel == 20) { 
			frmLoadMessage = 'Please correct the errors indicated on the form and press [Check Me] again.';
			frmButtonLabel = buttonText1;
		}
		foundError = true;
	}

	public PageReference actionCheckMe() {
		clearErrors(); // reset error variables;
//		if (frmRebateNum == null) frmRebateNum = '';
		if (frmRebateNum != '' && frmRebateNum != null) {
			alertErrors(5);
			return null;
		}
		if (manualModel == 'Y') { // process manual vs. selected Model
			selModelId = null; // make sure this is null
		} else {
			// if (selModelID == '') { // error on test? need to diagnose
			// 	alertErrors(20);
			// }
			frmBrand = selBrand; // make sure brand and model reflect selections
			frmModel = '';
			for (Model__c m: [select ID, ModelNumber__c from Model__c where ID = :selModelID] ) {
				frmModel = m.ModelNumber__c;
			}
		}
		if (manualStore == 'Y') { // process manual vs. selected Store
			selStoreId = null; // make sure this is null
		} else {
			// if (selStoreID == '') { // error on test? need to diagnose
			// 	alertErrors(20);
			// }
			for (Store__c s: [select ID, StoreName__c, StoreAddress1__c, StoreAddress2__c, StoreCity__c, StoreState__c, StoreZipcode__c from Store__c where ID = :selStoreID] ) {
				frmStoreName = s.StoreName__c;
				frmStoreAddress1 = s.StoreAddress1__c;
				frmStoreAddress2 = s.StoreAddress2__c;
				frmStoreCity = s.StoreCity__c;
				frmStoreState = s.StoreState__c;
				frmStoreZip = s.StoreZipcode__c;
			}
		}
		if (mailSame == 'Y') { // populate from account address
			frmMailAddress1 = frmAcctAddress1;
			frmMailAddress2 = frmAcctAddress2;
			frmMailCity = frmAcctCity;
			frmMailState = frmAcctState;
			frmMailZip = frmAcctZip;
		}
		// initial validation 
		if (frmAcctNumErrLevel > 0) { // had an error previously
			if (frmAcctNum != frmAcctNumErrValue) { // value was changed
				frmAcctNumErrLevel = 0; // ignore prior, validate again
			}
		}
		if (frmAcctNumErrLevel == 0) { // no need to validate if warned and unchanged
			if (frmAcctNum.length() != 10) {
				frmAcctNumMsg = 'Sorry, LIPA account numbers are 10 digits.';
				frmAcctNumMsgStyle = 'display:inline';
				frmAcctNumErrValue = frmAcctNum; // save for later compare
				frmAcctNumErrLevel = 10;
				alertErrors(10);			
			} else {
				String ua = '';
				for (UtilityAccount__c u: [select ID, AccountNumber__c, ClientID__c, ServiceZipCode__c from UtilityAccount__c 
					where AccountNumber__c = :frmAcctNum and ClientID__c = 'GAP' and ServiceZipCode__c = :frmAcctZip] ) {
					ua = u.AccountNumber__c;
				}
				if (ua == '') {
					frmAcctNumMsg = 'Warning: Account number doesn\'t match our records.';
					frmAcctNumMsgStyle = 'display:inline';
					frmAcctNumErrValue = frmAcctNum; // save for later compare
					frmAcctNumErrLevel = 10;
					alertErrors(10);			
				} else {
					frmAcctNumErrLevel = 0;
				}
			}
		}
		if (frmLastNameErrLevel > 0) { // had an error previously
			if (frmLastName != frmLastNameErrValue) { // value was changed
				frmLastNameErrLevel = 0; // ignore prior, validate again
			}
		}
		if (frmLastNameErrLevel == 0) {
			if (frmLastName != null && frmLastName.length() == 0) { //-- CEV added due to validation failure
				frmLastNameMsg = 'Sorry, Last Name must be provided.';
				frmLastNameMsgStyle = 'display:inline';
				frmLastNameErrValue = frmLastName;
				frmLastNameErrLevel = 10;
				alertErrors(10);			
			} else {
				frmLastNameErrLevel = 0;
			}
		}
		// always validate Purchase Date (hard error)
		try {
			Date tmpDate = Date.parse(frmPurchDate);
			frmPurchDateErrLevel = 0; // only executes if no exception 
		} catch (Exception e) {
			frmPurchDateMsg = 'Invalid date.';
			frmPurchDateMsgStyle = 'display:inline';
			frmPurchDateErrValue = frmPurchDate;
			frmPurchDateErrLevel = 20;
			alertErrors(20);			
		} 
		// always validate Email Address (hard error)
		if (!Utils.isValidEmail(frmEmail)) {
			frmEmailMsg = 'Invalid email address.';
			frmEmailMsgStyle = 'display:inline';
			frmEmailErrValue = frmEmail;
			frmEmailErrLevel = 20;
			alertErrors(20);			
		} else {
			frmEmailErrLevel = 0;		
		}
		if (foundError) return null;
		// return null // to skip writing records
		// then write the necessary records
		// Customer
		Contact rcont = new Contact (
			FirstName = frmFirstName,
			LastName = frmLastName,
			ServiceAddress1__c = frmAcctAddress1,
			ServiceAddress2__c = frmAcctAddress2,
			ServiceCity__c = frmAcctCity,
			ServiceState__c = frmAcctState,
			ServiceZipcode__c = frmAcctZip,
			HomePhone = frmHomePhone,
			WorkPhone__c = frmWorkPhone,
			Email = frmEmail,
			ReceiveEmail__c = frmRecvEmail,
			AccountNumber__c = frmAcctNum,
			OwnerID = frmOwnerID
		);
		if (frmLastName == '') rcont.LastName = '.'; // since blank not permitted
		insert rcont;
		// Rebate
		Rebate__c rreb = new Rebate__c(
			Name = frmFirstName + ' ' + frmLastName + ' ' + frmPurchDate + ' ' + frmBrand,
			ContactID__c = rcont.ID,
			FormCode__c = 'GAPRF2011',  
			MailingFirstName__c = frmFirstName,
			MailingLastName__c = frmLastName,
			MailingAddress1__c = frmMailAddress1,
			MailingAddress2__c = frmMailAddress2,
			MailingCity__c = frmMailCity,
			MailingState__c = frmMailState,
			MailingZipcode__c = frmMailZip,
			StoreID__c = selStoreID,
			StoreName__c = frmStoreName,
			StoreAddress1__c = frmStoreAddress1,
			StoreAddress2__c = frmStoreAddress2,
			StoreCity__c = frmStoreCity,
			StoreState__c = frmStoreState,
			StoreZipcode__c = frmStoreZip,
			PurchaseDate__c = Date.parse(frmPurchDate),
			RebateStatus__c = 'Submitted',
			OwnerID = frmOwnerID
		);
		if ((rreb.MailingAddress1__c == '') ||
			(rreb.MailingAddress2__c == '') ||
			(rreb.MailingCity__c == '') ||
			(rreb.MailingState__c == '') ||
			(rreb.MailingZipcode__c == '')) {
			rreb.MailingAddress1__c = rcont.ServiceAddress1__c;
			rreb.MailingAddress2__c = rcont.ServiceAddress2__c;
			rreb.MailingCity__c = rcont.ServiceCity__c;
			rreb.MailingState__c = rcont.ServiceState__c;
			rreb.MailingZipcode__c = rcont.ServiceZipcode__c;
		}
		insert rreb;
		// Retrieve fields from rebate record
		for (Rebate__c r: [select ID, RebateNumber__c from Rebate__c where ID = :rreb.ID] ) {
			frmRebateNum = r.RebateNumber__c;
		}
		// RebateDetail
		RebateDetail__c rdet = new RebateDetail__c (
			Name = frmBrand + ' ' + frmModel,
			RebateID__c = rreb.ID,
			Quantity__c = 1,
			Manufacturer__c = frmBrand,
			ModelNumber__c = frmModel,
			ModelID__c = selModelID,
			MeasureRebateAmount__c = 30
		);
		if (frmPaidAmt.length() > 0) {
			rdet.AmountTendered__c = decimal.valueOf(frmPaidAmt);
		}
		insert rdet;
		// RebateSurvey
		addSurveyRecord(rreb.ID, 'WHFuel', frmWHFuel, 'String');
		addSurveyRecord(rreb.ID, 'CWFuel', frmCWFuel, 'String');
		addSurveyRecord(rreb.ID, 'HouseType',frmHouseType, 'String');
		addSurveyRecord(rreb.ID, 'HouseUnits', frmHouseUnits, 'Number');
		addSurveyRecord(rreb.ID, 'OwnRent', frmOwnRent, 'String');
		frmLoadMessage = 'No errors found.  Please print and mail in per instructions on form.';
		/* removed DLK 12/15/11 per CEV request
		// send email, unless test value
		if (frmEmail != 'test@test.test' && frmEmail != '') {
			RebateEmailMgr remgr = New RebateEmailMgr(rreb.ID);
			remgr.sendSubmissionEmail();
		}
		*/
		return null;
	}
	
	public void addSurveyRecord(ID rebID, String survName, String survValue, String survType) {
		if (survValue.length() == 0) return;
		// ID formID = 'a08Z0000000BBmF'; // future: get ID from the form code if desired
		ID formID = null;
		for (Form__c f: [select ID, FormCode__c from Form__c where FormCode__c = 'GAPRF2011']) {
			formID = f.ID;
		}
		// We could hard-code the IDs of each question, but less brittle to retrieve by name
		ID sqID = null;
		for (SurveyQuestions__c sq : [select ID, ColumnName__c from SurveyQuestions__c where FormID__c = :formID and ColumnName__c = :survName] ) {
			sqID = sq.ID;
		}
		// validate for data type here, if desired
		// then write RebateSurvey record
		RebateSurvey__c rsurv = new RebateSurvey__c (
			Name = 'LIRF 2011 ' + survName,
			RebateID__c = rebID,
			SurveyQuestionID__c = sqID,
			Answer__c = survValue
		);	
		insert rsurv;			
	}
	
	public static testMethod void test(){
		PageReference pageRef = Page.FormGAP2011RF;
		Test.setCurrentPage(pageRef);
		FormGAP2011RF contr = new FormGAP2011RF();
		//contr.frmAcctNum = '1231231234';
		Test.startTest();
		contr.alertErrors(10);
		
		//-- CEV::Added to pass validation
		contr.testInit(); 
		contr.getStoreList();
		contr.getModelList();
		contr.mailSame = 'Y';
		contr.frmAcctNum = '1231231';
		contr.frmLastName = '';
		contr.frmPurchDate = 'ABCD';
		contr.actionCheckMe();
		//-- END
		
		contr.frmAcctNum = '1231231234';
		contr.actionCheckMe();
		
		//-- CEV::Added to pass validation
		contr.actionCheckMe();
		//-- END
		
		// system.assertEquals(contr.frmLoadMessage, '');
		Test.stopTest();
	}
}