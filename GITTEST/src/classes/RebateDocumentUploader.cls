/*
    CEV:2012.08.30::Facilitates adding of uploaded documents to an external repository and the removal of existing documents
        from said repository.
*/
public class RebateDocumentUploader {
    
    //-- CHOSEN BY ACCOUNT/FORM?
    private static final string TARGET_REPOSITORY = 'ImageSilo';
    private static final String TARGET_PROJECT = 'V3 TEST';
    
    //-- UPLOADED DATA FROM CLIENT (i.e. FILE)
    public Blob fileBody { get; set; }
    public String fileName {get; set;}
    public Integer fileSize {get; set; }
        
    private RebateDocument__c[] documents;
    
    //-- THE ID OF THE REBATEDOCUMENT THAT WE ARE OPERATING ON
    public String selectedDocId {get; set;}
    
    //-- SET BY PARENT WINDOW VIA URL -- THE CURRENT KEY FOR THE TRANSACTION
    public String sessionId {get; private set;}
    
    public boolean initialized {get; private set;}
    
    private boolean isTest = false;
    
    public RebateDocumentUploader(){ this(false); }
    public RebateDocumentUploader(boolean isTest){
        //-- There isn't necessarily a valid rebate at this point.  Use the sessionID to bind documents together.
        this.isTest = isTest;
        initialized = false;
        System.debug('RebateDocumentUploader::RebateDocumentUploader()');
        sessionId = System.currentPageReference().getParameters().get('sessionId');
    }
    
    public PageReference init(){
        initializeDocuments();
        return null;
    }
    
    public RebateDocument__c[] getDocuments(){
       
        initializeDocuments();
        return documents;
    }
    
    public PageReference DeleteFile(){
        selectedDocId = System.currentPageReference().getParameters().get('selectedDocId');
        System.debug('DELETE ID: '+selectedDocId);
        
        Integer delIndex = -1;
        for(Integer i=0; i < documents.size(); i++){
            if( documents[i].id == selectedDocId ){
                delIndex = i;
                break;
            }
        }
        
        if( delIndex >= 0 ){
            DocumentRepository docRep = DocumentRepository.findRepository( documents[delIndex].DocumentRepository__c, documents[delIndex].RepositoryProject__c, isTest );
            docRep.deleteDocument( documents[delIndex].RepositoryProject__c, documents[delIndex].ExternalDocumentId__c );
            delete documents[delIndex];
            documents.remove(delIndex);
        }
        initialized = false;
        return null;
    }
    
    public PageReference UploadFile(){
    
        if( !validate() ){
            fileBody = null;
            fileName = null; 
            return null;
        }
        
        DocumentRepository docRep = DocumentRepository.findRepository( TARGET_REPOSITORY, TARGET_PROJECT, isTest );
        if( docRep == null ) return null;
        String externalId = docRep.storeDocument(fileBody, fileName, 0, TARGET_PROJECT, null, null, null);
        
        RebateDocument__c doc = new RebateDocument__c(DocumentRepository__c = docRep.getName(), RepositoryProject__c = TARGET_PROJECT, 
            ExternalDocumentId__c = externalId, Name = fileName, FileName__c = fileName, FileSize__c = fileSize, SessionId__c = sessionId,
            Originator__c = 'Customer', OriginatorAgent__c = 'Customer');
            
        insert doc;
        documents.add( doc );     
        
        fileBody = null;
        fileName = null;
        fileSize = -1;
        
        initialized = false;
        return null;
    }
    
    private static final Set<String> ALLOWED_TYPES = new Set<String>{'pdf', 'png', 'gif', 'bmp', 'jpg', 'jpeg', 'doc', 'docx', 'tif', 'tiff'};
    private boolean validate(){
        boolean success = true;
        EFI__c settings = EFI__c.getInstance();
        
        if( fileSize == 0 ){
            ApexPages.addMessage( Utils.createErrorMessage('There was an error uploading the file: null size'));
            success = false;
        }
        
        if( Utils.isEmpty(fileName)){
            ApexPages.addMessage( Utils.createErrorMessage('There was an error uploading the file: null fileName'));
            success = false;
        } else {
            String[] parts = fileName.split('\\.');
            if( parts == null || parts.size() < 2 || Utils.isEmpty(parts[parts.size()-1])){
                ApexPages.addMessage( Utils.createErrorMessage('Unable to determine the file type.  Please upload a file with one of the following extensions: '+Utils.concat(new List<String>(ALLOWED_TYPES), ', ')));
                success = false;
            } else if(!ALLOWED_TYPES.contains(parts[parts.size()-1].toLowerCase())){
                ApexPages.addMessage( Utils.createErrorMessage('Unsupported file type "'+parts[parts.size()-1].toLowerCase()+'".  Please upload a file with one of the following extensions: '+Utils.concat(new List<String>(ALLOWED_TYPES), ', ')));
                success = false;
            }
        }
        
        if( fileSize > settings.MaxFileSize__c * 1024 ){ 
            ApexPages.addMessage( Utils.createErrorMessage('Uploaded documents must be smaller than '+settings.MaxFileSize__c.intValue()+' KB'));
            success = false;
        }
        return success;
    }
    
    public boolean getHasUploadedFiles(){ 
        System.debug('RebateDocumentUploader::getHasUploadedFile()');
        initializeDocuments();
        return !documents.isEmpty(); 
    }
    
    //-- LOADS EXISTING DOCUMENTS FOR THE SESSION
    private void initializeDocuments(){
        System.debug('RebateDocumentUploader::initializeDocuments()');
        initialized = true;
        documents = [select id, FileName__c, ExternalDocumentId__c, RepositoryProject__c, documentrepository__c, sessionid__c FROM RebateDocument__c where sessionId__c = :sessionId];
        System.debug('initializing docs: '+documents.size()+'; sessionID: '+sessionId);
    }
    
    @isTest(SeeAllData=true)
    public static void testIt(){
        PageReference p = Page.RebateDocumentUploader;
        p.getParameters().put('sessionId', 'ABC123');
        
        Test.setCurrentPage(p);
        Test.startTest();
        
        RebateDocumentUploader up = new RebateDocumentUploader(true);
        up.init();
        
        up.fileName = 'Test.tgz';
        up.fileSize = -1;
        up.fileBody = Blob.valueOf('TEST CONTENT');
        up.UploadFile();
        
        up.fileName = 'test.doc';
        up.fileSize = -1;
        up.fileBody = Blob.valueOf('TEST CONTENT');
        up.UploadFile();
        
        up.getHasUploadedFiles();
        RebateDocument__c[] docs = up.getDocuments();
        
        p.getParameters().put('selectedDocId', docs[0].id);
        up.DeleteFile();
        
                
    }
}