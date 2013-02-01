public with sharing class Rep_PageSection {
	
	private Rep_ReportItem[] items;
	public String Name {get; set;}
	
	public void setItems(Rep_ReportItem[] i){
		items = i;
	}
	
	public List<Rep_ReportItem> getItems(){ return items; }
	
}