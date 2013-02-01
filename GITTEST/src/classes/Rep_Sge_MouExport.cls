public with sharing class Rep_Sge_MouExport implements ICsvReport {
    public static final String NAME = 'rep_sge_mouexport';
    
    private ReportDateHelper rdh;
    private Boolean isTest = false;
    
    public Rep_Sge_MouExport(){
        this(false);
    }
    
    public Rep_Sge_MouExport(boolean test){
        rdh = new ReportDateHelper();
    }
    
    public String getReportName(){ return NAME; }
    
    public String getReportLabel(){ return 'InvoiceSubmissionTimeFrameSummary'; }
    
    public ICsvReport cloneReport(Boolean isTest){ return new Rep_Sge_MouExport(isTest); }
    
    public Rep_ResultSet getResultSet(String formCode){
        
        //-- must have invoice date -- pick latest if none specified
        Date invoiceDate = rdh.getInvoiceDate();
        if( invoiceDate == null){
            Rep_DateLoader dp = new Rep_UpDateLoader();
            invoiceDate = dp.getMaxInvoiceDate('SGE');
        }
        
        if( invoiceDate == null ) return null;
        
        //List<UpstreamRebate__c> data = [Select MouNumber__c, MouName__c, ReceivedDate__c, SalesStartDate__c, SalesEndDate__c, InvoiceDate__c
        //      FROM UpstreamRebate__c where InvoiceDate__c = :invoiceDate];
        
        
        Map<String, MouRow> rows = new Map<String, MouRow>();
        Integer recLimit = isTest ? 10 : 1000000;
        for(UpstreamRebate__c r : [ Select MouNumber__c, MouName__c, ReceivedDate__c, SalesStartDate__c, SalesEndDate__c, InvoiceDate__c
                                    FROM UpstreamRebate__c 
                                    WHERE InvoiceDate__c = :invoiceDate LIMIT :recLimit]){
            MouRow row = rows.get(r.MouNumber__c);
            if( row == null ){
                row = new MouRow();
                row.MouNumber = r.MouNumber__c;
                row.MouName = r.MouName__c;
                row.MaxSalesDate = r.SalesEndDate__c;
                row.MinSalesDate = r.SalesStartDate__c;
                row.ReceivedDate = r.ReceivedDate__c;
                row.InvoiceDate = r.InvoiceDate__c; 
                rows.put(row.MouNumber, row);
            } else {
                if( r.ReceivedDate__c > row.ReceivedDate)
                    row.ReceivedDate = r.ReceivedDate__c;
                if( r.SalesStartDate__c > row.MinSalesDate)
                    row.MinSalesDate = r.SalesStartDate__c;
                if( r.SalesEndDate__c > row.MaxSalesDate)
                    row.MaxSalesDate = r.SalesEndDate__c;
                if( r.InvoiceDate__c > row.InvoiceDate)
                    row.InvoiceDate = r.InvoiceDate__c;
            }
            
            
        }
        
        List<String> sorted = new List<String>();
        sorted.addAll(rows.keySet());
        sorted.sort();
        
        
        Rep_ResultSet rs = new Rep_ResultSet();
        rs.setColNames( new String[]{'Mou Number','Mou Name','Last Received Date','Last Sales Start Date','Last Sales End Date','Days Since Last Submission','Days Since Last Sale End','Invoice Date'});
        rs.reportName = '';
        for(String key : sorted){
        	MouRow r = rows.get(key);
        	rs.addRow( new String[]{r.MouNumber,r.MouName,r.getReceivedDateStr(),r.getMinSalesDateStr(),r.getMaxSalesDateStr(),r.getDaysSinceReceived()+'',r.getDaysSinceSaleEnd()+'',r.getInvoiceDateStr()} );
        }
            
        return rs;
    }
    
}