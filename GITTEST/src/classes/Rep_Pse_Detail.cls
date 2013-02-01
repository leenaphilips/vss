public with sharing class Rep_Pse_Detail {

    public static final String NAME = 'rep_pse_detail';
    
    private static final String CLIENT_CODE = 'PSE';
    
    private Date InvoiceDate;
    private Integer InvoiceYear;
    private ReportDateHelper rdh;
    private boolean isTest = false;
    private Map<Double, Section> data = new Map<Double, Section>();
    private List<Section> sections = new List<Section>();
    
    public Rep_Pse_Detail(){ this(false); }
    
    public Rep_Pse_Detail(boolean test){
        isTest = test;
        rdh = new ReportDateHelper();   
    } 
    
    public String getReportName(){ return NAME; }
    
    public String getReportLabel(){ return 'RebateDetail'; }
    
    //public ICsvReport cloneReport(Boolean isTest){ return new Rep_Pse_Detail(isTest); }
    
    //-- returns all rows in the data set.  Summary rows are "faked"
    public List<Section> getResultSet(){
        
        //-- must have invoice date -- pick latest if none specified
        Date invoiceDate = rdh.getInvoiceDate();
        if( invoiceDate == null){
            Rep_DateLoader dp = new Rep_UpDateLoader();
            invoiceDate = dp.getMaxInvoiceDate(CLIENT_CODE);
        }
        
        if( invoiceDate == null ) return null;
        
        Integer recLimit = isTest ? 10 : 1000000;
        
        for(List<UpstreamRebateDetail__c> details :
            [SELECT PartNumber__c, PartDescription__c, Manufacturer__c, Quantity__c, UnitRebate__c, IncentiveAmount__c,
                UpstreamRebateId__r.MOUNumber__c, UpstreamRebateId__r.LegacyRebateNumber__c, UpstreamRebateId__r.CheckDate__c,
                UpstreamRebateId__r.PartnerInvoiceNumber__c, UpstreamRebateId__r.InvoiceDate__c, UpstreamRebateId__r.StoreId__c,
                UpstreamRebateId__r.StoreName__c, UpstreamRebateId__r.StoreAddress1__c, UpstreamRebateId__r.StoreCity__c, UpstreamRebateId__r.StoreState__c,
                UpstreamRebateId__r.StoreZipcode__c, UpstreamRebateId__r.CustBusinessName__c, UpstreamRebateId__r.CustAddress__c, UpstreamRebateId__r.CustCity__c, 
                UpstreamRebateId__r.CustState__c
             FROM UpstreamRebateDetail__c
             WHERE UpstreamRebateId__r.InvoiceDate__c = :invoiceDate AND UpstreamRebateId__r.ClientCode__c =: CLIENT_CODE
             ORDER BY UpstreamRebateId__r.LegacyRebateNumber__c ASC LIMIT :recLimit]){
            
            for(UpstreamRebateDetail__c d : details){
                UpstreamRebate__c rebate = d.UpstreamRebateId__r;
                
                Section s = data.get( rebate.LegacyRebateNumber__c );
                if(s == null){
                    data.put(rebate.LegacyRebateNumber__c, s = new Section());
                    s.rebate = rebate;
                    sections.add(s);
                }
                s.addRow(d);
            }       
        }
        return sections;
    }
    
    private String formatDate(Date d){ return d != null ? d.month()+'/'+d.day()+'/'+d.year() : ''; }
    
    class Section {
        public UpstreamRebate__c rebate {get; set;}
        public Integer numSold {get; set;}
        public Double totalRebateAmt {get;set;}
        private List<UpstreamRebateDetail__c> details = new List<UpstreamRebateDetail__c>();
        
        public Section(){
            numSold= 0;
            totalRebateAmt = 0;
        }
        
        public void addRow(UpstreamRebateDetail__c d){
            numSold += d.Quantity__c != null ? d.Quantity__c.intValue() : 0;
            totalRebateAmt += d.incentiveAmount__c!=null? d.incentiveAmount__c:0;
            details.add(d);
        }
        
        public List<UpstreamRebateDetail__c> getRows(){return details; }
        
    }
    
    
    
}