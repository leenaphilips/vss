public class FormSGE2012HE extends FormEFIStandardv3 {
	
	// declare any new variables here 
    public List<selectOption> radioYesNo {get; set; }
    public List<selectOption> dropFuelType {get; set; }
	
	public FormSGE2012HE() {
		// additional code above the call to super() is not permitted
		// instead, add code to initializeConstructor() below, called at the start of the super constructor
		super();
		// can put additional constructor code here, if needed
		radioYesNo = makeFormList('Yes/No', 'radio');
		dropFuelType = makeFormList('Fuel Type', 'dropdown');
	}

	public override void initializeConstructor () {
		debugging = false;  // write to log
		writeRecs = true; // can disable record writing, if desired, for testing
		testMode = true; // populate form w/test values
		showIcons = false; // show error icons always		
		pCustCheck = 'none'; // check account number in PCust (requires Zip code) = 'hard', 'soft', 'none'
		// Create detail objects for each measure
		details.put('FRN', new DetailInfo('FRN','both'));
		details.put('FRNECM', new DetailInfo('FRNECM','both'));
		details.put('BOILHW', new DetailInfo('BOILHW','both'));
		details.put('BOILST', new DetailInfo('BOILST','both'));
		details.put('PTSTAT', new DetailInfo('PTSTAT','both'));
		details.put('WHTRI', new DetailInfo('WHTRI','both'));
		storeEntry = 'enter'; // select, enter or both
		mailEntry = 'enter'; // same, enter or both
		thisFormCode = 'SGEHE2012'; // identifies the form within FDC
	}
	
	// override beforeShowRebate() to place custom code before the main showRebate() call
	// override afterShowRebate() to place custom code after the main showRebate() call
	// override beforeTestInit() to place custom code before the main testInit() call
	// override afterTestInit() to place custom code after the main testInit() call
	// override beforeStandardValidation to place custom code before the standard validation code
	// override afterStandardValidation to place custom code after the standard validation code
	// override accountPCustLookup to replace this procedure with a custom variation
	// override decideWriteDetailRecord(String rcode) to control writing of detail records
	// override decideWriteSurveyRecord(String sname) to control writing of survey records
	
	public override Boolean decideWriteDetailRecord(String rcode) {
		return formFields.get('RebateDetail__c.MeasureSelected.'+rcode).booleanValue;	
	}
	
	public override Boolean decideWriteSurveyRecord(formField f) {
		if (f.fieldName == 'Fuel_Type') {
			return (formFields.get('RebateSurvey__c.Fuel_Cnv').stringValue == 'Y');
		} else {
			return true;
		}
	}	
	
	// add any needed custom methods here
	
	// @isTest(SeeAllData=True)
	static testMethod void test(){   // was public static void
		// create the account we're using for the test cases
		Account a = new Account(Name='Test Account', ClientCode__c='CLIENT');
		insert a;
		// create the form we're using for the test cases
		Form__c f = new Form__c(Name='Test Form', FormCode__c = 'SGEHE2012', AccountID__c = a.ID);		
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
		insert new FormFields__c(FormID__c=f.ID, DataType__c='String', FieldName__c='MailingZipcode__c', TargetTable__c='Rebate__c',
			BlankStop__c='none', TestValue__c='12345', DoNotSave__c=true);
		insert new FormFields__c(FormID__c=f.ID, DataType__c='Boolean', FieldName__c='SelStoreState', TargetTable__c='Rebate__c',
			BlankStop__c='none', TestValue__c='MA', DoNotSave__c=true);
		insert new FormFields__c(FormID__c=f.ID, DataType__c='Boolean', FieldName__c='SelStoreCity', TargetTable__c='Rebate__c',
			BlankStop__c='none', TestValue__c='Boston', DoNotSave__c=true);
		insert new FormFields__c(FormID__c=f.ID, DataType__c='String', FieldName__c='StoreID__c', TargetTable__c='Rebate__c',
			BlankStop__c='none');
		insert new FormFields__c(FormID__c=f.ID, DataType__c='Date', FieldName__c='PurchaseDate__c', TargetTable__c='Rebate__c',
			BlankStop__c='none');
        insert new FormFields__c(FormID__c=f.ID, DataType__c='String', FieldName__c='SubmitAs', TargetTable__c='Rebate__c',
            BlankStop__c='none', InitValue__c='Reservation', TestValue__c='Reservation', DoNotSave__c=true);
        insert new FormFields__c(FormID__c=f.ID, DataType__c='String', FieldName__c='SubmitVia__c', TargetTable__c='Rebate__c',
            BlankStop__c='none');
		// FRN
		insert new FormFields__c(FormID__c=f.ID, DataType__c='Boolean', FieldName__c='ManualModelFlag', 
			TargetTable__c='RebateDetail__c', RecordCode__c='FRN', BlankStop__c='none', TestValue__c='true', DoNotSave__c=true);
		insert new FormFields__c(FormID__c=f.ID, DataType__c='Boolean', FieldName__c='MeasureSelected', 
			TargetTable__c='RebateDetail__c', RecordCode__c='FRN', BlankStop__c='none', TestValue__c='false', DoNotSave__c=true);
		insert new FormFields__c(FormID__c=f.ID, DataType__c='String', FieldName__c='MeasureCode__c', 
			TargetTable__c='RebateDetail__c', RecordCode__c='FRN', BlankStop__c='soft', TestValue__c='M');
		insert new FormFields__c(FormID__c=f.ID, DataType__c='String', FieldName__c='Manufacturer__c', 
			TargetTable__c='RebateDetail__c', RecordCode__c='FRN', BlankStop__c='soft', TestValue__c='KENMORE');
		insert new FormFields__c( FormID__c=f.ID, DataType__c='String', FieldName__c='ModelNumber__c', 
			TargetTable__c='RebateDetail__c', RecordCode__c='FRN', BlankStop__c='soft', TestValue__c='XYZ');
		insert new FormFields__c( FormID__c=f.ID, DataType__c='Decimal', FieldName__c='MeasureRebateAmount__c', 
			TargetTable__c='RebateDetail__c', RecordCode__c='FRN', BlankStop__c='none', TestValue__c='100');
		insert new FormFields__c(FormID__c=f.ID, DataType__c='Boolean', FieldName__c='SelManufacturer', TargetTable__c='RebateDetail__c',
			RecordCode__c='FRN', BlankStop__c='none', DoNotSave__c=true);
		insert new FormFields__c(FormID__c=f.ID, DataType__c='String', FieldName__c='ModelID__c', TargetTable__c='RebateDetail__c',
			RecordCode__c='FRN', BlankStop__c='none');
		// FRNECM
		insert new FormFields__c(FormID__c=f.ID, DataType__c='Boolean', FieldName__c='ManualModelFlag', TargetTable__c='RebateDetail__c',
			RecordCode__c='FRNECM', BlankStop__c='none', TestValue__c='true', DoNotSave__c=true);
		insert new FormFields__c(FormID__c=f.ID, DataType__c='Boolean', FieldName__c='MeasureSelected', TargetTable__c='RebateDetail__c',
			RecordCode__c='FRNECM', BlankStop__c='none', TestValue__c='false', DoNotSave__c=true);
		insert new FormFields__c(FormID__c=f.ID, DataType__c='String', FieldName__c='MeasureCode__c', 
			TargetTable__c='RebateDetail__c', RecordCode__c='FRNECM', BlankStop__c='soft', TestValue__c='M');
		insert new FormFields__c(FormID__c=f.ID, DataType__c='String', FieldName__c='Manufacturer__c', 
			TargetTable__c='RebateDetail__c', RecordCode__c='FRNECM', BlankStop__c='soft', TestValue__c='KENMORE');
		insert new FormFields__c( FormID__c=f.ID, DataType__c='String', FieldName__c='ModelNumber__c', 
			TargetTable__c='RebateDetail__c', RecordCode__c='FRNECM', BlankStop__c='soft', TestValue__c='XYZ');
		insert new FormFields__c( FormID__c=f.ID, DataType__c='Decimal', FieldName__c='MeasureRebateAmount__c', 
			TargetTable__c='RebateDetail__c', RecordCode__c='FRNECM', BlankStop__c='none', TestValue__c='100');
		insert new FormFields__c(FormID__c=f.ID, DataType__c='Boolean', FieldName__c='SelManufacturer', TargetTable__c='RebateDetail__c',
			RecordCode__c='FRNECM', BlankStop__c='none', DoNotSave__c=true);
		insert new FormFields__c(FormID__c=f.ID, DataType__c='String', FieldName__c='ModelID__c', TargetTable__c='RebateDetail__c',
			RecordCode__c='FRNECM', BlankStop__c='none');
		// BOILST
		insert new FormFields__c(FormID__c=f.ID, DataType__c='Boolean', FieldName__c='ManualModelFlag', TargetTable__c='RebateDetail__c',
			RecordCode__c='BOILST', BlankStop__c='none', TestValue__c='true', DoNotSave__c=true);
		insert new FormFields__c(FormID__c=f.ID, DataType__c='Boolean', FieldName__c='MeasureSelected', TargetTable__c='RebateDetail__c',
			RecordCode__c='BOILST', BlankStop__c='none', TestValue__c='false', DoNotSave__c=true);
		insert new FormFields__c(FormID__c=f.ID, DataType__c='String', FieldName__c='MeasureCode__c', 
			TargetTable__c='RebateDetail__c', RecordCode__c='BOILST', BlankStop__c='soft', TestValue__c='M');
		insert new FormFields__c(FormID__c=f.ID, DataType__c='String', FieldName__c='Manufacturer__c', 
			TargetTable__c='RebateDetail__c', RecordCode__c='BOILST', BlankStop__c='soft', TestValue__c='KENMORE');
		insert new FormFields__c( FormID__c=f.ID, DataType__c='String', FieldName__c='ModelNumber__c', 
			TargetTable__c='RebateDetail__c', RecordCode__c='BOILST', BlankStop__c='soft', TestValue__c='XYZ');
		insert new FormFields__c( FormID__c=f.ID, DataType__c='Decimal', FieldName__c='MeasureRebateAmount__c', 
			TargetTable__c='RebateDetail__c', RecordCode__c='BOILST', BlankStop__c='none', TestValue__c='100');
		insert new FormFields__c(FormID__c=f.ID, DataType__c='Boolean', FieldName__c='SelManufacturer', TargetTable__c='RebateDetail__c',
			RecordCode__c='BOILST', BlankStop__c='none', DoNotSave__c=true);
		insert new FormFields__c(FormID__c=f.ID, DataType__c='String', FieldName__c='ModelID__c', TargetTable__c='RebateDetail__c',
			RecordCode__c='BOILST', BlankStop__c='none');
		// BOILHW
		insert new FormFields__c(FormID__c=f.ID, DataType__c='Boolean', FieldName__c='ManualModelFlag', TargetTable__c='RebateDetail__c',
			RecordCode__c='BOILHW', BlankStop__c='none', TestValue__c='true', DoNotSave__c=true);
		insert new FormFields__c(FormID__c=f.ID, DataType__c='Boolean', FieldName__c='MeasureSelected', TargetTable__c='RebateDetail__c',
			RecordCode__c='BOILHW', BlankStop__c='none', TestValue__c='false', DoNotSave__c=true);
		insert new FormFields__c(FormID__c=f.ID, DataType__c='String', FieldName__c='MeasureCode__c', 
			TargetTable__c='RebateDetail__c', RecordCode__c='BOILHW', BlankStop__c='soft', TestValue__c='M');
		insert new FormFields__c(FormID__c=f.ID, DataType__c='String', FieldName__c='Manufacturer__c', 
			TargetTable__c='RebateDetail__c', RecordCode__c='BOILHW', BlankStop__c='soft', TestValue__c='KENMORE');
		insert new FormFields__c( FormID__c=f.ID, DataType__c='String', FieldName__c='ModelNumber__c', 
			TargetTable__c='RebateDetail__c', RecordCode__c='BOILHW', BlankStop__c='soft', TestValue__c='XYZ');
		insert new FormFields__c( FormID__c=f.ID, DataType__c='Decimal', FieldName__c='MeasureRebateAmount__c', 
			TargetTable__c='RebateDetail__c', RecordCode__c='BOILHW', BlankStop__c='none', TestValue__c='100');
		insert new FormFields__c(FormID__c=f.ID, DataType__c='Boolean', FieldName__c='SelManufacturer', TargetTable__c='RebateDetail__c',
			RecordCode__c='BOILHW', BlankStop__c='none', DoNotSave__c=true);
		insert new FormFields__c(FormID__c=f.ID, DataType__c='String', FieldName__c='ModelID__c', TargetTable__c='RebateDetail__c',
			RecordCode__c='BOILHW', BlankStop__c='none');
		// PTSTAT
		insert new FormFields__c(FormID__c=f.ID, DataType__c='Boolean', FieldName__c='ManualModelFlag', TargetTable__c='RebateDetail__c',
			RecordCode__c='PTSTAT', BlankStop__c='none', TestValue__c='true', DoNotSave__c=true);
		insert new FormFields__c(FormID__c=f.ID, DataType__c='Boolean', FieldName__c='MeasureSelected', TargetTable__c='RebateDetail__c',
			RecordCode__c='PTSTAT', BlankStop__c='none', TestValue__c='false', DoNotSave__c=true);
		insert new FormFields__c(FormID__c=f.ID, DataType__c='String', FieldName__c='MeasureCode__c', 
			TargetTable__c='RebateDetail__c', RecordCode__c='PTSTAT', BlankStop__c='soft', TestValue__c='M');
		insert new FormFields__c(FormID__c=f.ID, DataType__c='String', FieldName__c='Manufacturer__c', 
			TargetTable__c='RebateDetail__c', RecordCode__c='PTSTAT', BlankStop__c='soft', TestValue__c='KENMORE');
		insert new FormFields__c( FormID__c=f.ID, DataType__c='String', FieldName__c='ModelNumber__c', 
			TargetTable__c='RebateDetail__c', RecordCode__c='PTSTAT', BlankStop__c='soft', TestValue__c='XYZ');
		insert new FormFields__c( FormID__c=f.ID, DataType__c='Decimal', FieldName__c='MeasureRebateAmount__c', 
			TargetTable__c='RebateDetail__c', RecordCode__c='PTSTAT', BlankStop__c='none', TestValue__c='100');
		insert new FormFields__c(FormID__c=f.ID, DataType__c='Boolean', FieldName__c='SelManufacturer', TargetTable__c='RebateDetail__c',
			RecordCode__c='PTSTAT', BlankStop__c='none', DoNotSave__c=true);
		insert new FormFields__c(FormID__c=f.ID, DataType__c='String', FieldName__c='ModelID__c', TargetTable__c='RebateDetail__c',
			RecordCode__c='PTSTAT', BlankStop__c='none');
		// WHTRI
		insert new FormFields__c(FormID__c=f.ID, DataType__c='Boolean', FieldName__c='ManualModelFlag', TargetTable__c='RebateDetail__c',
			RecordCode__c='WHTRI', BlankStop__c='none', TestValue__c='true', DoNotSave__c=true);
		insert new FormFields__c(FormID__c=f.ID, DataType__c='Boolean', FieldName__c='MeasureSelected', TargetTable__c='RebateDetail__c',
			RecordCode__c='WHTRI', BlankStop__c='none', TestValue__c='false', DoNotSave__c=true);
		insert new FormFields__c(FormID__c=f.ID, DataType__c='String', FieldName__c='MeasureCode__c', 
			TargetTable__c='RebateDetail__c', RecordCode__c='WHTRI', BlankStop__c='soft', TestValue__c='M');
		insert new FormFields__c(FormID__c=f.ID, DataType__c='String', FieldName__c='Manufacturer__c', 
			TargetTable__c='RebateDetail__c', RecordCode__c='WHTRI', BlankStop__c='soft', TestValue__c='KENMORE');
		insert new FormFields__c( FormID__c=f.ID, DataType__c='String', FieldName__c='ModelNumber__c', 
			TargetTable__c='RebateDetail__c', RecordCode__c='WHTRI', BlankStop__c='soft', TestValue__c='XYZ');
		insert new FormFields__c( FormID__c=f.ID, DataType__c='Decimal', FieldName__c='MeasureRebateAmount__c', 
			TargetTable__c='RebateDetail__c', RecordCode__c='WHTRI', BlankStop__c='none', TestValue__c='100');
		insert new FormFields__c(FormID__c=f.ID, DataType__c='Boolean', FieldName__c='SelManufacturer', TargetTable__c='RebateDetail__c',
			RecordCode__c='WHTRI', BlankStop__c='none', DoNotSave__c=true);
		insert new FormFields__c(FormID__c=f.ID, DataType__c='String', FieldName__c='ModelID__c', TargetTable__c='RebateDetail__c',
			RecordCode__c='WHTRI', BlankStop__c='none');
		insert new FormFields__c(FormID__c=f.ID, DataType__c='String', FieldName__c='HouseType', TargetTable__c='RebateSurvey__c',
			BlankStop__c='none', TestValue__c='SF');
		insert new FormFields__c(FormID__c=f.ID, DataType__c='Decimal', FieldName__c='HouseUnits', TargetTable__c='RebateSurvey__c',
			BlankStop__c='none', TestValue__c='1');
		FormSGE2012HE c = new FormSGE2012HE();				// create the controller instance for the test suite
		Test.startTest();
		// The official test starts here
		c.showErrorIcons();
		c.clearErrorIcons();
		List<selectOption> tl = c.makeFormList('Test','dropdown');
		c.storeEntry = 'enter';								// no lookup option	
		c.makeStoreList();									// but make store list anyway
		c.getStoreList();								
		c.testInit();				
		c.makeManufacturerList('FRN');
		c.getStateList();					
		c.initializeSession();
		c.getSessionData();
		c.actionCheckMe();									// display validation errors
		c.formFields.get('Contact.LastName').stringValue = 'Smith';
		c.actionCheckMe();									// submit a form, overrides soft stops
		//c.showRebate();										// run code to display an existing rebate
		Test.stopTest();
	}
}