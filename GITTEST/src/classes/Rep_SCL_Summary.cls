/*
 * 2012.05.31:CEV :: Switched queries to use inner loop for large result sets
 				  :: Added Missing MeasureID__r.MeaureCode__c field in query
 *
 */
public with sharing class Rep_SCL_Summary implements ICsvReport {

    public static final String NAME = 'rep_scl_summary';
    private static final String CLIENT_CODE = 'SCL';
    
    private Boolean isTest = false;
    private ReportDateHelper rdh = new ReportDateHelper();
    
    public Rep_SCL_Summary(){ this(false); }
    
    public Rep_SCL_Summary(boolean test){
        isTest = test;
    }

    public String getReportName(){ return NAME; }
    
    public String getReportLabel(){ return 'Billing'; } 
    
    public ICsvReport cloneReport(Boolean isTest){ return new Rep_SCL_Summary(isTest); }
    
    //-- the code passed in represents the PDX Program Code (e.g. LIRF, LIDH)
    public Rep_ResultSet getResultSet(String code){
        Map<String, RebateMeasure> incentives = new Map<String, RebateMeasure>();
        
        //-- must have invoice date -- pick latest if none specified
        Date invoiceDate = rdh.getInvoiceDate();
        if( invoiceDate == null){
            Rep_DateLoader dp = new Rep_UpDateLoader();
            invoiceDate = dp.getMaxInvoiceDate(CLIENT_CODE);
        }
        
        if( invoiceDate == null ) return null;
        
        Integer totalQty = 0;
        Double totalAmt = 0;
        
        Integer recLimit = isTest ? 10 : 1000000;
        for(RebateDetail__c[] details : [select Id, MeasureCode__c,  Quantity__c, ExtRebateAmount__c, MeasureID__r.RebateAmount__c, MeasureID__r.MeasureCode__c, MeasureID__r.MeasureDescription__c, MeasureRebateAmount__c 
            from RebateDetail__c 
            where RebateId__r.FormId__r.PdoxProgramCode__c = :code AND RebateId__r.ClientInvoiceDate__c = : invoiceDate LIMIT :recLimit]){
 
 			for(RebateDetail__c d : details){
	            RebateMeasure rm = null;
	            
	            if( (rm = incentives.get( d.MeasureCode__c)) == null){
	                incentives.put(d.MeasureCode__c, rm = new RebateMeasure());
	                Measure__c m = d.MeasureID__r;
	                rm.totalAmount = 0;
	                rm.quantity = 0;
	                rm.measureName = m != null ? m.MeasureCode__c : d.MeasureCode__c;
	                rm.measureAmount = m != null ? m.RebateAmount__c : d.MeasureRebateAmount__c;
	                rm.description = m != null ? m.MeasureDescription__c : d.MeasureCode__c;
	            }
	            
	            totalAmt += d.ExtRebateAmount__c != null ? d.ExtRebateAmount__c : 0;
	            totalQty += d.Quantity__c != null ? d.Quantity__c.intValue() : 1;
	            
	            rm.totalAmount += d.ExtRebateAmount__c != null ? d.ExtRebateAmount__c : 0;
	            rm.quantity++;
 			}
        }
        
        Rep_ResultSet results = new Rep_ResultSet();
        Rep_Section s = new Rep_Section();
        results.addSection(s);
        
        s.setColNames( new String[]{'Part #', 'Description', 'Quantity', 'Rebate', 'Total Rebate'}, true);
        for(RebateMeasure rm : incentives.values()){
            s.addRow( new String[]{rm.measureName, rm.description, rm.quantity+'', rm.measureAmount+'', rm.totalAmount+''} );
        }
        s.addRow( new String[]{'','TOTAL', totalQty+'', '', totalAmt+''});
        
        Rep_Section billing = new Rep_Section();
        results.addSection(billing);
        
        billing.sectionName = 'Billing';
        billing.setColNames( new String[]{'','','',''}, false );
        
        double totalAmount = 0;
        for(RebateMeasure rm : incentives.values()){
            billing.addRow( new String[]{'REBMA', 'Rebate Amount', rm.quantity+'', rm.totalAmount+''});
            billing.addRow( new String[]{'PF1', 'Processing Fee', rm.quantity+' * 3.75', (rm.quantity * 3.75)+''} );
            billing.addRow( new String[]{'PF2', 'Processing Fee', rm.totalAmount+' * 1%', (rm.totalAmount * 0.01)+''});
            billing.addRow( new String[]{} );
            
            totalAmount += (rm.totalAmount + (rm.quantity * 3.75) + (rm.totalAmount * 0.01));
        }
        
        if( totalAmount > 0 ){
            billing.addRow( new String[]{'','','TOTAL', totalAmount+''});
        }
        
        return results;
    }
    
    class RebateMeasure{
        Integer quantity;
        Double totalAmount;
        Double measureAmount;
        String measureName;
        String description;
    }
}