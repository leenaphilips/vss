public with sharing class Rep_RebateExport {
	/*
	public Rep_RebateExport(){
		
	}
	
	public List<RebateRow> getRows(){
		List<Rebate__c> data = null;
		
		data = [select id, ContactId__r.AccountNumber__c, MailingFirstName__c, MailingLastName__c, CreatedDate, RebateStatus__c, PurchaseDate__c, TotalRebateAmount__c from Rebate__c
			WHERE FormCode__c = 'GAPRF2011' LIMIT 100];
			
		List<RebateRow> rows = new List<RebateRow>();
		
		for(Rebate__c r : data){
			RebateRow row = new RebateRow();
			row.AccountNum = r.ContactID__r.AccountNumber__c;
			row.FirstName = r.MailingFirstName__c;
			row.LastName = r.MailingLastName__c;
			//row.SubmittedDate = r.PurchaseDate__c;
			row.RebateAmount = r.TotalRebateAmount__c;
			row.Status = r.RebateStatus__c;
			
			rows.add(row);
		}
		
		return rows;
	}
*/
}