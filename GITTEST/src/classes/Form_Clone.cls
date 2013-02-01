/* Vitone:2012.02.22
 *
 * Copies the source form to the target form along with a user-defined subset of the child objects.  The target
 * form is allowed to be either a new (i.e. non-existant) form or an existing form.  
 *
 */
public class Form_Clone {

//-- The names of the child relationships
    private static final String HLIMIT =    'HistoryLimit__c';
    private static final String MEASURE =   'Measure__c';
    private static final String MODEL =     'FormXModel__c';
    private static final String QUESTION =  'SurveyQuestions__c';
    private static final String STORE =     'FormXStore__c';
    private static final String REPORT =    'CustomReport__c';
    private static final String PARAM =     'FormParameter__c';
    private static final String FIELD =     'FormFields__c';
    private static final String LISTS =      'FormList__c';

    public String sourceFormCode {get; set;}
    public String targetClientCode {get; set;} 
    public String targetFormName {get; set;} 
    public String targetFormCode {get; set;}
    
    public Boolean mergeForm {get; set; }       //-- allows copying to existing form
    public Boolean overwriteForm{ get; set; }   //-- overwrites existing form w/ src form data
    
//-- copyXXX determines which children will be copied from src->tgt
    public Boolean copyLimits {
        get { return childrenMap.get(HLIMIT).copy; }
        set { childrenMap.get(HLIMIT).copy = value; }
    }
    
    public Boolean copyMeasures {
        get { return measureChild.copy; }
        set { measureChild.copy = value; }
    }
    
    public Boolean copyQuestions {
        get { return childrenMap.get(QUESTION).copy; }
        set {childrenMap.get(QUESTION).copy = value; }
    }
    public Boolean copyStores {
        get { return childrenMap.get(STORE).copy; }
        set {childrenMap.get(STORE).copy = value;}
    }
    public Boolean copyModels {
        get { return modelChild.copy; }
        set {modelChild.copy = value;}
    }
    public Boolean copyReports {
        get { return childrenMap.get(REPORT).copy; }
        set {childrenMap.get(REPORT).copy = value;}
    }
    public Boolean copyFormParams  {
        get { return childrenMap.get(PARAM).copy; }
        set {childrenMap.get(PARAM).copy = value;}
    }
    public boolean copyFormFields {
        get { return childrenMap.get(FIELD).copy; }
        set {childrenMap.get(FIELD).copy = value; }
    }
    public boolean copyFormLists{
        get { return childrenMap.get(LISTS).copy; }
        set { childrenMap.get(LISTS).copy = value; }
    }
    
//-- overwriteXXX deletes the tgt forms children
    public Boolean overwriteLimits  {
        get { return childrenMap.get(HLIMIT).overwrite; }
        set {childrenMap.get(HLIMIT).overwrite = value;}
    }
    public Boolean overwriteMeasures  {
        get { return measureChild.overwrite; }
        set { measureChild.overwrite = value; }
    }
    public Boolean overwriteQuestions  {
        get { return childrenMap.get(QUESTION).overwrite; }
        set {childrenMap.get(QUESTION).overwrite = value;}
    }
    public Boolean overwriteStores  {
        get { return childrenMap.get(STORE).overwrite; }
        set {childrenMap.get(STORE).overwrite = value;}
    }
    public Boolean overwriteModels   {
        get { return modelChild.overwrite; }
        set {modelChild.overwrite = value;}
    }
    public Boolean overwriteReports   {
        get { return childrenMap.get(REPORT).overwrite; }
        set {childrenMap.get(REPORT).overwrite = value;}
    }
    public Boolean overwriteFormParams  {
        get { return childrenMap.get(PARAM).overwrite; }
        set {childrenMap.get(PARAM).overwrite = value;}
    }
    public Boolean overwriteFormFields {
        get { return childrenMap.get(FIELD).overwrite; }
        set {childrenMap.get(FIELD).overwrite = value; }
    }
    public Boolean overwriteFormLists {
        get { return childrenMap.get(LISTS).overwrite; }
        set {childrenMap.get(LISTS).overwrite = value; }
    }
    
//-- these children can be automatically created
    private Map<String, FormChild> childrenMap = new Map<String, FormChild>{
        HLIMIT => new FormChild(HLIMIT, false, false),
        QUESTION => new FormChild(QUESTION, false, false),
        STORE => new FormChild(STORE, false, false),
        REPORT => new FormChild(REPORT, false, false),
        PARAM => new FormChild(PARAM, false, false),
        FIELD => new FormChild(FIELD, false, false),
        LISTS => new FormChild(LISTS, false, false)
    };
    
//-- these two have secondary relationships that must be contructed manually
    private FormChild modelChild = new FormChild(MODEL, false, false);
    private FormChild measureChild = new FormChild(MEASURE, false, false);
    
    private Boolean isTest = false;
    
    public Form_Clone(Boolean isTest){this.isTest = isTest; }
    public Form_Clone(){ this(false); }
    
