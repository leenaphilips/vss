public with sharing class Rep_Pse_Allocation implements ICsvReport {

	public static final String NAME = 'rep_pse_allocation';
	
    private Date InvoiceDate;
    private Integer InvoiceYear;
    private ReportDateHelper rdh;
    private boolean isTest = false;
    private Map<String, Row> data = new Map<String,Row>();
    private List<Row> rows = new List<Row>();
    
    public Rep_Pse_Allocation(){ this(false); }
    
    public Rep_Pse_Allocation(boolean test){
        isTest = test;
        rdh = new ReportDateHelper();   
    }
    
    public String getReportName(){ return NAME; }
    
    public String getReportLabel(){ return 'Allocation'; }
    
    public ICsvReport cloneReport(Boolean isTest){ return new Rep_Pse_Allocation(isTest); }
    
    public Rep_ResultSet getResultSet(String formCode){
    	
    	Integer recLimit = isTest ? 10 : 1000000;
    	for(List<UpstreamRebateDetail__c> details : 
    		[select UpstreamRebateId__r.MouNumber__c, UpstreamRebateId__r.UpstreamClientId__r.MouBudget__c, ClientSubCategory__c,
    			IncentiveAmount__c
    		 FROM UpstreamRebateDetail__c
    		 WHERE UpstreamRebateId__r.ClientCode__c = 'SGE'
    		 ORDER BY UpstreamRebateId__r.MouNumber__c ASC, ClientSubCategory__c ASC LIMIT :recLimit]){
    	
    		for(UpstreamRebateDetail__c d : details){
    			UpstreamRebate__c rebate = d.UpstreamRebateId__r;
    			UpstreamClient__c c = rebate != null ? rebate.UpstreamClientId__r : null;
    			
    			String id = createId( rebate.MouNumber__c, d.ClientSubCategory__c);
    			Row r = data.get(id);
    			if( r == null ){
    				data.put(id, r = new Row(rebate.MouNumber__c, d.ClientSubCategory__c));
    				r.allocation = c.MOUBudget__c;
    				rows.add(r);
    			}
    			r.sales += d.IncentiveAmount__c != null ? d.IncentiveAmount__c : 0;
    		}
    	}
        
        Rep_ResultSet results= new Rep_ResultSet();
        results.setColNames(new String[]{'MOU', 'Product Cat', 'Allocation', 'Sales YTD', '% Allocation'});
        
        for(Row r : rows){
        	results.addRow( new String[]{r.mouNumber, r.productCat, r.allocation+'', r.sales+'', r.pctOfAllocation+'' } );
        }
    	return results;
    }
    
    private String createId(String mouNumber, String cat){ return mouNumber +'|' + cat; }
    
    class Row{
    	public String mouNumber{get;set;}
    	public String productCat {get; set; }
    	public Double allocation {get; set; }
    	public Double sales {get; set; }
    	public Double pctOfAllocation{
    		get{
    			return allocation > 0 ? sales/allocation : 0;
    		}
    		private set;
    	}
    	
    	public Row(String mouNumber, String cat){
    		this.mouNumber = mouNumber;
    		this.productCat = cat;
    		allocation = 0;
    		sales = 0;
    	}
    }
}