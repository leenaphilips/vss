public with sharing class ReportDateHelper {

	private Date invoiceDate;
	private Integer invoiceYear;
	
	public ReportDateHelper(){
		String invoiceDateString = ApexPages.currentPage().getParameters().get('InvoiceDate');
		try{
			invoiceDate = Date.parse(invoiceDateString);
		} catch(Exception e){
			System.debug('Invalid InvoiceDate format: '+invoiceDateString);
		}
		
		InvoiceYear = 0;
		String invoiceYearString = ApexPages.currentPage().getParameters().get('InvoiceYear');
		try{
			invoiceYear = Integer.valueOf(invoiceYearString);
		} catch(Exception e){
			System.debug('Invalid Invoice Yead: '+invoiceYearString);
		}
	}
	
	public Date getInvoiceDate(){ return invoiceDate; }
	
	public Integer getInvoiceYear(){ return invoiceYear; }
	
	public Date getMinDate(){ return Date.newInstance(invoiceYear, 1, 1); }
	
	public Date getMaxDate(){ return Date.newInstance(invoiceYear, 12, 31); }
	
	public Boolean hasInvoiceDate(){ return invoiceDate != null; }
	
	public Boolean hasYear(){ return InvoiceYear > 0; }
}