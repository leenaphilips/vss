public class Administration{

    public String sourceFormCode {get; set;}
    public String targetClientCode {get; set;}
    public String targetFormCode {get; set;}
  
    public Boolean copyLimits {get; set;}
    public Boolean copyMeasures {get; set;}
    public Boolean copyQuestions {get; set;}
    public Boolean copyStores {get; set;}
    public Boolean copyModels {get; set;}
    public Boolean copyReports {get; set;}
    public Boolean copyFormParams {get; set;}
    public Boolean copyFormFields {get; set;}
    public Boolean copyFormLists {get; set; }
    
    public Boolean overwriteLimits {get; set;}
    public Boolean overwriteMeasures {get; set;}
    public Boolean overwriteQuestions {get; set;}
    public Boolean overwriteStores {get; set;}
    public Boolean overwriteModels {get; set;}
    public Boolean overwriteReports {get; set;}
    public Boolean overwriteFormParams {get; set;}
    public Boolean overwriteFormFields {get; set;}
    public Boolean overwriteFormLists {get; set; }
    
    public Boolean overwriteForm {get; set; }
    public Boolean mergeForm {get; set; }
    
    private Boolean isTest = false;
  
  public String emailAddress{ get; set; }
  
  public Administration(){ this(false); }
  
  private Administration(boolean isTest){
    sourceFormCode = '';
    targetFormCode = '';
    targetClientCode = '';
    this.isTest = isTest; 
  }
  
  public PageReference cleanModels(){
      return (new Admin_CleanModels(isTest)).clean();
  }
  
  public PageReference buildManufacturers(){
    return (new Admin_BuildManufacturers(isTest)).buildManufacturers(); 
  }
  
  public PageReference sendStatusEmails(){
      (new EmailBatchProcessor()).sendAllEmails();
      return null;
  }
  
  public PageReference deleteSgeRecords(){
      if( emailAddress == null ) return null;
      
      for(List<Rebate__c> rebates : [select id from Rebate__c where FormId__r.ClientCode__c = 'SGE' and ContactId__r.Email =: emailAddress]){
          if( rebates != null && !rebates.isEmpty() )
              delete rebates;
      }
      return null;
  }
  
  public PageReference cloneForm(){
    Form_Clone fc = new Form_Clone(isTest);
    fc.sourceFormCode = sourceFormCode;
    fc.targetClientCode = targetClientCode;
    fc.targetFormCode = targetFormCode;
    
    fc.copyLimits = copyLimits;
    fc.copyMeasures = copyMeasures;
    fc.copyModels = copyModels;
    fc.copyStores = copyStores;
    fc.copyReports = copyReports;
    fc.copyQuestions = copyQuestions;
    fc.copyFormParams = copyFormParams;
    fc.copyFormFields = copyFormFields;
    fc.copyFormLists = copyFormLists;
    
    fc.overwriteLimits = overwriteLimits;
    fc.overwriteMeasures = overwriteMeasures;
    fc.overwriteModels = overwriteModels;
    fc.overwriteStores = overwriteStores;
    fc.overwriteReports = overwriteReports;
    fc.overwriteFormParams = overwriteFormParams;
    fc.overwriteFormFields = overwriteFormFields;
    fc.overwriteQuestions = overwriteQuestions;
    fc.overwriteFormLists = overwriteFormLists;
    
    fc.overwriteForm = overwriteForm;
    fc.mergeForm = mergeForm;
    
    return fc.cloneForm();
  }
  
  @IsTest(SeeAllData=true)
  public static void testIt(){
    PageReference ref = Page.Administration;
    Test.setCurrentPage(ref);
    
    Administration a = new Administration(true);
    

    a.copyLimits = true;
    a.copyMeasures = true;
    a.copyModels = true;
    a.copyStores = false;
    a.copyReports = false;
    a.copyQuestions = false;
    a.copyFormParams = false;
    a.copyFormFields = false;
    a.copyFormLists = true;
    
    a.overwriteLimits = false;
    a.overwriteMeasures = true;
    a.overwriteModels = false;
    a.overwriteStores = false;
    a.overwriteReports = false;
    a.overwriteFormParams = false;
    a.overwriteQuestions = false;
    a.overwriteFormFields = false;
    a.overwriteFormLists = true;
        
    a.overwriteForm = true;
    a.mergeForm = true;
    
    a.sourceFormCode = 'SGERF2012';
    a.targetFormCode = 'SGERF2012B';
    a.targetClientCode = 'SGE';
    
    Test.startTest();
    a.cleanModels();
    a.cloneForm();
    Test.stopTest();
  }
}