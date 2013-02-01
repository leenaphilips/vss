public class RebateView {

    public ID rebateDocumentId {get; set;}
    
    private Map<String, RebateDocumentItem> rebateDocuments = new Map<String, RebateDocumentItem>();
    private ID rebateId;
    private boolean isTest = false;
    
    public RebateView(ApexPages.StandardController std){
        rebateId = std.getId();
    }
    
    public List<RebateDocumentItem> getRebateDocumentList(){
        
        List<RebateDocument__c> rebateDocs = [select id, DocumentRepository__c, RepositoryProject__c, ExternalDocumentId__c, FileSize__c, FileName__c FROM RebateDocument__c WHERE RebateId__c =: rebateId];
        if( rebateDocs == null ) return null;
        
        rebateDocuments.clear();
        for(RebateDocument__c rd : rebateDocs){
            RebateDocumentItem i = new RebateDocumentItem();
            i.RebateDocumentId = rd.id;
            i.repository = rd.DocumentRepository__c;
            i.project = rd.RepositoryProject__c;
            i.externalId = rd.ExternalDocumentId__c;
            i.originalFileName = rd.FileName__c;
            i.fileSize = Utils.binaryToHuman(rd.FileSize__c);
            
            rebateDocuments.put(i.RebateDocumentId, i);
        }
        
        return rebateDocuments.values();
    }
    
    //--Should be handled by trigger but currently not supported
    public PageReference deleteRecord(){
        rebateDocumentId = ApexPages.currentPage().getParameters().get('rebateDocumentId');
        if( rebateDocumentId == null ) return null;
        
        RebateDocument__c[] docs = [select id, DocumentRepository__c, RepositoryProject__c, ExternalDocumentId__c FROM RebateDocument__c WHERE id =: rebateDocumentId];
        if( docs == null ) return null;
        
        RebateDocument__c d = docs[0];
        DocumentRepository docRep = DocumentRepository.findRepository(d.DocumentRepository__c, d.RepositoryProject__c, isTest);
        if( docRep != null ){
            docRep.deleteDocument(d.RepositoryProject__c, d.ExternalDocumentId__c);
        }
        delete d;
        
        //delete new RebateDocument__c(id = rebateDocumentId);
        return null;
    }
    
    public PageReference viewLink(){
        rebateDocumentId = ApexPages.currentPage().getParameters().get('rebateDocumentId');
        if( rebateDocumentId == null ) return null;
        
        RebateDocumentItem item = rebateDocuments.get(rebateDocumentId);
        DocumentRepository docRep = DocumentRepository.findRepository(item.repository, item.project, isTest);
        
        if( docRep == null ) return null;
        ExternalDocument doc = docRep.retrieveDocument(item.project, item.externalId);
        if( doc == null ) return null;
        return new PageReference(doc.getUrl());
    }

    @isTest(SeeAllData=true)
    public static void testIt(){
        PageReference p = Page.RebateView;
        
        TestUtils u = new TestUtils();
        u.createRebate();
        
        ApexPages.StandardController sc = new ApexPages.standardController(u.rebate);
        RebateView v = new RebateView(sc);
        v.isTest = true;
        
        v.getRebateDocumentList();
        
        p.getParameters().put('rebateDocumentId', u.documents[0].id);
        Test.setCurrentPage(p);
        v.viewLink();
        
        v.deleteRecord();
        
        
        
    }
    
    public class RebateDocumentItem {
        public ID RebateDocumentId {get; set;}
        public String repository {get; set;}
        public String project {get; set;}
        public String externalId {get; set;}
        public String originalFileName {get; set;}
        public String externalFileName {get; set;}
        public String fileSize {get; set;}
        public String url {get; set;}
        public String getExternalUid(){ return repository+':'+project+':'+externalId; }
    }
}