public class FormSGE2012RFv2 {

        public String thisFormCode = 'SGERF2012';
        public String thisFormID; // determined in initialization
        public String thisAccountID;
        public String thisMeasureCode = 'RF_75';
        public Decimal thisMeasureAmount = 75;
        public String thisUserCode = '';//'User1 SCL';
        public String thisUtilityCode = '';//'SCL';
        public String initialStatus = '';//'eSubmit';
        public Boolean debugging = true;  // write to log
        public Boolean writeRecs = true; // for debugging
        
        // initial button
        public String buttonTextInit = ''; //'Don\'t print yet!\nClick here first to validate your entries.';
        // error button
        public String buttonTextError = ''; //'Please correct the indicated errors.\nClick here to revalidate.';
        // warning button
        public String buttonTextWarn = ''; //'Please review the warnings shown above, update as needed\nClick here to accept your entries or revalidate your changes.';
        // accepted button
        public String buttonTextOk = ''; //'Your form has been accepted.\nUse your browser to print the form to\nmail in with your receipt and bill.';
        // view button
        public String buttonTextView = ''; //'Your saved form has been retrieved.\nUse your browser to print the form to\nmail in with your receipt and bill.';
        // reload/back button (if finished)
        public String buttonTextReload = ''; //'Your form has been accepted.\nUse your browser to print the form to\nmail in with your receipt and bill.';
        // no errors
        public String messageTextOk = ''; //'No errors found.  Please print and mail in per instructions on form.';
        // errors reported
        public String messageTextError = ''; //'Please correct the errors indicated on the form and press [Check Me] again.';
        // warnings only, no errors
        public String messageTextWarn = ''; //'Please review the warnings indicated on the form.  Correct them if possible, and press [Continue] to proceed.';
        // already submitted (prevented now)
        public String messageTextDupe = ''; //'Form has already been submitted';
        // view request (no message needed)
        public String messageTextView = '';
        // reload/back detected
        public String messageTextReload = ''; //'Reload or Back button detected.  Saved information has been retrieved.';
        
        public String frmLoadMessage {get; set; }
		public String frmStatus {get; set; }
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
        public Boolean frmHasDehum {get; set; }
        public Boolean frmHasWall {get; set; }
        public Boolean frmHasWindow {get; set; }
        public String frmDH;
        public String frmRAC_Wall; 
        public String frmRAC_Window;
        public String frmEmail {get; set; }
        public String frmWHFuel {get; set; }
        public String frmCWFuel {get; set; }
        public String frmHouseType {get; set; }
        public String frmHouseUnits {get; set; }
        public Decimal frmHouseUnitsDecimal; // converted string to decimal for FDC object
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
        public Decimal frmPaidAmtDecimal; // converted string to decimal for FDC object
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
        public String frmInstallDate {get; set; }
        public String frmSerialNum {get; set; }
        public String frmExistModel {get; set; }
        public String frmHaulawayCo {get; set; }
        public String frmHaulawayDate {get; set; }
        public String frmExistWorking {get; set; }
        public String selHCID {get; set; }
        public String selHC {get; set; }
        public String manualHC {get; set; }
        
        public Boolean disableDE {get; set; } // to enable/disable data entry
        public String frmReadOnly {get; set; } // for non-VF inputs
        public String editClass {get; set; }
        public String displayClass {get; set; }
        public ID frmOwnerId;
        public String saveSessionID;
        public String saveRebateNum;
        public String saveMailZip;
        
        public Boolean foundError;
        public Integer frmErrLevel;
        public Boolean wasError;  // was there an error when the form was previously checked
        
        public String frmAcctNumMsg {get; set; }
        public String frmAcctNumMsgStyle {get; set; }
        public String frmAcctNumMsgRed {get; set; }
        public String frmAcctNumMsgStyleRed {get; set; }
        public String frmAcctNumErrValue;
        public Integer frmAcctNumErrLevel;
        public String frmFirstNameMsg {get; set; }
        public String frmFirstNameMsgStyle {get; set; }
        public String frmFirstNameErrValue;
        public Integer frmFirstNameErrLevel;
        public String frmLastNameMsg {get; set; }
        public String frmLastNameMsgStyle {get; set; }
        public String frmLastNameErrValue;
        public Integer frmLastNameErrLevel;
        public String frmAcctAddress1Msg {get; set; }
        public String frmAcctAddress1MsgStyle {get; set; }
        public String frmAcctAddress1ErrValue;
        public Integer frmAcctAddress1ErrLevel;
        public String frmAcctCityMsg {get; set; }
        public String frmAcctCityMsgStyle {get; set; }
        public String frmAcctCityErrValue;
        public Integer frmAcctCityErrLevel;
        public String frmAcctStateMsg {get; set; }
        public String frmAcctStateMsgStyle {get; set; }
        public String frmAcctStateErrValue;
        public Integer frmAcctStateErrLevel;
        public String frmAcctZipMsg {get; set; }
        public String frmAcctZipMsgStyle {get; set; }
        public String frmAcctZipErrValue;
        public Integer frmAcctZipErrLevel;
        public String frmMailAddress1Msg {get; set; }
        public String frmMailAddress1MsgStyle {get; set; }
        public String frmMailAddress1ErrValue;
        public Integer frmMailAddress1ErrLevel;
        public String frmMailCityMsg {get; set; }
        public String frmMailCityMsgStyle {get; set; }
        public String frmMailCityErrValue;
        public Integer frmMailCityErrLevel;
        public String frmMailStateMsg {get; set; }
        public String frmMailStateMsgStyle {get; set; }
        public String frmMailStateErrValue;
        public Integer frmMailStateErrLevel;
        public String frmMailZipMsg {get; set; }
        public String frmMailZipMsgStyle {get; set; }
        public String frmMailZipErrValue;
        public Integer frmMailZipErrLevel;
        public String frmEmailMsg {get; set; }
        public String frmEmailMsgStyle {get; set; }
        public String frmEmailMsgRed {get; set; }
        public String frmEmailMsgStyleRed {get; set; }
        public String frmEmailErrValue;
        public Integer frmEmailErrLevel;
        public String selBrandMsg {get; set; }
        public String selBrandMsgStyle {get; set; }
        public String selBrandErrValue;
        public Integer selBrandErrLevel;
        public String selModelIDMsg {get; set; }
        public String selModelIDMsgStyle {get; set; }
        public String selModelIDErrValue;
        public Integer selModelIDErrLevel;
        public String frmBrandMsg {get; set; }
        public String frmBrandMsgStyle {get; set; }
        public String frmBrandErrValue;
        public Integer frmBrandErrLevel;
        public String frmModelMsg {get; set; }
        public String frmModelMsgStyle {get; set; }
        public String frmModelErrValue;
        public Integer frmModelErrLevel;
        public String selCityMsg {get; set; }
        public String selCityMsgStyle {get; set; }
        public String selCityErrValue;
        public Integer selCityErrLevel;
        public String selStoreIDMsg {get; set; }
        public String selStoreIDMsgStyle {get; set; }
        public String selStoreIDErrValue;
        public Integer selStoreIDErrLevel;
        public String frmStoreNameMsg {get; set; }
        public String frmStoreNameMsgStyle {get; set; }
        public String frmStoreNameErrValue;
        public Integer frmStoreNameErrLevel;
        public String frmStoreAddress1Msg {get; set; }
        public String frmStoreAddress1MsgStyle {get; set; }
        public String frmStoreAddress1ErrValue;
        public Integer frmStoreAddress1ErrLevel;
        public String frmStoreCityMsg {get; set; }
        public String frmStoreCityMsgStyle {get; set; }
        public String frmStoreCityErrValue;
        public Integer frmStoreCityErrLevel;
        public String frmStoreStateMsg {get; set; }
        public String frmStoreStateMsgStyle {get; set; }
        public String frmStoreStateErrValue;
        public Integer frmStoreStateErrLevel;
        public String frmStoreZipMsg {get; set; }
        public String frmStoreZipMsgStyle {get; set; }
        public String frmStoreZipErrValue;
        public Integer frmStoreZipErrLevel;
        public String frmPaidAmtMsg {get; set; }
        public String frmPaidAmtMsgStyle {get; set; }
        public String frmPaidAmtMsgRed {get; set; }
        public String frmPaidAmtMsgStyleRed {get; set; }
        public String frmPaidAmtErrValue;
        public Integer frmPaidAmtErrLevel;
        public String frmPurchDateMsg {get; set; }
        public String frmPurchDateMsgStyle {get; set; }
        public String frmPurchDateErrValue;
        public Integer frmPurchDateErrLevel;
        public String frmHouseUnitsMsg {get; set; }
        public String frmHouseUnitsMsgStyle {get; set; }
        public String frmHouseUnitsErrValue;
        public Integer frmHouseUnitsErrLevel;
        public String frmInstallDateMsg {get; set; }
        public String frmInstallDateMsgStyle {get; set; }
        public String frmInstallDateErrValue;
        public Integer frmInstallDateErrLevel;
        public String frmSerialNumMsg {get; set; }
        public String frmSerialNumMsgStyle {get; set; }
        public String frmSerialNumErrValue;
        public Integer frmSerialNumErrLevel;
        public String frmExistModelMsg {get; set; }
        public String frmExistModelMsgStyle {get; set; }
        public String frmExistModelErrValue;
        public Integer frmExistModelErrLevel;
        public String frmExistWorkingMsg {get; set; }
        public String frmExistWorkingMsgStyle {get; set; }
        public String frmExistWorkingErrValue;
        public Integer frmExistWorkingErrLevel;
        public String frmHaulawayCoMsg {get; set; }
        public String frmHaulawayCoMsgStyle {get; set; }
        public String frmHaulawayCoErrValue;
        public Integer frmHaulawayCoErrLevel;
        public String frmHaulawayDateMsg {get; set; }
        public String frmHaulawayDateMsgStyle {get; set; }
        public String frmHaulawayDateErrValue;
        public Integer frmHaulawayDateErrLevel;
        public String selHCIdMsg {get; set; }
        public String selHCIdMsgStyle {get; set; }      
        public Integer selHCIdErrLevel;

