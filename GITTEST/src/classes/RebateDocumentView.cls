/*
    CEV:2012.08.30:: Controller to display a repository document in a VF page.  Uses dynamic VF to determine and generate the component for display on page.
*/
public class RebateDocumentView {
    
    private RebateDocument__c rebDoc;
    private ExternalDocument externalDoc;
    private ID rebateDocId;
    
    public RebateDocumentView(ApexPages.StandardController std){
        rebateDocId = std.getId();
    }
    
    public String getExternalUrl(){
        
        if( rebDoc == null ) loadRebateDocument();
        return externalDoc == null ? null : externalDoc.getUrl();
        
    }
    
    public String getExternalFileName(){ 
        if( rebDoc == null ) loadRebateDocument();
        return externalDoc == null ? null : externalDoc.getFileName();
    }
    
    public Component.Apex.OutputPanel getDocumentViewer(){
        if( rebDoc == null ) loadRebateDocument();
        ExternalDocumentViewer viewer = ExternalDocumentViewer.findViewer(externalDoc);
        return viewer == null ? null : viewer.displayDocument( externalDoc.getUrl() );
    } 
    
    private void loadRebateDocument(){
        rebDoc = [select id, DocumentRepository__c, RepositoryProject__c, ExternalDocumentId__c FROM RebateDocument__c WHERE id =: rebateDocId];
        
        if( rebDoc.DocumentRepository__c == null ) return;
        
        DocumentRepository docRep = DocumentRepository.findRepository(rebDoc.DocumentRepository__c, rebDoc.RepositoryProject__c);
        if( docRep == null ) return;
        
        externalDoc = docRep.retrieveDocument(rebDoc.RepositoryProject__c, rebDoc.ExternalDocumentId__c);
        
    }
    
    @isTest(SeeAllData=True)
    private static void testIt(){
        
        PageReference p = Page.RebateDocumentView;
        Test.setCurrentPageReference(p);
        
        RebateDocument__c doc = new RebateDocument__c(SessionId__c = 'ABC123', DocumentRepository__c = 'ImageSilo', RepositoryProject__c = 'V3 TEST', ExternalDocumentId__c = '200');
        insert doc;
        
        ApexPages.StandardController stdCon = new ApexPages.StandardController(doc);
        RebateDocumentView extCon = new RebateDocumentView(stdCon);
        
        extCon.getExternalUrl();
        extCon.getExternalFileName();
        extCon.getDocumentViewer();
    }

}