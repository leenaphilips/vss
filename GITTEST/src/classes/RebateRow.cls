public with sharing class RebateRow {

	public String AccountNum{ get; set; }
	public String FirstName{ get; set; }
	public String LastName { get; set; }
	public Date SubmittedDate{ get; set; }
	public Double RebateAmount{ get; set; }
	public String Status {get; set; }
	
	
	public String getSubmittedDateStr(){
		return Utils.toDateString(SubmittedDate);
	}
	
	public String getRebateAmountStr(){
		return Utils.toCurrency(RebateAmount);
	}
}