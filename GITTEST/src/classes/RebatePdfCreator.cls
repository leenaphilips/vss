/*
    CEV:2012.09.12:: Creates a PDF of an existing saved rebate and uploads it to the document repository.  
    
    NOTE: The transaction that created the rebate must have been committed before invoking this class.  Since there is no
        explicit commit statements, this must be A) invoked manually, B) forwarded to by another action, C) wrapped in a webservice.
        Furthermore, workflows, triggers, and async (future) cannet render a page.
*/
public class RebatePdfCreator {

    //-- TO BE CHOSEN BY ACCOUNT/FORM
    private static final String TARGET_REPOSITORY = 'ImageSilo';
    private static final String TARGET_PROJECT = 'V3 TEST';
    private boolean isTest = false;
    
    public RebatePdfCreator(){ this(false); }
    public RebatePdfCreator(boolean isTest){
        this.isTest = isTest;
    }
    
    public PageReference createPdf(){
        
        String id = ApexPages.currentPage().getParameters().get('rebate_id');
        String url = ApexPages.currentPage().getParameters().get('return_url');
        
        Rebate__c r = loadRebate(id);
        saveApplication(r);
        
        PageReference retUrl = new PageReference(url);
        retUrl.getParameters().put('auth', r.hashCode__c);
        retUrl.setRedirect(true);
        return retUrl;
    }
    
    private void saveApplication(Rebate__c r){
     
        PageReference pdfRef = Page.RebateApplication;
        pdfRef.getParameters().put('id', r.id);
        pdfRef.setRedirect(false);
        
        Blob pdfBlob = pdfRef.getContentAsPdf();
        
        DocumentRepository docRep = DocumentRepository.findRepository(TARGET_REPOSITORY, TARGET_PROJECT, isTest);
        //- store the document in the repository
        String docId = docRep.storeDocument(pdfBlob, r.RebateNumber__c + ' APPLICATION.pdf', 0, TARGET_PROJECT, Integer.valueOf(r.RebateNumber__c), 
            r.EmailRequest__c ?  DocumentRepository.DocumentStatus.WAIT : DocumentRepository.DocumentStatus.READY, DocumentRepository.DocumentType.APPLICATION);

        insert new RebateDocument__c(Name = r.RebateNumber__c + ' APPLICATION', ExternalDocumentId__c = docId, 
            DocumentRepository__c = TARGET_REPOSITORY, RepositoryProject__c = TARGET_PROJECT, RebateId__c = r.Id, 
            Originator__c = 'Customer', OriginatorAgent__c = 'Customer', FileName__c = r.Name + ' APPLICATION');
    }
    
    private static Rebate__c loadRebate(ID rebateId){
        return [select id, HashCode__c, Name, EmailRequest__c, RebateNumber__c, MailingZipCode__c, FormCode__c FROM Rebate__c WHERE id = :rebateId][0];
    }
    
    /*
        This must be invoked with an existing rebate - one that is created outside of this transaction.  Not possible without hoops
    */
    @isTest(SeeAllData=true)
    public static void testId(){
        TestUtils u = new TestUtils();
        u.createRebate();
        
        PageReference p = Page.RebatePdfCreator;
        p.getParameters().put('rebate_id', u.rebate.id);
        p.getParameters().put('return_url', 'http://www.gooogle.com');
        
        Test.setCurrentPage(p);
        Test.startTest();
        
        RebatePdfCreator pdf = new RebatePdfCreator(true);
        pdf.createPdf();
        
    }
}