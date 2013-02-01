public class ImageSilo {
    
    public String XmlRequest {
        get { return isc.XmlRequest; }
        private set;
    }
    
    public String XmlResponse {
        get { return isc.XmlResponse; }
        private set;
    }
    
    private ImageSiloConnector isc;
    private Map<Integer, ImageSilo.Project> projects = new Map<Integer, ImageSilo.Project>();
    private Map<String, ImageSilo.Project> projectNames = new Map<String, ImageSilo.Project>();
    private Integer projectId;
    
    public ImageSilo(String username, String password){
        this(username, password, false);
    }
    
    public ImageSilo(String username, String password, boolean isTest) {
        System.debug('IS_TEST: '+isTest);
        isc = new ImageSiloConnector(isTest);
        isc.login(username, password);
    }
    
    public ImageSilo.Project[] getAllProjects(){
        loadAllProjects();
        return projects.values();
    }
    
    public void setProjectById(Integer projectId){
        loadAllProjects();
        
        if( !projects.containsKey(projectId) ) throw new ImageSiloException('Unknown projectId "'+projectId+'"');
        this.projectId = projectId;
    }
    
    public void setProjectByName(String name){
        loadAllProjects();
        
        if( !projectNames.containsKey(name) ) throw new ImageSiloException('Unknown project  "'+name+'"');
        this.projectId = projectNames.get(name).id;
    }
    
    public Integer getCurrentProjectId(){ return this.projectId; }
    
    public ImageSilo.Project getCurrentProject(){ return projects.containsKey(this.projectId) ? projects.get(this.projectId) : null; }

    public ImageSilo.Document[] searchForDocuments(Map<Integer, String> searchParams){
        
        if( projectId == null ) throw new ImageSiloException('You must select a project');
        
        Map<String, String> nameParams = new Map<String, String>();
        for(Integer i : searchParams.keySet()){
            nameParams.put( projects.get(projectId).getIndex(i).name, searchParams.get(i));
        }
        
        return searchForDocuments(nameParams);
    }
    
    public ImageSilo.Document[] searchForDocuments(Map<String, String> searchParams){
        
        if( projectId == null ) throw new ImageSiloException('You must select a project');
        
        if( !isc.submitSearchCriteria(projectId, searchParams))
            throw new ImageSiloException('Unable to perform search');
        
        List<Document> docs = new List<Document>();
        for(ImageSiloConnector.Document iscDoc : isc.executeQuery(projectId)){
            docs.add( buildDoc(iscDoc) );
        }
        return docs;
    }
    
    public ImageSilo.Document loadDocument(Integer docId){
        Document[] docs = loadDocuments(new Integer[]{docId});
        return docs != null && docs.size() > 0 ? docs[0] : null;
    }
    
    public ImageSilo.Document[] loadDocuments(Integer[] documentIds){
        
        if( projectId == null ) throw new ImageSiloException('You must select a project');
        
        ImageSiloConnector.Document[] iscDocs = isc.loadDocumentInfo(projectId, documentIds);
        if( iscDocs == null ) return null;
        
        List<Document> docs = new List<Document>();
        for(ImageSiloConnector.Document iscDoc : iscDocs){
            docs.add( buildDoc(iscDoc));
        }
        return docs;
    }
    
    public Blob downloadDocument(Integer documentId){
        
        ImageSilo.Document doc = loadDocument(documentId);
        
        HttpRequest req = new HttpRequest();
        req.setEndpoint(doc.cacheUrl);
        req.setMethod('GET');
        
        Http h = new Http();
        HttpResponse res = h.send(req);
        return res.getBodyAsBlob();
    }
    
    public Integer uploadDocument(String filename, Blob data){ return uploadDocument(filename, data, null); }
    
    public Integer uploadDocument(String filename, Blob data, Map<String, String> indexes){
        
        if( projectId == null ) throw new ImageSiloException('You must select a project');
        
        if( indexes != null ){
            for(String key : indexes.keySet()){
                if( !projects.get(projectId).containsIndex(key) )
                    throw new ImageSiloException('Index "'+key+'" is not a valid index for project "'+projects.get(projectId).name+'"');
            }
        }       
        
        return isc.uploadDocument(fileName, data, projectId, indexes);
    }
    
    public void updateDocumentIndexes(Integer docId, Map<String, String> indexes){
        isc.setDocumentIndexes(projectId, new Integer[]{docId}, indexes);
    }
    
    public void deleteDocument(Integer documentId){
        isc.deleteDocuments(projectId, new Integer[]{documentId});
    }
    
    public void deleteDocuments(Integer[] documentIds){
        isc.deleteDocuments(projectId, documentIds);
    }
    
    private Document buildDoc(ImageSiloConnector.Document iscDoc){
        ImageSilo.Document isDoc = new ImageSilo.Document(iscDoc.id, projects.get(projectId));
        isDoc.cacheUrl = iscDoc.cacheUrl;
        isDoc.fileName = iscDoc.fileName;
        for(Integer i =0; i < iscDoc.propertyValues.size(); i++){
            isDoc.setProperty(i, iscDoc.propertyValues[i]);
        }
        return isDoc;
    }
    
    private void loadAllProjects(){ loadAllProjects(false); }
    
    private void loadAllProjects(boolean force){
        
        if( force || projects.size() == 0 ){
            projects.clear();
            ImageSiloConnector.Project[] projectList = isc.getProjects();
            if( projectList != null ){
                for(ImageSiloConnector.Project cProject : projectList){
                    
                    Project isProject = new Project(cProject.id, cProject.name);
                    for(Integer seq=0; seq < cProject.indexes.size(); seq++){
                        isProject.setIndex( new Index(seq, cProject.indexes[seq]));
                    }
                    projects.put(isProject.id, isProject);
                    projectNames.put(isProject.name, isProject);
                }
            }
        }
    }
    
    @isTest(SeeAllData=True)
    public static void testIt(){
        ImageSilo is = new ImageSilo('cvitone', 'Fr1end', true);
        is.getAllProjects();
        is.setProjectById(5);
        is.setProjectByName('V3 TEST');
        is.getCurrentProjectId();
        is.getCurrentProject();
        is.searchForDocuments( new Map<Integer, String>() );
        is.searchForDocuments( new  Map<String, String>() );
        is.loadDocuments(new Integer[]{97});
        is.loadDocument(97);
        is.uploadDocument('test.txt', Blob.valueOf('THIS IS A TEST'));
        is.updateDocumentIndexes(97, new Map<String, String>{ 'TESTA' => 'TESTB' });
        is.deleteDocument(97);
        is.deleteDocuments( new Integer[]{97} );
        
        /*
        is.downloadDocument(97);
        */
    }
    
//-- INTERNAL CLASSES

    public class ImageSiloException extends Exception {}

    public class Project {
        public String name {get; set;}
        public Integer id {get; set;}
        private Map<Integer, Index> indexes = new Map<Integer, Index>();
        private Map<String, Index> nameIndexes = new Map<String, Index>();
        
        public Project(Integer id, String name){ 
            this.id = id; 
            this.name = name;
        }
        
        public void removeIndex(Integer sequence){
            if( !indexes.containsKey(sequence)) return;
            nameIndexes.remove( indexes.get(sequence).name );
            indexes.remove(sequence);
        }
        
        public void setIndex(Index i){
            removeIndex(i.sequence);
            indexes.put(i.sequence, i);
            nameIndexes.put(i.name, i);
        }
        
        public Index getIndex(Integer sequence){ return indexes.get(sequence); }
        
        public Index getIndex(String name){ return nameIndexes.get(name); }
        
        public boolean containsIndex(Integer sequence){ return indexes.containsKey(sequence);}
        
        public boolean containsIndex(String name){ return nameIndexes.containsKey(name); }
        
        public Set<String> getIndexNames(){ return nameIndexes.keySet(); }
        
   }   
    
    public class Document {
        public Integer id {get; set; }
        public String cacheUrl {get; set;}
        public Project project {get; private set;}
        public String fileName {get; set;}
        
        private Map<Integer, String> properties = new Map<Integer, String>();

        public Document(Integer id, Project project){
            this.id = id;
            this.project = project;
       }
       
        public void setProperty(Integer indexSequence, String value){
            if( !project.containsIndex(indexSequence))
                throw new ImageSiloException('Project "'+project.name+'" does not have an index with sequence "'+indexSequence+'"');
            
            properties.put(indexSequence, value);
        }
        
        public void setProperty(String name, String value){
            if( !project.containsIndex(name))
                throw new ImageSiloException('Project "'+project.name+'" does not have an index named "'+name+'"');
                
            properties.put( project.getIndex(name).sequence, value);
        }
        
        public String getPropertyValue(String name){ return properties.get( project.getIndex(name).sequence ); }
    }
   
    public class Index {
        public Integer sequence {get; set;}
        public String name {get; set; }
     
        public Index(Integer sequence, String name){
            this.sequence = sequence;
            this.name = name;
        }
    }
}