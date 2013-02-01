/*
 * 2012.09.05:CEV::Updates the related budget with the current used amount (either 'reserved' or 'rebate') based upon the 
 *	changes to rebate amount. 
 *
 * Note that Rebate__c.PayableAmount__c is a calculated (i.e. rollup) field that indicates the amount that will be paid out
 * to all parties as determined by the details, their quantities, and their statuses.
 *
 */
trigger Rebate_UpdateBudget on Rebate__c (after delete, after insert, after update) {
	
	static Integer RESERVATION = 0;
	static Integer REBATE = 1;
	
	//-- group changes by form
	Map<String, Map<Integer, Double>> getFormDiffs(){
		Map<String, Map<Integer, Double>> formDiffs = new Map<String, Map<Integer, Double>>();
		
		for(Integer i=0; i < Trigger.size; i++){
			
			if( !Trigger.isInsert ){
				calculateDiff( formDiffs, Trigger.old[i], false);
			}
			
			if( !Trigger.isDelete ){
				calculateDiff( formDiffs, Trigger.new[i], true);
			}
		}
		
		return formDiffs;
	}
	
	//-- group changes by budget
	Map<String, BudgetDs__c> getBudgetDiffs(Map<String, Map<Integer, Double>> formDiffs){
		
		List<Form__c> forms = [select id, budgetDsId__c FROM Form__c where id in :formDiffs.keySet() and budgetDsId__c <> null];
		if( forms.size() == 0 ) return null;
		
		Map<String, BudgetDs__c> budgetDiffs = new Map<String, BudgetDs__c>();
		for(Form__c f : forms){
			BudgetDs__c budget = budgetDiffs.get( f.budgetDsId__c );
			if( budget == null ){
				budgetDiffs.put( f.budgetDsId__c, budget = new BudgetDs__c(TotalReserved__c = 0, TotalRebates__c = 0));
			}
			Map<Integer, Double> diffs = formDiffs.get( f.id );
			Double diff = diffs.get(RESERVATION);
			budget.TotalReserved__c += (diff != null ? diff : 0);
			
			diff = diffs.get(REBATE);
			budget.TotalRebates__c += (diff != null ? diff : 0);
			
		}
		return budgetDiffs;
	}
	
	void updateBudgets(Map<String, BudgetDs__c> budgetMods){
		
		List<BudgetDs__c> dbBudgets = [select id, TotalReserved__c, TotalRebates__c from BudgetDs__c WHERE id in :budgetMods.keySet() FOR UPDATE];
		
		for(BudgetDs__c budget : dbBudgets){
			BudgetDs__c mod = budgetMods.get(budget.id);
			
			budget.TotalReserved__c = (budget.TotalReserved__c == null ? 0 : budget.TotalReserved__c) + mod.TotalReserved__c;
			budget.TotalRebates__c = (budget.TotalRebates__c == null ? 0 : budget.TotalRebates__c) + mod.TotalRebates__c;
		}
		
		update dbBudgets;
	}
	
	//-- helper to calc diff for a rebate
	void calculateDiff(Map<String, Map<Integer, Double>> formDiffs, Rebate__c r, boolean isAdd){
		
		Map<Integer, Double> diffs = formDiffs.get( r.FormId__c );
		if( diffs == null ){
			formDiffs.put( r.FormId__c, diffs = new Map<Integer, Double>());
		}
		Double amt = diffs.get( getType(r));
		if(amt == null ){
			amt = 0;
		}
		
		diffs.put( getType(r), amt + (isAdd ? r.PayableAmount__c : -r.PayableAmount__c) );
	}
	
	//-- returns the classification of the rebate (reservation, rebate)
	Integer getType(Rebate__c r){
		if( 'reservation'.equalsIgnoreCase(r.RebateStatusMM__c)){
			return RESERVATION;
		}
		return REBATE;
	}
	
	//--MAIN
	Map<String, Map<Integer, Double>> formDiffs = getFormDiffs();
	Map<String, BudgetDs__c> budgetDiffs = getBudgetDiffs(formDiffs);
	if( budgetDiffs != null && budgetDiffs.size() > 0)
		updateBudgets(budgetDiffs);
	
}