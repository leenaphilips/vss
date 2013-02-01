public with sharing class URDRow {
	
	public URDRow(){
		salesAmount = 0;
		quantity = 0;
	}
	
	public String ParentId{ get; set; }
	public String PartNum{ get; set; }
	public String Cat{ get; set; }
	Public String PartDescription{ get; set; }
	
	private Double salesAmount;
	public void addSalesAmount(Decimal amount){
		salesAmount += amount;
	}
	
	public Integer quantity{ get; set; }
	
	public void addQuantity(Integer num){
		quantity += num;
	}
	
	public String getSalesAmount(){
		//return Utils.toCurrency(Double.valueOf(salesAmount));
		return salesAmount+'';
	}
}