        public class SetupException extends Exception {}
        
        public List<SelectOption> storeList = new List<SelectOption>();

        public FormSGE2012RFv2() {
                if (debugging) system.debug('EFILOG: Entered FormSGE2012RF');
                getFormParameters(); // no longer hard-coded
                frmRebateNum = ApexPages.currentPage().getParameters().get('RebateNumber');
                frmMailZip = ApexPages.currentPage().getParameters().get('PostalCode');
                if (frmRebateNum != null && frmRebateNum  != '') {
                        frmButtonLabel = buttonTextView;
                        frmLoadMessage = messageTextView;
                        showRebate();
                        return;
                }
                disableDE = false;
                frmReadOnly = 'no';
                displayclass = 'displayfield';
                editclass = 'editenabled';
                frmRebateID = 'not checked';
                frmRebateNum = '';
                saveSessionID = UserInfo.getSessionID();
                clearErrorLevels();
                clearErrors();
                frmButtonLabel = buttonTextOk; // default before error found
                frmLoadMessage = '';
                frmMailAddress1 = '';
                frmMailAddress2 = '';
                frmMailCity = '';
                frmMailState = '';
                frmMailZip = '';
                frmButtonLabel = buttonTextInit; // override default for first view
                // determine owner ID for created records
                frmOwnerID = null;
                for (User u : [select ID, Name from User where UserCode__c = :thisUserCode] ) {
                        frmOwnerId = u.ID;
                }
                manualModel = 'N';
                manualStore = 'N';
                manualHC = 'N';
                selState = 'MA';
                // makeStoreList(); // first time (not needed for SCL?)
                // initialize w/ test data (comment out to start with blank form)
                testInit();
        }
        
        public void initializeSession() {
                String sessID = UserInfo.getSessionID();
                addSessionRecord(sessID, 'RebateNumber', '');
                addSessionRecord(sessID, 'MailZipcode', '');
        }
        
        public void getFormParameters() {
                // get form ID from form code
                thisFormID  = null;
                for (Form__c f: [select ID, FormCode__c, AccountID__c from Form__c 
                        where FormCode__c = :thisFormCode] ) {
                        thisFormID = f.ID;
                        thisAccountID = f.AccountID__c;
                }
                if (thisFormID == null) throw new SetupException('Form not defined!');
                for (FormParameter__c fp: [select ParameterName__c, SelectorName__c, ParameterValue__c
                        from FormParameter__c where FormID__c = :thisFormID]) {
                        if (fp.ParameterName__c == 'initialStatus') { initialStatus = fp.ParameterValue__c; }   
                        if (fp.ParameterName__c == 'thisUserCode') { thisUserCode = fp.ParameterValue__c; }     
                        if (fp.ParameterName__c == 'thisUtilityCode') { thisUtilityCode = fp.ParameterValue__c; }       
                        if (fp.ParameterName__c == 'buttonTextInit') { buttonTextInit = fp.ParameterValue__c; } 
                        if (fp.ParameterName__c == 'buttonTextError') { buttonTextError = fp.ParameterValue__c; }       
                        if (fp.ParameterName__c == 'buttonTextWarn') { buttonTextWarn = fp.ParameterValue__c; } 
                        if (fp.ParameterName__c == 'buttonTextOk') { buttonTextOk = fp.ParameterValue__c; }     
                        if (fp.ParameterName__c == 'buttonTextView') { buttonTextView = fp.ParameterValue__c; } 
                        if (fp.ParameterName__c == 'buttonTextReload') { buttonTextReload = fp.ParameterValue__c; }     
                        if (fp.ParameterName__c == 'messageTextOk') { messageTextOk = fp.ParameterValue__c; }   
                        if (fp.ParameterName__c == 'messageTextError') { messageTextError = fp.ParameterValue__c; }     
                        if (fp.ParameterName__c == 'messageTextWarn') { messageTextWarn = fp.ParameterValue__c; }       
                        if (fp.ParameterName__c == 'messageTextDupe') { messageTextDupe = fp.ParameterValue__c; }       
                        if (fp.ParameterName__c == 'messageTextView') { messageTextView = fp.ParameterValue__c; }       
                        if (fp.ParameterName__c == 'messageTextReload') { messageTextReload = fp.ParameterValue__c; }   
                }
        }
        
