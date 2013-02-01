public with sharing class Rep_Pse_SalesByPart implements ICsvReport {
    public static final String NAME = 'rep_pse_salesbypart';
    
    private ReportDateHelper rdh;
    private boolean isTest = false;
    
    public Rep_Pse_SalesByPart(){ this(false); }
    
    public Rep_Pse_SalesByPart(boolean test){
        rdh = new ReportDateHelper();   
        isTest = test;
    }
    
    public String getReportName(){ return NAME; }
    
    public String getReportLabel(){ return 'YtdSalesByParentId'; }
    
    public ICsvReport cloneReport(Boolean isTest){ return new Rep_Pse_SalesByPart(isTest); }
    
    public Rep_ResultSet getResultSet(String formCode){
        //-- must have invoice date -- pick latest if none specified
        Date invoiceDate = rdh.getInvoiceDate();
        if( invoiceDate == null){
            Rep_DateLoader dp = new Rep_UpDateLoader();
            invoiceDate = dp.getMaxInvoiceDate('PSE');
        }
         
        if( invoiceDate == null ) return null;
        /*
        List<UpstreamRebateDetail__c> details = [select UpstreamRebateID__r.ParentId__c, PartNumber__c, Category__c, PartDescription__c, TotalItems__c, IncentiveAmount__c
                FROM UpstreamRebateDetail__c WHERE UpstreamRebateID__r.InvoiceDate__c = :invoiceDate];
        } else if(rdh.hasYear()){
            details = [select UpstreamRebateID__r.ParentId__c, PartNumber__c, Category__c, PartDescription__c, TotalItems__c, IncentiveAmount__c
                FROM UpstreamRebateDetail__c 
                WHERE UpstreamRebateID__r.InvoiceDate__c >= :rdh.getMinDate() AND UpstreamRebateID__r.InvoiceDate__c <= :rdh.getMaxDate() LIMIT 5000];
        } else {
            details = [select UpstreamRebateID__r.ParentId__c, PartNumber__c, Category__c, PartDescription__c, TotalItems__c, IncentiveAmount__c
                FROM UpstreamRebateDetail__c];
        }*/
        
        Map<String, URDRow> rows = new Map<String, URDRow>();
        MapList rowsByParent = new MapList();
        Integer recLimit = isTest ? 10 : 1000000;
        for(UpstreamRebateDetail__c d : [   SELECT UpstreamRebateID__r.ParentId__c, PartNumber__c, Category__c, PartDescription__c, TotalItems__c, IncentiveAmount__c
                                            FROM UpstreamRebateDetail__c 
                                            WHERE UpstreamRebateID__r.InvoiceDate__c = :invoiceDate LIMIT :recLimit]){
            URDRow r = rows.get(d.PartNumber__c);
            if( r == null ){
                r = new URDRow();
                r.ParentId = d.UpstreamRebateID__r.ParentId__c;
                r.PartNum = d.PartNumber__c;
                r.Cat = d.Category__c;
                r.PartDescription = d.PartDescription__c;
                rows.put(r.PartNum, r);
                rowsByParent.addObject(r.ParentId, r);
            } 
            
            r.addQuantity( Integer.valueOf(d.TotalItems__c) );
            r.addSalesAmount( d.IncentiveAmount__c ); 
            
        }
        
        List<String> sorted = new List<String>();
        sorted.addAll( rowsByParent.keySet() );
        sorted.sort();
        
        Rep_ResultSet rs = new Rep_ResultSet();
        rs.setColNames( new String[]{'Parent ID','SKU','Product Cat','Product Type','Sales','Quantity'} );
        
        for(String parentId : sorted){
            for(Object o : rowsByParent.get(parentId)){
                URDRow r = (URDRow)o;
                rs.addRow( new String[]{r.ParentID, r.PartNum, r.Cat, r.PartDescription, r.getSalesAmount(),r.Quantity+''} );
            }
        }
        
        return rs;
    }
}