public abstract class ExternalDocument {
    private String id;
    private String project; 
    private String repository;
    
    protected ExternalDocument(String id, String project, String repository){
        this.id = id;
        this.project = project;
        this.repository = repository;
    }
    
    public String getDocumentId(){ return id; }
    public String getProject(){ return project; }
    public String getRepositoryName(){ return repository; }
    
    public abstract String getFileName();
    public abstract String getUrl();
    public abstract Integer getFdcRebateNumber();
    public abstract DocumentRepository.DocumentType getDocumentType();
    public abstract DocumentRepository.DocumentStatus getDocumentStatus();
    //public abstract Set<String> getPropertyNames(); 
    //public abstract String getPropertyValue(String name);
    
    protected DocumentRepository.DocumentType getDocumentType(String value){
    	for(DocumentRepository.DocumentType t : DocumentRepository.DocumentType.values()){
    		if( t.name().equalsIgnoreCase(value)) return t;
    	}
    	return null;
    }
    
    protected DocumentRepository.DocumentStatus getDocumentStatus(String value){
    	for(DocumentRepository.DocumentStatus s : DocumentRepository.DocumentStatus.values()){
    		if( s.name().equalsIgnoreCase(value)) return s;
    	}
    	return null;
    }    
    
    public String getFileSuffix(){ 
        String filename = getFileName();
        if( filename == null ) return null;
        String[] parts = filename.split('\\.');
        if( parts.size() > 1 ) return parts[parts.size() - 1];
        return null;            
    }
    
}