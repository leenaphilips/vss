public class ImageSiloRepository extends DocumentRepository{
    
    public static final String NAME = 'ImageSilo';
    private static final String USER_NAME = 'cvitone';
    private static final String PASSWORD = 'Fr1end';
    
    private static final String IDX_FDCREBATENUMBER = 'FDC REBATE NUMBER';
    private static final String IDX_DOCUMENTSTATUS = 'DOCUMENT STATUS';
    private static final String IDX_DOCUMENTTYPE = 'DOCUMENT TYPE';
    private static final String IDX_SOURCE = 'SOURCE';
     
    private ImageSilo imageSilo;
    private Boolean isTest = false;
    
    public ImageSiloRepository (){ this(false); }
    
    public ImageSiloRepository (Boolean isTest){ 
        System.debug('IS TEST: '+isTest);
        this.isTest = isTest; 
        imageSilo = new ImageSilo(USER_NAME, PASSWORD, isTest);
    }
    
    public override String storeDocument(Blob d, String filename, Integer fileSize, String project, Integer fdcRebateNumber, DocumentStatus status, DocumentType type){
        imageSilo.setProjectByName(project);
        Map<String, String> indexes = new Map<String, String>{
            IDX_FDCREBATENUMBER => fdcRebateNumber != null ? fdcRebateNumber + '' : null,
            IDX_DOCUMENTSTATUS => status != null ? status.name() : null,
            IDX_DOCUMENTTYPE => type != null ? type.name() : null,
            IDX_SOURCE => 'ELECTRONIC'
        };
        return imageSilo.uploadDocument(filename, d, indexes) + ''; 
    }
    public override boolean setDocumentIndexes(String projectName, String docId, Integer fdcRebateNumber, DocumentStatus status, DocumentType type){
        imageSilo.setProjectByName(projectName);
        
    
        /* I received an error when I attempted to just update the indexes that I cared about.  
        It appears that I must update all of the indexes defined for the project */
        ImageSilo.Project project = imageSilo.getCurrentProject();
        
        Map<String, String> indexes = new Map<String, String>();
        for(String index : project.getIndexNames()){
            indexes.put(index, null);
        }
        
        indexes.put(IDX_FDCREBATENUMBER, fdcRebateNumber != null ? fdcRebateNumber + '' : null);
        indexes.put(IDX_DOCUMENTSTATUS, status != null ? status.name() : null);
        indexes.put(IDX_DOCUMENTTYPE, type != null ? type.name() : null);
        indexes.put(IDX_SOURCE, 'ELECTRONIC');

        imageSilo.updateDocumentIndexes(Integer.valueOf(docId), indexes);
        return true;
    }
    
    public override String getName(){ return NAME; }
    
    public override ExternalDocument retrieveDocument(String project, String id){
        ExternalDocument[] docs = retrieveDocuments(project, new String[]{id});
        return docs != null && docs.size() > 0 ? docs[0] : null;
    }
    
    public override ExternalDocument[] retrieveDocuments(String project, String[] ids){
        imageSilo.setProjectByName(project);
        
        List<ImageSiloDocument> docs = new List<ImageSiloDocument>();
        for(String id : ids){
            docs.add( new ImageSiloDocument(imageSilo.loadDocuments(new Integer[]{Integer.valueOf(id)})[0]));
        }
        
        return docs; 
    }
    
    public override void deleteDocuments(String project, String[] ids){
        imageSilo.setProjectByName(project);
        List<Integer> docIds = new List<Integer>();
        for(String s : ids){
            docIds.add( Integer.valueOf(s) );
        }
        imageSilo.deleteDocuments(docIds);
    }
    
    public override void deleteDocument(String project, String id){ 
        imageSilo.setProjectByName(project);
        imageSilo.deleteDocument(Integer.valueOf(id));
    }
    
    public override DocumentRepository getRepository(String project){
        return getRepository(project, false);
    }
    
    public override DocumentRepository getRepository(String project, Boolean isTest){
        /*if( imageSilo.getCurrentProjectId() == null ){
            imageSilo.setProjectByName(project);
            return this; 
        }*/
        
        return new ImageSiloRepository(isTest);
    }
    
    @isTest(SeeAllData=true)
    public static void testIt(){
        ImageSiloRepository docRep = new ImageSiloRepository(true);
        docRep.storeDocument( Blob.valueOf('THIS IS TEST'), 'test.txt', -1, 'V3 TEST', 12345, DocumentStatus.READY, DocumentType.ATTACHMENT);
        docRep.setDocumentIndexes('V3 TEST', '97', 12345, DocumentStatus.READY, DocumentType.ATTACHMENT);
        docRep.getName();
        docRep.retrieveDocument('V3 TEST', '97');
        docRep.retrieveDocuments('V3 TEST', new String[]{'97'});
        docRep.deleteDocument('V3 TEST', '97');
        docRep.deleteDocuments('V3 TEST', new String[]{'97'});
        
    }

    public class ImageSiloDocument extends ExternalDocument {
        private ImageSilo.Document doc;
        public ImageSiloDocument(ImageSilo.Document d){
            super(d.id+'', d.project.name, NAME);
            doc = d;
        }
        
        public override String getFileName(){ return doc.fileName; }
        public override String getUrl(){ return doc.cacheUrl; }
        //public override Set<String> getPropertyNames(){ return doc.project.getIndexNames(); }
        //public override String getPropertyValue(String propertyName){ return doc.getPropertyValue(propertyName); } 
        public override Integer getFdcRebateNumber(){
            return Integer.valueOf( doc.getPropertyValue(IDX_FDCREBATENUMBER));
        }
        
        public override DocumentStatus getDocumentStatus(){
            return getDocumentStatus(doc.getPropertyValue(IDX_DOCUMENTSTATUS));
        }
        
        public override DocumentType getDocumentType(){
            return getDocumentType(doc.getPropertyValue(IDX_DOCUMENTTYPE));
        }
    }
    
}