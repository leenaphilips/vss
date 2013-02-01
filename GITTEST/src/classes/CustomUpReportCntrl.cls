public class CustomUpReportCntrl {

    private Rep_DateLoader dp;
    public Integer Year{ get; set; }
    public Date InvoiceDate{ get; set; }
    public String ReportName {get; set; }
     
    private String clientCode;
    private MapList reportsByProgram = new MapList(true);
    private Map<String, String> programNames = new Map<String, String>();
    
    public CustomUpReportCntrl(){
        this(false);
    }
    
    public CustomUpReportCntrl(Boolean isTest){
        dp = new Rep_UpDateLoader(isTest);
        Set<ID> programIds = new Set<ID>();
        
        clientCode = [select clientcode__c from User where id = :UserInfo.getUserId()].clientCode__c;
        
        if( Utils.isEmpty(clientCode))
            return;
            
        for(CustomReport__c r : [select Id, Name, ApexClassName__c, UseReportLauncher__c, UcpId__c, UcpId__r.Name from CustomReport__c where UcpId__r.ClientCode__c = :clientCode and IsActive__c = true ]){
            reportsByProgram.addObject( r.UcpId__c, r );
            programNames.put( r.UcpId__c, r.UcpId__r.Name);
        }
    }
    
    public List<SelectOption> getYears(){
        List<SelectOption> opts = new List<SelectOption>{};
        
        for(Integer i : dp.getYears(clientCode)){
            opts.add( new SelectOption(i+'',i+'') );
            
            if( Year == null || Year == 0){
                Year = i;
            }
        }
        
        return opts;
    }
    
    public List<SelectOption> getInvoiceDates(){
        
        List<SelectOption> opts = new List<SelectOption>{};
        for(Date d : dp.getInvoiceDates(clientCode, Year)){
            String dateString = d.month()+'/'+d.day()+'/'+d.year();
            opts.add( new SelectOption(dateString,dateString));
        }
        
        return opts;
    }
    
    public List<Rep_PageSection> getReports(){
        
        List<Rep_PageSection> sections = new List<Rep_PageSection>();
        for(String programID : reportsByProgram.keySet()){
            Rep_PageSection s = new Rep_PageSection();
            s.Name = programNames.get(programID);
            
            List<Rep_ReportItem> items = new List<Rep_ReportItem>();
            for(Object o : reportsByProgram.get(programID)){
                CustomReport__c c = (CustomReport__c)o;
                Rep_ReportItem i = new Rep_ReportItem();
                i.reportName = c.Name;
                i.useReportLauncher = c.useReportLauncher__c;
                if( c.UseReportLauncher__c )
                    i.reportPath = '/apex/ReportLauncher?ReportName='+c.ApexClassName__c;
                else
                    i.reportPath = c.ApexClassName__c+'?ReportName='+c.ApexClassName__c;
                    
                items.add(i);
            }
            
            s.setItems(items);
            sections.add(s);
        }
        return sections;
    }
    

}