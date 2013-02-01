public with sharing class Rep_UpDateLoader extends Rep_DateLoader {
    
    private Boolean isTest = false;
    
    public Rep_UpDateLoader(Boolean isTest){ 
    	System.debug('Init UpdateLoader');
    	this.isTest = isTest; 
    }
    public Rep_UpDateLoader(){ this(false); }
    
    public override void init(String clientCode){
    	System.debug('Loading InvoiceDates for Upstream Client Code '+clientCode);
        String soql = 'SELECT InvoiceDate__c from UpstreamRebate__c where clientCode__c = \''+
            clientCode+'\' GROUP BY InvoiceDate__c';
        init(soql, 'InvoiceDate__c');
    }
    
}