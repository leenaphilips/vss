public with sharing class Rep_Pse_InvSum implements ICsvReport{

	public static final String NAME = 'rep_pse_invsum';
	
    private Map<String, MouRow> data = new Map<String, MouRow>(); //-- Holds invoices keyed by InvoiceNumber.  This is solely to make locating an existing invoice easier.
    private Map<String, List<MouRow>> mouInvoices = new Map<String, List<MouRow>>(); //-- we need to summarize by MOU.  This will have a list of Invoices for each MOU

    private Date InvoiceDate; 
    private Integer InvoiceYear;
    private ReportDateHelper rdh;
    private boolean isTest = false;
    
    public Rep_Pse_InvSum(){ this(false); }
    
    public Rep_Pse_InvSum(boolean test){
        isTest = test;
        rdh = new ReportDateHelper();   
    }
    
    public String getReportName(){ return NAME; }
    
    public String getReportLabel(){ return 'CurrentInvoiceSummary'; }
    
    public ICsvReport cloneReport(Boolean isTest){ return new Rep_Pse_InvSum(isTest); }
    
    //-- returns all rows in the data set.  Summary rows are "faked"
    public Rep_ResultSet getResultSet(String formCode){
        
        //-- must have invoice date -- pick latest if none specified
        Date invoiceDate = rdh.getInvoiceDate();
        if( invoiceDate == null){
            Rep_DateLoader dp = new Rep_UpDateLoader();
            invoiceDate = dp.getMaxInvoiceDate('PSE');
        }
        
        if( invoiceDate == null ) return null;
        
        
        /*List<UpstreamRebate__c> rebates = 
                [select MouName__c, MouNumber__c, ReceivedDate__c, PartnerInvoiceNumber__c 
                FROM UpstreamRebate__c 
                WHERE InvoiceDate__c = :invoiceDate];
                
        } else if(rdh.hasYear()) {
            rebates = new List<UpstreamRebate__c>(
                [select MouName__c, MouNumber__c, ReceivedDate__c, PartnerInvoiceNumber__c 
                FROM UpstreamRebate__c 
                where InvoiceDate__c >= :rdh.getMinDate() AND InvoiceDate__c <= :rdh.getMaxDate() LIMIT 5000]);
        
        } else {
            rebates = new List<UpstreamRebate__c>(
                [select MouName__c, MouNumber__c, ReceivedDate__c, PartnerInvoiceNumber__c 
                FROM UpstreamRebate__c]);
        } */
        //-- Each invoice will be related to multiple Rebates.  Foreach rebate, check if we have aleady
        //  processed the invoice.  If so, update the rebate count.  If not, create a new row
        
        Integer recLimit = isTest ? 10 : 1000000;
        for(UpstreamRebate__c ur : [SELECT MouName__c, MouNumber__c, ReceivedDate__c, PartnerInvoiceNumber__c 
                                    FROM UpstreamRebate__c 
                                    WHERE InvoiceDate__c = :invoiceDate and ClientCode__c = 'PSE' LIMIT :recLimit]){
            String invoiceNum = ur.PartnerInvoiceNumber__c;
            
            //-- check for existing invoice
            MouRow r = data.get(invoiceNum);
            if( r == null ){
                //-- if not, create a new row for the invoice
                data.put(invoiceNum, r = new MouRow());
                
                //-- initialize
                r.MouName = ur.MouName__c;
                r.MouNumber = ur.MouNumber__c;
                r.ReceivedDate = ur.ReceivedDate__c; 
                r.RebateCount = 0; 
                r.InvoiceNumber = invoiceNum;
                
                //-- We will summarize by MOU so add this row to the correct MOU list
                List<MouRow> mous = mouInvoices.get( r.MouNumber );
                if( mous == null ){
                    mouInvoices.put(r.MouNumber, mous = new List<MouRow>());
                }
                mous.add(r);
            }
            //-- increments the count of rebates relating to this invoice
            r.addRebate();
        }
        
        //-- At this point we have all of all of the information we need in mouInvoices
        
        //List<MouRow> display = new List<MouRow>(); //-- This is what we will display to the user
        Rep_ResultSet rs = new Rep_ResultSet();
        rs.setColNames( new String[]{'MOU Number','MOU Name','Invoice Number','Received Date','Rebates'} );
        rs.reportName = 'CurrentInvoiceSummary';
        //-- For each mouNumber, add the row to the display set and, at the end, create summary info
        for(String mouNumber : mouInvoices.keySet()){
            List<MouRow> rows = mouInvoices.get(mouNumber);
            
            Integer numRebates = 0; //-- total number of rebates for the MOU
            Integer numInvoices = 0; //-- total number of invoices for the MOU
            
            //-- add the row to the display and update the summary fields
            for(MouRow r : rows){
            	rs.addRow( new String[]{r.MouNumber, r.MouName, r.InvoiceNumber, r.getReceivedDateStr(), r.RebateCount+''} );
                //display.add(r);
                numRebates += r.RebateCount;
                mouNumber = r.MouNumber;
                numInvoices++;
            }
            
            //-- create the summary row
            /*MouRow totalRow = new MouRow();
            totalRow.MouNumber = '';
            totalRow.MouName = 'Total for ' + mouNumber;
            totalRow.InvoiceNumber = numInvoices+'';
            totalRow.RebateCount = numRebates;
            display.add(totalRow);*/
            rs.addRow( new String[]{'', 'Total for '+mouNumber, numInvoices+'', numRebates+''} );
            
            //-- spacer to make it pretty
            //MouRow spacer = new MouRow();
            //display.add(spacer);
            rs.addRow( new String[4] );
        }
        
        //-- return the data to the page
        return rs;
    }
    
}