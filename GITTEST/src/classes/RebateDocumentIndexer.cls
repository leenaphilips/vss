/*
    CEV:2012.08.30::Sets the rebate number as an index in the document repository for all documents associated w/ the specified rebate.
        This is required as a second class AND an @future because FDC does not allow for callouts after DML
*/
public class RebateDocumentIndexer {

    //-- TO BE CHOSEN BY ACCOUNT/FORM
    private static final String TARGET_REPOSITORY = 'ImageSilo';
    private static final String TARGET_PROJECT = 'V3 TEST';
    
    @future (callout=true)
    public static void setIndexes(ID rebateId){
    
        DocumentRepository docRep = DocumentRepository.findRepository(TARGET_REPOSITORY, TARGET_PROJECT);
        Rebate__c r = [select EmailRequest__c, RebateNumber__c FROM Rebate__c WHERE id = :rebateId][0];
        RebateDocument__c[] docs = [select id, DocumentRepository__c, RepositoryProject__c, ExternalDocumentId__c FROM RebateDocument__c WHERE RebateId__c =: rebateId];
        
        if( docs != null ){
            for(RebateDocument__c d : docs){
                docRep.setDocumentIndexes(d.RepositoryProject__c, d.ExternalDocumentId__c, Integer.valueOf(r.RebateNumber__c), 
                    r.EmailRequest__c ? DocumentRepository.DocumentStatus.WAIT : DocumentRepository.DocumentStatus.READY, DocumentRepository.DocumentType.ATTACHMENT);
            }
        } 
        
    }
    
}