        public void showRebate() {
                if (debugging) system.debug('EFILOG: Entered showRebate');
                ID contID;
                ID rebID;
                // get rebate record
                clearErrors();
                List<Rebate__c> rebs = [select ID, AccountNumber__c, ContactID__c, 
                        MailingFirstName__c, MailingLastName__c, MailingAddress1__c,
                        MailingAddress2__c, MailingCity__c, MailingState__c, MailingZipCode__c,
                        StoreName__c, StoreAddress1__c, StoreAddress2__c, StoreCity__c,
                        StoreState__c, StoreZipCode__c, PurchaseDate__c, RebateStatus__c
                        from Rebate__c where RebateNumber__c = :frmRebateNum
                                and MailingZipCode__c = :frmMailZip
                                and FormCode__c = :thisFormCode];
                if (rebs.size() != 1) {
                        frmRebateNum = 'not found';
                        return;                 
                }
                Rebate__c reb = rebs.get(0);
				if (reb.RebateStatus__c != 'eSubmit') {
					frmStatus = 'Other';
					return;
				}
                contID = reb.ContactID__c;
                rebID = reb.ID;
                frmFirstName = reb.MailingFirstName__c;
                frmLastName = reb.MailingLastName__c;
                frmMailAddress1 = reb.MailingAddress1__c;
                frmMailAddress2 = reb.MailingAddress2__c;
                frmMailCity = reb.MailingCity__c;
                frmMailState = reb.MailingState__c;
                frmMailZip = reb.MailingZipcode__c;
                frmStoreName = reb.StoreName__c;
                frmStoreAddress1 = reb.StoreAddress1__c;
                frmStoreAddress2 = reb.StoreAddress2__c;
                frmStoreCity = reb.StoreCity__c;
                frmStoreState = reb.StoreState__c;
                frmStoreZip = reb.StoreZipcode__c;
                frmPurchDate = reb.PurchaseDate__c.format();
                List<Contact> conts = [select ID, HomePhone, WorkPhone__c, Email, ReceiveEmail__c,
                        ServiceAddress1__c, ServiceAddress2__c, ServiceCity__c, ServiceState__c,
                        ServiceZipcode__c,  AccountNumber__c
                        from Contact where ID = :contID];
                if (conts.size() != 1) {
                        frmAcctNum = 'not found';
                        return;                 
                } else {
                        Contact cont = conts.get(0);
                        // process account number
                        frmAcctNum = cont.AccountNumber__c;
                        frmAcctAddress1 = cont.ServiceAddress1__c;
                        frmAcctAddress2 = cont.ServiceAddress2__c;
                        frmAcctCity = cont.ServiceCity__c;
                        frmAcctState = cont.ServiceState__c;
                        frmAcctZip = cont.ServiceZipcode__c;
                        frmHomePhone = cont.HomePhone;
                   //     frmWorkPhone = cont.WorkPhone__c;     // not used for SCL
                   //     frmRecvEmail = cont.ReceiveEmail__c;  // not used for SCL
                        frmEmail = cont.Email;
                }
                List<RebateDetail__c> rds = [select Manufacturer__c, ModelNumber__c, AmountTendered__c
                        from RebateDetail__c
                        where RebateID__c = :rebID];
                if (rds.size() != 1) {
                        frmAcctNum = 'not found';
                        return;                 
                } else {
                        RebateDetail__c rd = rds.get(0);
                        frmBrand = rd.Manufacturer__c;
                        frmModel = rd.ModelNumber__c;
                        // frmPaidAmt = String.valueOf(rd.AmountTendered__c); // not used for SCL
                }
                disableDE = true;
                frmReadOnly = 'yes';
                // mailSame = 'N'; // not used for SCL
                manualModel = 'Y';
                manualStore = 'Y';
                manualHC = 'Y';
                for (RebateSurvey__c rs: [select ColumnName__c, Answer__c
                        from RebateSurvey__c where RebateID__c = :rebID]) {
			            if (rs.ColumnName__c == 'WH_Fuel') { frmWHFuel = rs.Answer__c; }
			            if (rs.ColumnName__c == 'CW_Fuel') { frmCWFuel = rs.Answer__c; }
			            if (rs.ColumnName__c == 'HouseUnits') { frmHouseUnits = rs.Answer__c; }
			            if (rs.ColumnName__c == 'Residence') { frmPriVac = rs.Answer__c; }
			            if (rs.ColumnName__c == 'Building Type') { frmHouseType = rs.Answer__c; }
			            if (rs.ColumnName__c == 'Own_Rent') { frmOwnRent = rs.Answer__c; }
			            if (rs.ColumnName__c == 'Serial#') { frmSerialNum = rs.Answer__c; }
                }
        }
        
        public void clearErrors() {
                // don't clear field error levels ... need them to validate overrides by user.
                frmAcctNumMsg = '';
                frmAcctNumMsgStyle = 'display:none';
                frmAcctNumMsgRed = '';
                frmAcctNumMsgStyleRed = 'display:none';
                frmFirstNameMsg = '';
                frmFirstNameMsgStyle = 'display:none';
                frmLastNameMsg = '';
                frmLastNameMsgStyle = 'display:none';
                frmAcctAddress1Msg = '';
                frmAcctAddress1MsgStyle = 'display:none';
                frmAcctCityMsg = '';
                frmAcctCityMsgStyle = 'display:none';
                frmAcctStateMsg = '';
                frmAcctStateMsgStyle = 'display:none';
                frmAcctZipMsg = '';
                frmAcctZipMsgStyle = 'display:none';
                frmMailAddress1Msg = '';
                frmMailAddress1MsgStyle = 'display:none';
                frmMailCityMsg = '';
                frmMailCityMsgStyle = 'display:none';
                frmMailStateMsg = '';
                frmMailStateMsgStyle = 'display:none';
                frmMailZipMsg = '';
                frmMailZipMsgStyle = 'display:none';
                frmEmailMsg = '';
                frmEmailMsgStyle = 'display:none';
                frmEmailMsgRed = '';
                frmEmailMsgStyleRed = 'display:none';
                selBrandMsg = '';
                selBrandMsgStyle = 'display:none';
                selModelIDMsg = '';
                selModelIDMsgStyle = 'display:none';
                frmBrandMsg = '';
                frmBrandMsgStyle = 'display:none';
                frmModelMsg = '';
                frmModelMsgStyle = 'display:none';
                frmSerialNumMsg = '';
                frmSerialNumMsgStyle = 'display:none';
                selCityMsg = '';
                selCityMsgStyle = 'display:none';
                selStoreIDMsg = '';
                selStoreIDMsgStyle = 'display:none';
                frmStoreNameMsg = '';
                frmStoreNameMsgStyle = 'display:none';
                frmStoreAddress1Msg = '';
                frmStoreAddress1MsgStyle = 'display:none';
                frmStoreCityMsg = '';
                frmStoreCityMsgStyle = 'display:none';
                frmStoreStateMsg = '';
                frmStoreStateMsgStyle = 'display:none';
                frmStoreZipMsg = '';
                frmStoreZipMsgStyle = 'display:none';
                frmPaidAmtMsg = '';
                frmPaidAmtMsgStyle = 'display:none';
                frmPaidAmtMsgRed = '';
                frmPaidAmtMsgStyleRed = 'display:none';
                frmPurchDateMsg = '';
                frmPurchDateMsgStyle = 'display:none';
                frmHouseUnitsMsg = '';
                frmHouseUnitsMsgStyle = 'display:none';
                frmInstallDateMsg = '';
                frmInstallDateMsgStyle = 'display:none';
                frmExistModelMsg = '';
                frmExistModelMsgStyle = 'display:none';
                frmHaulawayCoMsg = '';
                frmHaulawayCoMsgStyle = 'display:none';
                frmHaulawayDateMsg = '';
                frmHaulawayDateMsgStyle = 'display:none';
                selHCIdMsg = '';
                selHCIdMsgStyle = 'display:none';       
                        
                foundError = false;
                frmErrLevel = 0;
        }
        
