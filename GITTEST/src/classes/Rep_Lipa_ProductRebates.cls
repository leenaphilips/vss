/*
 * 2012.05.31:CEV :: Switched queries to use inner loop for large result sets
 *
 */
public with sharing class Rep_Lipa_ProductRebates implements ICsvReport {

    public static final String NAME = 'rep_lipa_productrebates';
    private static final String CLIENT_CODE = 'LIPA';
    
    private Date InvoiceDate;
    private Integer InvoiceYear;
    private ReportDateHelper rdh;
    private boolean isTest = false; 
    
    public Rep_Lipa_ProductRebates(){ this(false); }
    
    public Rep_Lipa_ProductRebates(boolean test){
        isTest = test;
        rdh = new ReportDateHelper();   
    } 
    
    public String getReportName(){ return NAME; }
    
    public String getReportLabel(){ return 'ProductRebates'; }
    
    public ICsvReport cloneReport(Boolean isTest){ return new Rep_Lipa_ProductRebates(isTest); }
    
    //-- code is the Program (e.g. LIRF, LIDH)
    public Rep_ResultSet getResultSet(String code){
        
         //-- must have invoice date -- pick latest if none specified
        Date invoiceDate = rdh.getInvoiceDate();
        if( invoiceDate == null){
            Rep_DateLoader dp = new Rep_DownDateLoader();
            invoiceDate = dp.getMaxInvoiceDate(CLIENT_CODE);
        }
        
        System.debug('InvoiceDate: '+invoiceDate);
        if( invoiceDate == null ) return null;
        
        Map<String, ProductRebate> products = new Map<String,ProductRebate>();
        List<ProductRebate> productList = new List<ProductRebate>();
        Integer totalQty = 0;
        Double totalAmt = 0;
        
        Integer recLimit = isTest ? 10 : 1000000;
        for(RebateDetail__c[] details : [select Id, ModelNumber__c, Quantity__c, ExtRebateAmount__c, MeasureRebateAmount__c, MeasureCode__c
            FROM RebateDetail__c
            WHERE RebateID__r.FormId__r.PdoxProgramCode__c = :code AND RebateID__r.ClientInvoiceDate__c = :invoiceDate ORDER by ModelNumber__c LIMIT :recLimit])
        {
        	for(RebateDetail__c d : details){
	            ProductRebate product = products.get( d.ModelNumber__c );
	            if( product == null ){
	                products.put( d.ModelNumber__c, product = new ProductRebate(d.ModelNumber__c, d.MeasureCode__c));
	                product.measureAmount = d.MeasureRebateAmount__c != null ? d.MeasureRebateAmount__c : 0;
	                productList.add( product );
	            }
	            
	            product.quantity+= d.Quantity__c != null ? d.Quantity__c.intValue() : 1;
	            product.rebateAmount += d.ExtRebateAmount__c != null ? d.ExtRebateAmount__c : 0;
	            
	            totalQty += (d.Quantity__c != null ? d.Quantity__c.intValue() : 1);
	            totalAmt += (d.ExtRebateAmount__c != null ? d.ExtRebateAmount__c : 0);
        	}
        }
        
        System.debug('Building resultset');
        
        Rep_ResultSet results = new Rep_ResultSet();
        results.setColNames( new String[]{'Part #', 'Model #', 'Qty', 'Rebate', 'Total Rebate'} );
        for(ProductRebate pr : productList){
            results.addRow( new String[]{ pr.measureName, pr.productName, pr.quantity+'', pr.measureAmount+'', pr.rebateAmount+'' });
        }
        results.addRow( new String[]{'', 'TOTAL', totalQty+'', '', totalAmt+''});
        System.debug('Returning results');
        
        return results;
    }
    
    class ProductRebate{
        String productName;
        String measureName;
        Integer quantity;
        Double rebateAmount;
        Double measureAmount;
        
        public ProductRebate(String productName, String measureName){
            this.productName = productName;
            this.measureName = measureName;
            quantity = 0;
            rebateAmount = 0;
            measureAmount = 0;
        }
    }
}