    public PageReference cloneForm(){
//-- validation
        boolean hasError = false;
        Account[] accounts = [select id from Account where ClientCode__c = :targetClientCode];
        if( accounts == null || accounts.size() != 1){
            hasError =true;
            ApexPages.addMessage( Utils.createErrorMessage('The client code does not exist'));
        }

        Form__c[] targetForm = new List<Form__c>([select id from Form__c where formCode__c =: targetFormCode]);
        if( !mergeForm && targetForm != null && targetForm.size() != 0){
            hasError = true;
            ApexPages.addMessage( Utils.createErrorMessage('The target form code already exists.  Check "Form Exists" to allow updating of existing form'));
        }
                    
        SObject[] sourceForm = Database.query( Utils.buildSQL('Form__c')+' WHERE formCode__c =\''+String.escapeSingleQuotes(sourceFormCode)+'\'');
        if( sourceForm == null || sourceForm.size() != 1 ){
            hasError = true;
            ApexPages.addMessage( Utils.createErrorMessage('The source form code does not exist'));
        }
        
        if( modelChild.copy && !measureChild.copy ){
            ApexPages.addMessage( Utils.createErrorMessage('Form X Model depends on Measure.  You must also copy the measures when you copy the models'));
            hasError = true;
        }
        
        if( hasError ){
            return null;
        }
        
//--process
        System.debug('Cloning Forms');
        ID accountId = accounts[0].id;
        ID sourceFormId = sourceForm[0].id;
        ID targetFormId = targetForm != null && targetForm.size() > 0 ? targetForm[0].id : null;

        //-- create or update target form
        if( targetFormId == null || overwriteForm ){
            Form__c f = null;
            
            if( targetFormId == null ){
                f = (Form__c)sourceForm[0].clone(false, false, false, false);
                f.AccountId__c = accountId;
            }
            else {
                f = targetForm[0];
                Utils.copyTo((Form__c)sourceForm[0], f, 'Form__c');
            }
            
            f.formCode__c = targetFormCode;
            f.name = targetFormName;
            
            if( targetFormId == null ){
                f.SyncToPdx__c = false;
                f.IsActive__c = false;
                insert f;
            } else {
                update f;
            }
            targetFormId = f.id;
        }
        
        //-- copy child data
        for(FormChild c : childrenMap.values()){
            
            if( c.copy ){
                if( c.overwrite )
                    deleteChildObjects(targetFormId, c.name);
                cloneChild(c.name, sourceFormId, targetFormId, true);
            }
        }
        
        //-- deal with secondary relationships
        if( measureChild.copy ){
            if( measureChild.overwrite )
                deleteChildObjects(targetFormId, measureChild.name);
            Map<String, SObject> measureMap = cloneChild(MEASURE, sourceFormId, targetFormId, true);
            
            if( modelChild.copy ){
                if(modelChild.overwrite)
                    deleteChildObjects(targetFormId, modelChild.name);
                cloneFormModels(sourceFormId, targetFormId, measureMap);
            }
        }
        
        return new PageReference('/'+targetFormId);
    }
    
    private Map<String, SObject> cloneChild(String objType, ID sourceFormId, ID targetFormId, Boolean doInsert){
        System.debug('CLONE FIELDS: '+Utils.buildSQL(objtype));
        SObject[] sos = Database.query(Utils.buildSQL(objtype)+' WHERE FormID__c =\''+sourceFormId+'\''+(isTest ? ' LIMIT 10' : ''));
        if( sos == null ) return null;
        
        SObject[] ins = new List<SObject>();
        for(SObject s : sos){
            SObject c = s.clone(false, false, false, false);
            c.put('FormID__c', targetFormId);
            ins.add(c);
        }
        
        if( doInsert ) insert ins;
        
        Map<String, SObject> idMap = new Map<String, SObject>();
        for(Integer i=0; i < sos.size(); i++){
            idMap.put( sos[i].id, ins[i] );
        }
        return idMap;
    }
    
    private void deleteChildObjects(String targetFormId, String childType){
        SObject[] data = Database.query('Select id from '+childType+' where FormId__c=\''+targetFormId+'\'');
        if( data != null && data.size() > 0 )
            delete data;
    }
    
    private void cloneFormModels(String sourceFormId, ID targetFormId, Map<String, SObject> measureMap){
        Map<String, SObject> formModels = cloneChild('FormXModel__c', sourceFormId, targetFormId, false);
        
        for(SObject m : formModels.values()){
            FormXModel__c fxModel = (FormXModel__c)m;
            fxModel.measureID__c = measureMap.get( fxModel.measureID__c ).id;
        }
        
        insert formModels.values();
    }
    
    class FormChild{
        public String name;
        public Boolean copy;
        public Boolean overwrite;
        
        public FormChild(String n, Boolean c, Boolean o){
            name = n;
            copy = c;
            overwrite = o;
        }
    }
}