        public void clearErrorLevels() {
                frmAcctNumErrLevel = 0;
                frmFirstNameErrLevel = 0;
                frmLastNameErrLevel = 0;
                frmAcctAddress1ErrLevel = 0;
                frmAcctCityErrLevel = 0;
                frmAcctStateErrLevel = 0;
                frmAcctZipErrLevel = 0;
                frmMailAddress1ErrLevel = 0;
                frmMailCityErrLevel = 0;
                frmMailStateErrLevel = 0;
                frmMailZipErrLevel = 0;
                frmEmailErrLevel = 0;
                selBrandErrLevel = 0;
                selModelIDErrLevel = 0;
                frmBrandErrLevel = 0;
                frmModelErrLevel = 0;
				frmSerialNumErrLevel = 0;
                selCityErrLevel = 0;
                selStoreIDErrLevel = 0;
                frmStoreNameErrLevel = 0;
                frmStoreAddress1ErrLevel = 0;
                frmStoreCityErrLevel = 0;
                frmStoreStateErrLevel = 0;
                frmStoreZipErrLevel = 0;
                frmPaidAmtErrLevel = 0;
                frmPurchDateErrLevel = 0;
                selHCIdErrLevel = 0;
        }
        
        public void testInit() {
		        frmAcctNum = '1237894560';
		        frmFirstName = 'Thomas';
		        frmLastName = 'Ryan';
		        frmAcctAddress1 = '123 Main Street';
		        frmAcctAddress2 = '';
		        frmAcctCity = 'Westborough';
		        frmAcctState = 'MA';
		        frmAcctZip = '01581';
		        frmHomePhone = '508-555-1212';
		        frmWorkPhone = '';
		        frmMailAddress1 = '555 Washington Street';
		        frmMailAddress2 = '';
		        frmMailCity = 'Westborough';
		        frmMailState = 'MA';
		        frmMailZip = '01581';
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
		        selCity = 'Braintree';
		        makeStoreList();
		        frmStoreName = 'Sears';
		        frmStoreAddress1 = 'Natick Mall';
		        frmStoreAddress2 = '';
		        frmStoreCity = 'Natick';
		        frmStoreState = 'MA';
		        frmStoreZip = '01760';
		        frmPaidAmt = '500';
		        frmPurchDate = '3/12/2012';
        }
        
        public List<selectOption> getBrandList() {
                List<SelectOption> options = new List<SelectOption>();
                options.add(new SelectOption('','Please Select ...'));
                for (Manufacturer__c m: [select ID, Manufacturer__c from Manufacturer__c 
                        where ID in (select ManufacturerID__c from FormXManufacturer__c where FormID__c = :thisFormID) order by Manufacturer__c] ) {
                        options.add(new SelectOption(m.Manufacturer__c, m.Manufacturer__c));
                }
                return options; 
        }
        
        public List<selectOption> getModelList() {
                List<SelectOption> options = new List<SelectOption>();
                options.add(new SelectOption('','Please Select ...'));
                if (selBrand != '' && selBrand != null) {
                        for (Model__c m: [select ID, Manufacturer__c, ModelNumber__c from Model__c where Manufacturer__c = :selBrand and
                                ID in (select ModelID__c from FormXModel__c where FormID__c = :thisFormID) order by ModelNumber__c] ) {
                                options.add(new SelectOption(m.ID,m.ModelNumber__c));
                        }
                }
                return options; 
        }
        
        public List<selectOption> getStateList() {
                List<SelectOption> options = new List<SelectOption>();
                options.add(new SelectOption('','Please Select ...'));
                for (States__c s: [select ID, State__c, StateName__c from States__c order by StateName__c] ) {
                        options.add(new SelectOption(s.State__c, s.StateName__c));
                }
                return options; 
        }
        
        public List<selectOption> getHCList() {
                List<SelectOption> options = new List<SelectOption>();
                options.add(new SelectOption('','Please Select ...'));
                for (FormList__c f: [select ID, InternalValue__c, DisplayValue__c from FormList__c 
                        where formID__c = :thisFormID and ListName__c = 'Haulaway Company'
                        order by DisplayValue__c] ) {
                        options.add(new SelectOption(f.InternalValue__c, f.DisplayValue__c));
                }
                return options;
        }
        
        public void makeStoreList() {
                storeList.clear();
                Integer storeCount = 0;
                if (selState != null && selState != '' && selCity != null && selCity != '') {
                        storeList.add(new SelectOption('','Please Select ...'));
                        for (Store__c s: [select ID, StoreName__c, StoreAddress1__c, StoreCity__c, StoreState__c, StoreZipcode__c from Store__c 
                                where StoreCity__c = :selCity and StoreState__c = :selState order by StoreName__c] ) {
                                storeList.add(new SelectOption(s.ID,s.StoreName__c+', '+s.StoreAddress1__c+', '+s.StoreCity__c+', '+s.StoreState__c+', '+s.StoreZipcode__c));
                                storeCount += 1;
                        }
                        if (storeCount == 0) { // warning if none found
                                selCityMsg = 'Warning: There are no stores for this city/state.  City might be misspelled.';
                                selCityMsgStyle = 'display:inline';
                        } else {
                                selCityMsg = '';
                                selCityMsgStyle = 'display:none';
                        }
                } else {
                        storeList.add(new SelectOption('','Please enter State and City above ...'));
                }
        }
        
        public List<selectOption> getStoreList() {
                return storeList;       
        }
        
        public void alertErrors(Integer errLevel) {
                if (errLevel > frmErrLevel) frmErrLevel = errLevel; // use maximum
                if (frmErrLevel == 5) { // should no longer occur (prevent edits, resubmit)
                        frmLoadMessage = messageTextDupe;
                        frmButtonLabel = buttonTextOk;
                }
                if (frmErrLevel == 10) { 
                        frmLoadMessage = messageTextWarn;
                        frmButtonLabel = buttonTextWarn;
                }
                if (frmErrLevel == 20) { 
                        frmLoadMessage = messageTextError;
                        frmButtonLabel = buttonTextError;
                }
                foundError = true;
        }

