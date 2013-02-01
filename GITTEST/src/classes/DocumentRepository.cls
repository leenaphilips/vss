public abstract class DocumentRepository {
    
    public enum DocumentStatus { WAIT, READY, PROCESSED }
    
    public enum DocumentType { APPLICATION, ATTACHMENT, FOLLOWUP }
   
    public abstract String storeDocument(Blob data, String filename, Integer fileSize, String project, Integer fdcRebateNumber, DocumentStatus status, DocumentType type);
    
    public abstract boolean setDocumentIndexes(String project, String docId, Integer fdcRebateNumber, DocumentStatus status, DocumentType type);
        
    public abstract String getName();
    
    public abstract ExternalDocument retrieveDocument(String project, String id);
    
    public abstract ExternalDocument[] retrieveDocuments(String project, String[] ids);
    
    public abstract void deleteDocument(String project, String id);
    
    public abstract void deleteDocuments(String project, String[] ids);
    
    public abstract DocumentRepository getRepository(String project);
    
    public abstract DocumentRepository getRepository(String project, Boolean isTest);
    
    public String storeDocument(ExternalDocument doc, String project){
        
        Http h = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint(doc.getUrl()); 
        req.setMethod('GET');
        
        HttpResponse res = h.send(req);
        Blob data = res.getBodyAsBlob();
        
        return storeDocument(data, doc.getFileName(), 0, project, doc.getFdcRebateNumber(), doc.getDocumentStatus(), doc.getDocumentType());
    }
    
    protected String getBaseName(String filename){
        if( filename == null ) return null;
        String[] parts = filename.split('\\.');
        if( parts.size() > 0 ) return parts[0];
        return null;
    }
    
    protected String getSuffix(String filename){
        if( filename == null ) return null;
        String[] parts = filename.split('\\.');
        if( parts.size() > 1 ) return parts[parts.size() - 1];
        return null;
    }
    
    private static List<DocumentRepository> repositories;
   
    public static DocumentRepository findRepository(String name, String project){
        return findRepository(name, project, false);
    }
    
    public static DocumentRepository findRepository(String name, String project, Boolean isTest){
        
        if( repositories == null ){
            repositories = new List<DocumentRepository>{
                new ImageSiloRepository(isTest)
            };
        }
        
        for(DocumentRepository r : repositories){
            if( name.equalsIgnoreCase(r.getName()))
                return r.getRepository(project, isTest);
        }
        
        return null;
    }
    
}