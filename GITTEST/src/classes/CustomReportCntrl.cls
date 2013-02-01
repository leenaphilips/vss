/*
 * 2012.05.31:CEV :: add CustomReport.ProgramName field to display a more client-friendly program name (vs. code).
 */
public without sharing class CustomReportCntrl {

    private Rep_DateLoader dp;
    public Integer Year{ get; set; }
    public Date InvoiceDate{ get; set; }
    public String ReportName {get; set; } 
    
    private String clientCode;
    private MapList reportsByForm = new MapList(true);
    private MapList reportsByProgram = new MapList(true);
    private CustomReport__c[] accountReports = new List<CustomReport__c>();
    private Map<String, String> formNames = new Map<String, String>();
    
    public CustomReportCntrl(){
        this(false);
    }
    
    public CustomReportCntrl(Boolean isTest){
        dp = new Rep_DownDateLoader(isTest); 
        
        clientCode = [select clientcode__c from User where id = :UserInfo.getUserId()].clientCode__c;
        if( Utils.isEmpty(clientCode))
            return;
        
        List<Account> accounts = [select id from Account where clientCode__c = :clientCode];
        if( accounts == null || accounts.size() != 1)
            return;
            
        String actId = accounts.get(0).id;
        
        for(CustomReport__c r : 
            [select Id, Program__c, ProgramName__c, FormId__r.Id, FormId__r.FormCode__c, FormId__r.Name, Name, ApexClassName__c, UseReportLauncher__c
            from CustomReport__c 
            where accountId__c =: actId and isActive__c = true
            ORDER BY FormId__r.FormStartDate__c DESC]){
                
            Form__c f = r.FormId__r;
            if( f == null ){
                
                if( Utils.isEmpty(r.ProgramName__c) && Utils.isEmpty(r.Program__c) )
                    accountReports.add( r );
                else
                    reportsByProgram.addObject( Utils.nullValue(r.ProgramName__c, r.Program__c), r);
            } else {
                reportsByForm.addObject( f.id, r );
                formNames.put(f.id, f.Name);
            }
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
    
    public Boolean getHasAccountReports(){
    	return accountReports != null && !accountReports.isEmpty();
    }
    
    public List<Rep_ReportItem> getAccountReports(){
        List<Rep_ReportItem> items = new List<Rep_ReportItem>();
        for(CustomReport__c c : accountReports){
            Rep_ReportItem i = new Rep_ReportItem();
            
            i.reportName = c.name;
            i.reportPath = '/apex/ReportLauncher?ReportName='+c.ApexClassName__c;
            items.add(i);
        }
        return items;
    }
    
    public List<Rep_PageSection> getProgramReports(){
        Rep_PageSection[] sections = new List<Rep_PageSection>();
        for(String program : reportsByProgram.keySet()){
            Rep_PageSection s = new Rep_PageSection();
            s.Name = program;
            
            Rep_ReportItem[] items = new List<Rep_ReportItem>();
            for(Object o : reportsByProgram.get(program)){
                CustomReport__c c = (CustomReport__c)o;
                Rep_ReportItem i = new Rep_ReportItem();
                
                i.reportName = c.Name;
                i.reportPath = (c.UseReportLauncher__c ? '/apex/ReportLauncher?ReportName=' : '')+c.ApexClassName__c+'&Program='+c.Program__c; 
                items.add(i);
            }
            s.setItems(items);
            sections.add(s);
        }
        return sections;
    }
    
    public List<Rep_PageSection> getFormReports(){
        
        Rep_PageSection[] sections = new List<Rep_PageSection>();
        for(String formId : reportsByForm.keySet()){
            Rep_PageSection s = new Rep_PageSection();
            s.Name = formNames.get(formId);
            
            Rep_ReportItem[] items = new List<Rep_ReportItem>();
            for(Object o : reportsByForm.get(formId)){
                Rep_ReportItem i = new Rep_ReportItem();
                CustomReport__c c = (CustomReport__c)o;
                
                i.reportName = c.Name;
                i.reportPath = '/apex/ReportLauncher?ReportName='+c.ApexClassName__c+'&FormCode='+c.FormID__r.FormCode__c;
                items.add(i);
                
            }
            s.setItems(items);
            sections.add(s);
        }
        return sections;
    }
}