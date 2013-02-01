public with sharing class Rep_Pse_RebatesByInvoice implements ICsvReport{

	public static final String NAME = 'rep_pse_rebatesbyinvoice';
	
    private Date InvoiceDate;
    private Integer InvoiceYear;
    private ReportDateHelper rdh;
    private boolean isTest = false;
    
    public Rep_Pse_RebatesByInvoice(){ this(false); }
    
    public Rep_Pse_RebatesByInvoice(boolean test){
        isTest = test;
        rdh = new ReportDateHelper();   
    } 
    
    public String getReportName(){ return NAME; }
    
    public String getReportLabel(){ return 'RebatesByInvoice'; }
    
    public ICsvReport cloneReport(Boolean isTest){ return new Rep_Pse_RebatesByInvoice(isTest); }
    
    //-- returns all rows in the data set.  Summary rows are "faked" 
    public Rep_ResultSet getResultSet(String formCode){
    	
    	//-- must have invoice date -- pick latest if none specified
        Date invoiceDate = rdh.getInvoiceDate();
        if( invoiceDate == null){
            Rep_DateLoader dp = new Rep_UpDateLoader();
            invoiceDate = dp.getMaxInvoiceDate('PSE');
        }
        
        if( invoiceDate == null ) return null;
        
        Rep_ResultSet results = new Rep_ResultSet();
        results.setColNames( new Rep_ColumnFormatter[]{
        	new Rep_StringCol('Parent ID'),
        	new Rep_StringCol('Store ID'),
        	new Rep_StringCol('Store Name'),
        	new Rep_StringCol('Store ID'),
        	new Rep_StringCol('Store Address'),
        	new Rep_StringCol('Store City'),
        	new Rep_StringCol('Store State'),
        	new Rep_StringCol('Store Zipcode'),
        	new Rep_NumberCol('Vendor Rec Number', true),
        	new Rep_StringCol('Order Number'),
        	new Rep_StringCol('Store ID'),
        	new Rep_DateCol('Submitted Date', false),
        	new Rep_StringCol('Incentive Type'),
        	new Rep_NumberCol('Measure ID', true),
        	new Rep_StringCol('Measure Name'),
        	new Rep_StringCol('MOU'),
        	new Rep_StringCol('Partner'),
        	new Rep_StringCol('SKU'),
        	new Rep_NumberCol('Quantity', true),
        	new Rep_CurrencyCol('Incentive Amount'),
        	new Rep_StringCol('Invoice Number'),
        	new Rep_StringCol('Product Cat'),
        	new Rep_StringCol('Product Type'),
        	new Rep_NumberCol('Product Wattage', true),
        	new Rep_NumberCol('Product Replaced Wattage', true),
        	new Rep_StringCol('Product Feature'),
        	new Rep_StringCol('Model Number'),
        	new Rep_DateCol('Sales Period Begin Date', false),
        	new Rep_DateCol('Sales Period End Date', false),
        	new Rep_NumberCol('Units Per Pack', true),
        	new Rep_CurrencyCol('Incentive Per Unit'),
        	new Rep_NumberCol('Total Packs', true)
        });
        
        Integer recLimit = isTest ? 10 : 1000000;
        for(List<UpstreamRebateDetail__c> rebateDetails : 
        	[select UpstreamRebateId__r.ParentId__c, UpstreamRebateId__r.StoreId__c, UpstreamRebateId__r.StoreName__c, 
        	UpstreamRebateId__r.StoreAddress1__c, UpstreamRebateId__r.StoreCity__c, UpstreamRebateId__r.StoreState__c, 
        	 UpstreamRebateId__r.StoreZipcode__c, UpstreamRebateId__r.SalesStartDate__c, UpstreamRebateId__r.SalesEndDate__c, 
        	 UpstreamRebateId__r.MOUNumber__c, UpstreamRebateId__r.LegacyRebateNumber__c,UpstreamRebateId__r.PostmarkDate__c,
        	 UpstreamRebateId__r.poNumber__c,
        	ClientIncentiveType__c, ClienMeasureId__c, ClientMeasureName__c, Partner__c, Quantity__c, IncentiveAmount__c, ClientSubCategory__c, Category__c, Wattage__c, 
        	ReplacedWattage__c, PackSize__c, UnitRebate__c, TotalItems__c, PartNumber__c
    		FROM UpstreamRebateDetail__c
    		WHERE UpstreamRebateId__r.ClientCode__c = 'PSE' AND UpstreamRebateId__r.InvoiceDate__c = :invoiceDate
    		ORDER BY UpstreamRebateId__r.LegacyRebateNumber__c ASC LIMIT :recLimit]){
    			
    			for(UpstreamRebateDetail__c rd : rebateDetails){
    				UpstreamRebate__c r = rd.UpstreamRebateId__r;
    				
    				results.addRow( new Object[]{
    					r.parentId__c, r.storeId__c, r.storeName__c, r.storeId__c, r.storeAddress1__c, r.storeCity__c, r.storeState__c,
    					r.storeZipcode__c, r.legacyRebateNumber__c, r.poNumber__c, r.storeId__c, r.postmarkDate__c, rd.clientIncentiveType__c,
    					rd.clienMeasureId__c, rd.clientMeasureName__c, r.MOUNumber__c, rd.partner__c, rd.partNumber__c, rd.totalItems__c,
    					rd.incentiveAmount__c, '', rd.clientSubCategory__c, '', rd.wattage__c, rd.replacedWattage__c, '', '', r.salesStartDate__c,
    					r.salesEndDate__c, rd.packSize__c, rd.unitRebate__c, rd.quantity__c 
    				});
    			}
    			
    	} 
    	
	    return results;
    }
    
    
}