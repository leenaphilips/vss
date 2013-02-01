public with sharing class Rep_Pse_Markdown implements ICsvReport {
	public static final String NAME = 'rep_pse_markdown';
	
    private ReportDateHelper rdh;
    private Map<String, MouRow> mouMap = new Map<String, MouRow>();
    private boolean isTest = false;
    
    public Rep_Pse_Markdown(){ this(false); }
    
    public Rep_Pse_Markdown(boolean test){
        isTest = test;
        rdh = new ReportDateHelper();
    }
    
    public String getReportName(){ return NAME; }
    
    public String getReportLabel(){ return 'CurrentMarkdownSummary'; }
    
    public ICsvReport cloneReport(Boolean isTest){ return new Rep_Pse_Markdown(isTest); }
    
    public Rep_ResultSet getResultSet(String formCode){
        
        //-- must have invoice date -- pick latest if none specified
        Date invoiceDate = rdh.getInvoiceDate();
        if( invoiceDate == null){
            Rep_DateLoader dp = new Rep_UpDateLoader(); 
            invoiceDate = dp.getMaxInvoiceDate('PSE');
        }
        
        if( invoiceDate == null ) return null;
        
        //if( data == null ) return null;
        Integer recLimit = isTest ? 10 : 1000000;
        for(UpstreamRebate__c r : [ SELECT MouNumber__c, MouName__c, TotalRebateAmount__c, SalesStartDate__c, SalesEndDate__c, ReceivedDate__c
                                    FROM UpstreamRebate__c
                                    WHERE InvoiceDate__c = :invoiceDate and clientCode__c = 'PSE' LIMIT :recLimit]){
            MouRow row = mouMap.get(r.MouNumber__c);
            
            if( row == null ){
                row = new MouRow();
                row.MouNumber = r.MouNumber__c;
                row.MouName = r.MouName__c;
                row.InvoiceAmount = r.TotalRebateAmount__c;
                row.MinSalesDate = r.SalesStartDate__c;
                row.MaxSalesDate = r.SalesEndDate__c;
                row.ReceivedDate = r.ReceivedDate__c;
                mouMap.put( row.MouNumber, row );
            } else {
                row.InvoiceAmount += r.TotalRebateAmount__c;
                if( r.SalesStartDate__c != null && r.SalesStartDate__c < row.MinSalesDate)
                    row.MinSalesDate = r.SalesStartdate__c;
                if( r.SalesEndDate__c != null && r.SalesEndDate__c > row.MaxSalesDate)
                    row.MaxSalesDate = r.SalesEndDate__c;
                if( r.ReceivedDate__c != null && r.ReceivedDate__c > row.ReceivedDate)
                    row.receivedDate = r.ReceivedDate__c;
            }
            
        }
        
        List<String> mouNumbers = new List<String>();
        mouNumbers.addAll( mouMap.keySet() );
        mouNumbers.sort();
        
        Rep_ResultSet rs = new Rep_ResultSet();
        rs.setColNames( new String[]{'Mou Number','Mou Name','Pct','Amount Reported','Invoiced & Paid','Min Sales Date','Max Sales Date','Max Rec\'d Date'} );
        
        for(String mouNumber : mouNumbers){
            MouRow m = mouMap.get(mouNumber);
            rs.addRow( new String[]{m.MouNumber,m.MouName,'100',m.getInvoiceAmountStr(), m.getInvoiceAmountStr(), m.getMinSalesDateStr(), m.getMaxSalesDateStr(), m.getReceivedDateStr()} );
        }
        
        return rs;
    }
    
}