        public PageReference actionCheckMe() {
                if (debugging) system.debug('EFILOG: Entered CheckMe');
                getSessionData(); // detect reload or back button
                if (saveRebateNum != '' && saveRebateNum != null) {
                        frmRebateNum = saveRebateNum;
                        frmMailZip = saveMailZip;
                        showRebate();
                        frmButtonLabel = buttonTextReload;
                        frmLoadMessage = messageTextReload;
                        return null;
                }
                clearErrors(); // reset error variables;
                frmButtonLabel = buttonTextOk; // default before error found
                frmLoadMessage = '';
                if (frmRebateNum != '' && frmRebateNum != null) {
                        alertErrors(5);
                        return null;
                }
                // ensure appropriate forms for various versions of the account number
                if (frmAcctNum == null) frmAcctNum = '';
                if (manualModel == 'Y') { // process manual vs. selected Model
                        selModelId = null; // make sure this is null
                } else {
                        // if (selModelID == '') { // error on test? need to diagnose
                        //      alertErrors(20);
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
                        //      alertErrors(20);
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
                /* not needed for SCL
                if (mailSame == 'Y') { // populate from account address
                        frmMailAddress1 = frmAcctAddress1;
                        frmMailAddress2 = frmAcctAddress2;
                        frmMailCity = frmAcctCity;
                        frmMailState = frmAcctState;
                        frmMailZip = frmAcctZip;
                }
                */
                // initial validation
                // account number: warn if not 10 digits, not match pcust 
                if (frmAcctNum == null) frmAcctNum = '';
                if (frmAcctNumErrLevel > 0) { // had an error previously
                        if (frmAcctNum != frmAcctNumErrValue) { // value was changed
                                frmAcctNumErrLevel = 0; // ignore prior, validate again
                        }
                }
                if (frmAcctNumErrLevel == 0) { // no need to validate if warned and unchanged
                        if (frmAcctNum.length() <> 10) {
                                if (frmAcctNum.length() == 0) {
                                        frmAcctNumMsg = 'Warning: Account numbers should be provided.';
                                } else {
                                        frmAcctNumMsg = 'Warning: Account numbers are 10 digits.';
                                }
                                frmAcctNumMsgStyle = 'display:inline';
                                frmAcctNumErrValue = frmAcctNum; // save for later compare
                                frmAcctNumErrLevel = 10;
                                alertErrors(10);                        
                        } else {
                                String ua = '';
                                for (UtilityAccount__c u: [select ID, AccountNumber__c, ClientCode__c, ServiceZipCode__c from UtilityAccount__c 
                                        where AccountNumber__c = :frmAcctNum and ClientCode__c = 'SCL' and ServiceZipCode__c = :frmAcctZip] ) {
                                        ua = u.AccountNumber__c;
                                }
                                if (ua == '') {
                                        frmAcctNumMsg = 'Warning: Account number doesn\'t match our records.';
                                        frmAcctNumMsgStyle = 'display:inline';
                                        frmAcctNumErrValue = frmAcctNum; // save for later compare
                                        frmAcctNumErrLevel = 10;
                                        alertErrors(10);                        
                                }
                        }
                }
                /* not needed for SCL
                // first name: warn if blank
                if (frmFirstNameErrLevel == 10) { // had a warning previously
                        if (frmFirstName != frmFirstNameErrValue) { // value was changed
                                frmFirstNameErrLevel = 0; // ignore prior, validate again
                        }
                }
                if (frmFirstNameErrLevel == 0) {
                        if (frmFirstName != null && frmFirstName.length() == 0) {
                                frmFirstNameMsg = 'Warning: Field is blank.';
                                frmFirstNameMsgStyle = 'display:inline';
                                frmFirstNameErrValue = frmFirstName;
                                frmFirstNameErrLevel = 10;
                                alertErrors(10);
                        }                       
                }
                // last name: may not be blank
                if (frmLastName != null && frmLastName.length() == 0) {
                        frmLastNameMsg = 'Error: Last Name must be provided.';
                        frmLastNameMsgStyle = 'display:inline';
                        frmLastNameErrValue = frmLastName;
                        frmLastNameErrLevel = 20;
                        alertErrors(20);                        
                } else {
                        frmLastNameErrLevel = 0;
                }
                // AcctAddress1: warn if blank
                if (frmAcctAddress1ErrLevel == 10) { // had a warning previously
                        if (frmAcctAddress1 != frmAcctAddress1ErrValue) { // value was changed
                                frmAcctAddress1ErrLevel = 0; // ignore prior, validate again
                        }
                }
                if (frmAcctAddress1ErrLevel == 0) {
                        if (frmAcctAddress1 != null && frmAcctAddress1.length() == 0) {
                                frmAcctAddress1Msg = 'Warning: Field is blank.';
                                frmAcctAddress1MsgStyle = 'display:inline';
                                frmAcctAddress1ErrValue = frmAcctAddress1;
                                frmAcctAddress1ErrLevel = 10;
                                alertErrors(10);
                        }                       
                }
                // AcctCity: warn if blank
                if (frmAcctCityErrLevel == 10) { // had a warning previously
                        if (frmAcctCity != frmAcctCityErrValue) { // value was changed
                                frmAcctCityErrLevel = 0; // ignore prior, validate again
                        }
                }
                if (frmAcctCityErrLevel == 0) {
                        if (frmAcctCity != null && frmAcctCity.length() == 0) {
                                frmAcctCityMsg = 'Warning: Field is blank.';
                                frmAcctCityMsgStyle = 'display:inline';
                                frmAcctCityErrValue = frmAcctCity;
                                frmAcctCityErrLevel = 10;
                                alertErrors(10);
                        }                       
                }
                // AcctAddress1: warn if blank
                if (frmAcctStateErrLevel == 10) { // had a warning previously
                        if (frmAcctState != frmAcctStateErrValue) { // value was changed
                                frmAcctStateErrLevel = 0; // ignore prior, validate again
                        }
                }
                if (frmAcctStateErrLevel == 0) {
                        if (frmAcctState != null && frmAcctState.length() == 0) {
                                frmAcctStateMsg = 'Warning: Field is blank.';
                                frmAcctStateMsgStyle = 'display:inline';
                                frmAcctStateErrValue = frmAcctState;
                                frmAcctStateErrLevel = 10;
                                alertErrors(10);
                        }                       
                }
                // AcctAddress1: warn if blank
                if (frmAcctZipErrLevel == 10) { // had a warning previously
                        if (frmAcctZip != frmAcctZipErrValue) { // value was changed
                                frmAcctZipErrLevel = 0; // ignore prior, validate again
                        }
                }
                if (frmAcctZipErrLevel == 0) {
                        if (frmAcctZip != null && frmAcctZip.length() == 0) {
                                frmAcctZipMsg = 'Warning: Field is blank.';
                                frmAcctZipMsgStyle = 'display:inline';
                                frmAcctZipErrValue = frmAcctZip;
                                frmAcctZipErrLevel = 10;
                                alertErrors(10);
                        }                       
                }
                */
                /* not needed for SCL
                // validate mailing address only if visible (otherwise validated as account)
                if (mailSame == 'N') {
                        // MailAddress1: warn if blank
                        if (frmMailAddress1ErrLevel == 10) { // had a warning previously
                                if (frmMailAddress1 != frmMailAddress1ErrValue) { // value was changed
                                        frmMailAddress1ErrLevel = 0; // ignore prior, validate again
                                }
                        }
                        if (frmMailAddress1ErrLevel == 0) {
                                if (frmMailAddress1 != null && frmMailAddress1.length() == 0) {
                                        frmMailAddress1Msg = 'Warning: Field is blank.';
                                        frmMailAddress1MsgStyle = 'display:inline';
                                        frmMailAddress1ErrValue = frmMailAddress1;
                                        frmMailAddress1ErrLevel = 10;
                                        alertErrors(10);
                                }                       
                        }
                        // MailCity: warn if blank
                        if (frmMailCityErrLevel == 10) { // had a warning previously
                                if (frmMailCity != frmMailCityErrValue) { // value was changed
                                        frmMailCityErrLevel = 0; // ignore prior, validate again
                                }
                        }
                        if (frmMailCityErrLevel == 0) {
                                if (frmMailCity != null && frmMailCity.length() == 0) {
                                        frmMailCityMsg = 'Warning: Field is blank.';
                                        frmMailCityMsgStyle = 'display:inline';
                                        frmMailCityErrValue = frmMailCity;
                                        frmMailCityErrLevel = 10;
                                        alertErrors(10);
                                }                       
                        }
                        // MailState: warn if blank
                        if (frmMailStateErrLevel == 10) { // had a warning previously
                                if (frmMailState != frmMailStateErrValue) { // value was changed
                                        frmMailStateErrLevel = 0; // ignore prior, validate again
                                }
                        }
                        if (frmMailStateErrLevel == 0) {
                                if (frmMailState != null && frmMailState.length() == 0) {
                                        frmMailStateMsg = 'Warning: Field is blank.';
                                        frmMailStateMsgStyle = 'display:inline';
                                        frmMailStateErrValue = frmMailState;
                                        frmMailStateErrLevel = 10;
                                        alertErrors(10);
                                }                       
                        }
                        // MailZip: warn if blank
                        if (frmMailZipErrLevel == 10) { // had a warning previously
                                if (frmMailZip != frmMailZipErrValue) { // value was changed
                                        frmMailZipErrLevel = 0; // ignore prior, validate again
                                }
                        }
                        if (frmMailZipErrLevel == 0) {
                                if (frmMailZip != null && frmMailZip.length() == 0) {
                                        frmMailZipMsg = 'Warning: Field is blank.';
                                        frmMailZipMsgStyle = 'display:inline';
                                        frmMailZipErrValue = frmMailZip;
                                        frmMailZipErrLevel = 10;
                                        alertErrors(10);
                                }                       
                        }
                }
                */
                // always validate Email Address (hard error)
                if (!Utils.isValidEmail(frmEmail)) {
                        frmEmailMsgRed = 'Invalid email address.';
                        frmEmailMsgStyleRed = 'display:inline';
                        frmEmailErrValue = frmEmail;
                        frmEmailErrLevel = 20;
                        alertErrors(20);                        
                } else {
                        frmEmailErrLevel = 0;           
                }
                if (frmHouseUnits != null && frmHouseUnits != '') {
                        try {
                                frmHouseUnitsDecimal = Decimal.valueOf(frmHouseUnits);
                                if (frmHouseUnitsDecimal.scale() > 0) {
                                        frmHouseUnitsMsg = 'Error: No decimals allowed';
                                        frmHouseUnitsMsgStyle = 'display:inline';
                                        frmHouseUnitsErrValue = frmHouseUnits;
                                        frmHouseUnitsErrLevel = 20;
                                        alertErrors(20);                        
                                }
                        } catch (Exception e) {
                                frmHouseUnitsMsg = 'Error: Invalid amount.';
                                frmHouseUnitsMsgStyle = 'display:inline';
                                frmHouseUnitsErrValue = frmHouseUnits;
                                frmHouseUnitsErrLevel = 20;
                                alertErrors(20);                        
                        }
                }
                if (manualModel == 'Y') {
                        // validate manual model fields 
                        // Brand: warn if blank
                        if (frmBrandErrLevel == 10) { // had a warning previously
                                if (frmBrand != frmBrandErrValue) { // value was changed
                                        frmBrandErrLevel = 0; // ignore prior, validate again
                                }
                        }
                        if (frmBrandErrLevel == 0) {
                                if (frmBrand != null && frmBrand.length() == 0) {
                                        frmBrandMsg = 'Warning: Field is blank.';
                                        frmBrandMsgStyle = 'display:inline';
                                        frmBrandErrValue = frmBrand;
                                        frmBrandErrLevel = 10;
                                        alertErrors(10);
                                }                       
                        }
                        // Model: warn if blank
                        if (frmModelErrLevel == 10) { // had a warning previously
                                if (frmModel != frmModelErrValue) { // value was changed
                                        frmModelErrLevel = 0; // ignore prior, validate again
                                }
                        }
                        if (frmModelErrLevel == 0) {
                                if (frmModel != null && frmModel.length() == 0) {
                                        frmModelMsg = 'Warning: Field is blank.';
                                        frmModelMsgStyle = 'display:inline';
                                        frmModelErrValue = frmModel;
                                        frmModelErrLevel = 10;
                                        alertErrors(10);
                                }               
                        }
                } else {
                        // validate model selection fields
                        // Brand: warn if blank
                        if (selBrandErrLevel == 10) { // had a warning previously
                                if (selBrand != selBrandErrValue) { // value was changed
                                        selBrandErrLevel = 0; // ignore prior, validate again
                                }
                        }
                        if (selBrandErrLevel == 0) {
                                if (selBrand == null) {
                                        selBrandMsg = 'Warning: Please select.';
                                        selBrandMsgStyle = 'display:inline';
                                        selBrandErrValue = selBrand;
                                        selBrandErrLevel = 10;
                                        alertErrors(10);
                                }                       
                        }
                        // Model: warn if blank
                        if (selModelIDErrLevel == 10) { // had a warning previously
                                if (selModelID != selModelIDErrValue) { // value was changed
                                        selModelIDErrLevel = 0; // ignore prior, validate again
                                }
                        }
                        if (selModelIDErrLevel == 0) {
                                // if (selModelID != null && selModelID.length() == 0) {
                                if (selModelID == null) {
                                        selModelIDMsg = 'Warning: Please select.';
                                        selModelIDMsgStyle = 'display:inline';
                                        selModelIDErrValue = selModel;
                                        selModelIDErrLevel = 10;
                                        alertErrors(10);
                                }                       
                        }
                }
                // SerialNum: warn if blank
                if (frmSerialNumErrLevel == 10) { // had a warning previously
                        if (frmSerialNum != frmSerialNumErrValue) { // value was changed
                                frmSerialNumErrLevel = 0; // ignore prior, validate again
                        }
                }
                if (frmSerialNumErrLevel == 0) {
		                if (frmSerialNum == null) frmSerialNum = '';
		                if (frmSerialNum.length() == 0) {
                                frmSerialNumMsg = 'Warning: Field is blank.';
                                frmSerialNumMsgStyle = 'display:inline';
                                frmSerialNumErrValue = frmSerialNum;
                                frmSerialNumErrLevel = 10;
                                alertErrors(10);
                        }                       
                }
                if (manualStore == 'Y') {
                        // validate manual store fields
                        // StoreName: warn if blank
                        if (frmStoreNameErrLevel == 10) { // had a warning previously
                                if (frmStoreName != frmStoreNameErrValue) { // value was changed
                                        frmStoreNameErrLevel = 0; // ignore prior, validate again
                                }
                        }
                        if (frmStoreNameErrLevel == 0) {
                                if (frmStoreName != null && frmStoreName.length() == 0) {
                                        frmStoreNameMsg = 'Warning: Field is blank.';
                                        frmStoreNameMsgStyle = 'display:inline';
                                        frmStoreNameErrValue = frmStoreName;
                                        frmStoreNameErrLevel = 10;
                                        alertErrors(10);
                                }                       
                        }
                        // StoreAddress1: warn if blank
                        if (frmStoreAddress1ErrLevel == 10) { // had a warning previously
                                if (frmStoreAddress1 != frmStoreAddress1ErrValue) { // value was changed
                                        frmStoreAddress1ErrLevel = 0; // ignore prior, validate again
                                }
                        }
                        if (frmStoreAddress1ErrLevel == 0) {
                                if (frmStoreAddress1 != null && frmStoreAddress1.length() == 0) {
                                        frmStoreAddress1Msg = 'Warning: Field is blank.';
                                        frmStoreAddress1MsgStyle = 'display:inline';
                                        frmStoreAddress1ErrValue = frmStoreAddress1;
                                        frmStoreAddress1ErrLevel = 10;
                                        alertErrors(10);
                                }                       
                        }
                        // StoreCity: warn if blank
                        if (frmStoreCityErrLevel == 10) { // had a warning previously
                                if (frmStoreCity != frmStoreCityErrValue) { // value was changed
                                        frmStoreCityErrLevel = 0; // ignore prior, validate again
                                }
                        }
                        if (frmStoreCityErrLevel == 0) {
                                if (frmStoreCity != null && frmStoreCity.length() == 0) {
                                        frmStoreCityMsg = 'Warning: Field is blank.';
                                        frmStoreCityMsgStyle = 'display:inline';
                                        frmStoreCityErrValue = frmStoreCity;
                                        frmStoreCityErrLevel = 10;
                                        alertErrors(10);
                                }                       
                        }
                        // StoreState: warn if blank
                        if (frmStoreStateErrLevel == 10) { // had a warning previously
                                if (frmStoreState != frmStoreStateErrValue) { // value was changed
                                        frmStoreStateErrLevel = 0; // ignore prior, validate again
                                }
                        }
                        if (frmStoreStateErrLevel == 0) {
                                if (frmStoreState != null && frmStoreState.length() == 0) {
                                        frmStoreStateMsg = 'Warning: Field is blank.';
                                        frmStoreStateMsgStyle = 'display:inline';
                                        frmStoreStateErrValue = frmStoreState;
                                        frmStoreStateErrLevel = 10;
                                        alertErrors(10);
                                }                       
                        }
                        // StoreZip: warn if blank
                        if (frmStoreZipErrLevel == 10) { // had a warning previously
                                if (frmStoreZip != frmStoreZipErrValue) { // value was changed
                                        frmStoreZipErrLevel = 0; // ignore prior, validate again
                                }
                        }
                        if (frmStoreZipErrLevel == 0) {
                                if (frmStoreZip != null && frmStoreZip.length() == 0) {
                                        frmStoreZipMsg = 'Warning: Field is blank.';
                                        frmStoreZipMsgStyle = 'display:inline';
                                        frmStoreZipErrValue = frmStoreZip;
                                        frmStoreZipErrLevel = 10;
                                        alertErrors(10);
                                }                       
                        }
                } else {
                        // validate store selection fields
                        // Filter StoreCity: warn if blank
                        if (selCityErrLevel == 10) { // had a warning previously
                                if (selCity != selCityErrValue) { // value was changed
                                        selCityErrLevel = 0; // ignore prior, validate again
                                }
                        }
                        if (selCityErrLevel == 0) {
                                if (selCity != null && selCity.length() == 0) {
                                        selCityMsg = 'Warning: Field is blank.';
                                        selCityMsgStyle = 'display:inline';
                                        selCityErrValue = selCity;
                                        selCityErrLevel = 10;
                                        alertErrors(10);
                                }                       
                        }
                        // Select Store: warn if blank
                        if (selStoreIDErrLevel == 10) { // had a warning previously
                                if (selStoreID != selStoreIDErrValue) { // value was changed
                                        selStoreIDErrLevel = 0; // ignore prior, validate again
                                }
                        }
                        if (selStoreIDErrLevel == 0) {
                                if (selStoreID == null) {
                                        selStoreIDMsg = 'Warning: Please select.';
                                        selStoreIDMsgStyle = 'display:inline';
                                        selStoreIDErrValue = selStoreID;
                                        selStoreIDErrLevel = 10;
                                        alertErrors(10);
                                }                       
                        }
                }
                // always validate Paid Amount (hard error if invalid)
                // but first warn if blank
                if (frmPaidAmtErrLevel == 10) { // had a warning previously
                        if (frmPaidAmt != frmPaidAmtErrValue) { // value was changed
                                frmPaidAmtErrLevel = 0; // ignore prior, validate again
                        }
                }
                if (frmPaidAmtErrLevel == 0) {
                        if (frmPaidAmt != null && frmPaidAmt.length() == 0) {
                                frmPaidAmtMsg = 'Warning: Field is blank.';
                                frmPaidAmtMsgStyle = 'display:inline';
                                frmPaidAmtErrValue = frmPaidAmt;
                                frmPaidAmtErrLevel = 10;
                                alertErrors(10);
                        }                       
                }
                if (frmPaidAmt == null || frmPaidAmt.length() > 0) {
                        try {
                                frmPaidAmtDecimal = Decimal.valueOf(frmPaidAmt);
                                if (frmPaidAmtDecimal.scale() > 2) {
                                        frmPaidAmtMsgRed = 'Error: Too many digits after decimal.';
                                        frmPaidAmtMsgStyleRed = 'display:inline';
                                        frmPaidAmtErrValue = frmPaidAmt;
                                        frmPaidAmtErrLevel = 20;
                                        alertErrors(20);                        
                                }
                        } catch (Exception e) {
                                frmPaidAmtMsgRed = 'Error: Invalid amount.';
                                frmPaidAmtMsgStyleRed = 'display:inline';
                                frmPaidAmtErrValue = frmPaidAmt;
                                frmPaidAmtErrLevel = 20;
                                alertErrors(20);                        
                        }
                }
                // always validate Purchase Date (hard error)
                try {
                        if (frmPurchDate == null || frmPurchDate == '') {
                            frmPurchDateMsg = 'Error: Purchase date must be provided.';
                            frmPurchDateMsgStyle = 'display:inline';
                            frmPurchDateErrValue = frmPurchDate;
                            frmPurchDateErrLevel = 20;
                            alertErrors(20);                        
                        } else {
	                        Date tmpDate = Date.parse(frmPurchDate);
	                        if (tmpDate < Date.parse('1/1/2012') || tmpDate > Date.parse('12/31/2012')) {
	                                frmPurchDateMsg = 'Error: Must be between 1/1/2012 and 12/31/2012.';
	                                frmPurchDateMsgStyle = 'display:inline';
	                                frmPurchDateErrValue = frmPurchDate;
	                                frmPurchDateErrLevel = 20;
	                                alertErrors(20);                        
	                        } else if (tmpDate > Date.today()) {
	                                frmPurchDateMsg = 'Error: Date may not be in the future.';
	                                frmPurchDateMsgStyle = 'display:inline';
	                                frmPurchDateErrValue = frmPurchDate;
	                                frmPurchDateErrLevel = 20;
	                                alertErrors(20);                        
	                        } else {
	                                frmPurchDateErrLevel = 0; // only executes if no exception 
	                        }
                        }
                } catch (Exception e) {
                        frmPurchDateMsg = 'Error: Invalid date.';
                        frmPurchDateMsgStyle = 'display:inline';
                        frmPurchDateErrValue = frmPurchDate;
                        frmPurchDateErrLevel = 20;
                        alertErrors(20);                        
                } 
                if (foundError) return null;
                // get measure ID and measure code/value
                // a model was provided (either selected or entered)
                // so check to see if one of the $100 rebate models
                if (frmModel == null) frmModel = '';
                ID measureID = null;
                for (Measure__c m: [select ID, MeasureCode__c from Measure__c 
                        where FormID__c = :thisFormID and MeasureCode__c = :thisMeasureCode] ) {
                        measureID = m.ID;
                }
                // then write the necessary records
                // Customer
                Contact rcont = new Contact (
                        FirstName = frmFirstName,
                        LastName = (frmLastName == '') ? '.' : frmLastName, // since blank not permitted
                        // strip out 'Line #' help text if in address fields
                        ServiceAddress1__c = (frmAcctAddress1 == 'Line 1') ? '' : frmAcctAddress1,
                        ServiceAddress2__c = (frmAcctAddress2 == 'Line 2') ? '' : frmAcctAddress2,
                        ServiceCity__c = frmAcctCity,
                        ServiceState__c = frmAcctState,
                        ServiceZipcode__c = frmAcctZip,
                        HomePhone = frmHomePhone,  // placing "daytime phone" here, as discussed
                  //      WorkPhone__c = frmWorkPhone,  // not used on SCL form
                        Email = frmEmail,
                  //      ReceiveEmail__c = frmRecvEmail,  // not used on SCL form
                        AccountNumber__c = frmAcctNum,
                        AccountID = thisAccountID,
                        OwnerID = frmOwnerID
                );
                // not needed since added above ...
                // if (frmLastName == '') rcont.LastName = '.'; // since blank not permitted
                if (writeRecs) insert rcont;
                // Rebate
                Rebate__c rreb = new Rebate__c(
                        Name = thisFormCode + ' | ' + frmAcctNum,
                        ContactID__c = rcont.ID,
                        FormID__c = thisFormID,
                        FormCode__c = thisFormCode,
                        UtilityCode__c = thisUtilityCode,  
                        MailingFirstName__c = frmFirstName,
                        MailingLastName__c = frmLastName,
                        MailingAddress1__c = (frmMailAddress1 == 'Line 1') ? '' : frmMailAddress1,
                        MailingAddress2__c = (frmMailAddress2 == 'Line 2') ? '' : frmMailAddress2,
                        MailingCity__c = frmMailCity,
                        MailingState__c = frmMailState,
                        MailingZipcode__c = frmMailZip,
                        StoreID__c = selStoreID,
                        StoreName__c = frmStoreName,
                        StoreAddress1__c = (frmStoreAddress1 == 'Line 1') ? '' : frmStoreAddress1,
                        StoreAddress2__c = (frmStoreAddress2 == 'Line 2') ? '' : frmStoreAddress2,
                        StoreCity__c = frmStoreCity,
                        StoreState__c = frmStoreState,
                        StoreZipcode__c = frmStoreZip,
                        PurchaseDate__c = Date.parse(frmPurchDate),
                        RebateStatus__c = initialStatus,
                        OwnerID = frmOwnerID
                );
                if ((rreb.MailingAddress1__c == '') &&
                        (rreb.MailingAddress2__c == '') &&
                        (rreb.MailingCity__c == '') &&
                        (rreb.MailingState__c == '') &&
                        (rreb.MailingZipcode__c == '')) {
                        rreb.MailingAddress1__c = rcont.ServiceAddress1__c;
                        rreb.MailingAddress2__c = rcont.ServiceAddress2__c;
                        rreb.MailingCity__c = rcont.ServiceCity__c;
                        rreb.MailingState__c = rcont.ServiceState__c;
                        rreb.MailingZipcode__c = rcont.ServiceZipcode__c;
                }
                if (writeRecs) insert rreb;
                // Retrieve fields from rebate record
                for (Rebate__c r: [select ID, RebateNumber__c from Rebate__c where ID = :rreb.ID] ) {
                        frmRebateNum = r.RebateNumber__c;
                        addSessionRecord(saveSessionID, 'RebateNumber', frmRebateNum);
                        addSessionRecord(saveSessionID, 'MailZipcode', frmMailZip);
                }
                // RebateDetail
                RebateDetail__c rdet = new RebateDetail__c (
                        Name = frmBrand + ' ' + frmModel,
                        RebateID__c = rreb.ID,
                        Quantity__c = 1,
                        Manufacturer__c = frmBrand,
                        ModelNumber__c = frmModel,
                        ModelID__c = selModelID,
                        MeasureID__c = measureID,
                        MeasureCode__c = thisMeasureCode,
                //        AmountTendered__c = frmPaidAmtDecimal,  // not used on SCL form
                        MeasureRebateAmount__c = thisMeasureAmount
                );
                if (frmPaidAmt.length() > 0) {
                        rdet.AmountTendered__c = decimal.valueOf(frmPaidAmt);
                }
                if (writeRecs) insert rdet;
                // RebateSurvey
				addSurveyRecord(rreb.ID, 'WH_Fuel', frmWHFuel, 'String');
				addSurveyRecord(rreb.ID, 'CW_Fuel', frmCWFuel, 'String');
				addSurveyRecord(rreb.ID, 'BuildingType',frmHouseType, 'String');
				addSurveyRecord(rreb.ID, 'HouseUnits', frmHouseUnits, 'Number');
				addSurveyRecord(rreb.ID, 'Residence', frmPriVac, 'String');
				addSurveyRecord(rreb.ID, 'Own_Rent', frmOwnRent, 'String');
                addSurveyRecord(rreb.ID, 'Serial#', frmSerialNum, 'String');
                frmLoadMessage = messageTextOk;
                disableDE = true;
                frmReadOnly = 'yes';
                // send email, unless test value
                if (frmEmail != null && frmEmail != 'test@test.test' && frmEmail != '') {
                        RebateEmailMgr remgr = New RebateEmailMgr();
                        remgr.sendEmail(rreb.id);
                }
                //
                return null;
        }
        
        public void addSurveyRecord(ID rebID, String survName, String survValue, String survType) {
                if (survValue == null) return;
                if (survValue.length() == 0) return;
                // Retrieve question ID by name
                ID sqID = null;
                for (SurveyQuestions__c sq : [select ID, ColumnName__c from SurveyQuestions__c where FormID__c = :thisFormID and ColumnName__c = :survName] ) {
                        sqID = sq.ID;
                }
                // validate for data type here, if desired
                // then write RebateSurvey record
                RebateSurvey__c rsurv = new RebateSurvey__c (
                        Name = thisFormCode + ' ' + survName,
                        RebateID__c = rebID,
                        SurveyQuestionID__c = sqID,
                        Answer__c = survValue
                );      
                if (writeRecs) insert rsurv;                    
        }
        
        public void addSessionRecord(String sessID, String fldName, String fldValue) {
                Boolean foundRec = false;
                // create a record if it doesn't exist, replace value if it does exist
                for (SessionData__c esd : [select SessionID__c, FieldName__c, FieldValue__c 
                        from SessionData__c 
                        where SessionID__c = :sessID and FieldName__c = :fldName]) {
                        esd.FieldValue__c = fldValue;
                        update esd;
                        foundRec = true;
                }
                if (!foundRec) {
                        SessionData__c sd = new SessionData__c (
                                SessionID__c = saveSessionID,
                                FieldName__c = fldName,
                                FieldValue__c = fldValue
                        );
                        insert sd;
                }
        }
        
        public void getSessionData() {
                saveRebateNum = ''; // initialize
                saveMailZip = '';
                for (SessionData__c esd : [select SessionID__c, FieldName__c, FieldValue__c
                        from SessionData__c
                        where SessionID__c = :saveSessionID]) {
                        if (esd.FieldName__c == 'RebateNumber') saveRebateNum = esd.FieldValue__c;
                        if (esd.FieldName__c == 'MailZipcode') saveMailZip = esd.FieldValue__c; 
                }
        }
        @isTest(SeeAllData=True)
        public static void test(){
                Test.startTest();
                PageReference pageRef = Page.FormSGE2012RFv2;
                Test.setCurrentPage(pageRef);
                FormSGE2012RFv2 contr = new FormSGE2012RFv2();
                contr.frmErrLevel = 0;
                contr.alertErrors(5);
                contr.alertErrors(10);
                contr.alertErrors(20);
                
                //-- CEV::Added to pass validation (expanded by DLK)
                contr.getBrandList();
                contr.selBrand = 'Kenmore';
                contr.getModelList();
                contr.getStateList();
                contr.selState = null;
                contr.selCity = null;
                contr.getStoreList();
                contr.selState = 'NY';
                contr.selCity = 'Ridgewood';
                contr.getStoreList();
                contr.getHCList();
                contr.mailSame = 'N';
                contr.manualModel = 'N';
                contr.manualStore = 'N';
                contr.actionCheckMe();
                contr.mailSame = 'Y';
                contr.manualModel = 'Y';
                contr.manualStore = 'Y';
                contr.frmAcctNum = '123123';
                contr.frmLastName = '';
                contr.frmPurchDate = 'ABCD';
                contr.actionCheckMe();
                contr.frmPurchDate = '1/1/2012';
                contr.frmLastName = 'TEST';
                //-- END
                
                contr.testInit(); // moved lower, so trigger warning code for blanks above
                contr.frmAcctNum = '12312312345';
                contr.actionCheckMe();
                
                //-- CEV::Added to pass validation
                contr.actionCheckMe();
                //-- END

                //-- DLK::Added test for view option
                contr.showRebate();
        
                // system.assertEquals(contr.frmLoadMessage, '');
                Test.stopTest();
        }
}