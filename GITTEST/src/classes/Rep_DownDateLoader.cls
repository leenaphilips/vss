public with sharing class Rep_DownDateLoader extends Rep_DateLoader {
    
    private Boolean isTest = false;
    public Rep_DownDateLoader(Boolean isTest){
        this.isTest = isTest;
    }
    public Rep_DownDateLoader(){ this(false); }
    
    public override void init(String clientCode){
        //String soql = 'SELECT ClientInvoiceDate__c from Rebate__c where FormId__r.AccountID__r.clientCode__c = \''+
        //    clientCode+'\' and ClientInvoiceDate__c <> null'+(isTest ? ' LIMIT 10' : '');
        
        String soql = 'SELECT ClientInvoiceDate__c from Rebate__c where FormId__r.AccountID__r.clientCode__c = \''+
            clientCode+'\' GROUP BY ClientInvoiceDate__c';
            
        init(soql, 'ClientInvoiceDate__c');
    } 
}