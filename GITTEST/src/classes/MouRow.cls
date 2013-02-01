public with sharing class MouRow {
    
    public String MouName{ get; set; }
    public String MouNumber {get; set; }
    public String InvoiceNumber {get; set; }
    public Integer RebateCount {get; set; } 
    
    public Double BudgetAmount{ get; set; }
    public Double InvoiceAmount {get; set; }
    
    public Date InvoiceDate {get; set;}
	public Date ReceivedDate {get; set; }
    public Date MinSalesDate{ get; set; }
    public Date MaxSalesDate{ get; set; }
    
    public void addRebate(){ RebateCount = RebateCount+1; }
    
    public Integer getDaysSinceReceived(){
    	return InvoiceDate != null && ReceivedDate != null ? ReceivedDate.daysBetween(InvoiceDate) : 0;
    }
    
    public Integer getDaysSinceSaleEnd(){
    	return InvoiceDate != null && MaxSalesDate != null ? MaxSalesDate.daysBetween(InvoiceDate) : 0;
    }
    
    public String getReceivedDateStr(){
    	return Utils.toDateString(ReceivedDate);
    }

	public String getMinSalesDateStr(){
		return Utils.toDateString(MinSalesDate);
	}
	
	public String getMaxSalesDateStr(){
		return Utils.toDateString(maxSalesDate);
	}
	
	public String getInvoiceDateStr(){ 
		return Utils.toDateString(invoiceDate);
	}
	
	public String getInvoiceAmountStr(){
		return Utils.toCurrency(InvoiceAmount);
	}
	
	/*
	public testMethod static void testIt(){
		MouRow r = new MouRow();
		r.getDaysSinceReceived();
		r.getDaysSinceSaleEnd();
		r.getReceivedDateStr();
		r.getMinSalesDateStr();
		r.getMaxSalesDateStr();
		r.getInvoiceDateStr();
		r.getInvoiceAmountStr();
	}
	*/
}