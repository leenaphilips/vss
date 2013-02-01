public with sharing class Rep_ResultSet {
	
	List<Rep_Section> sections = new List<Rep_Section>();
	Rep_Section theSection = new Rep_Section();
	public String reportName {get; set;}
	
	public Rep_ResultSet(){ }
	
	public void setColNames(String[] names){ 
		if( theSection == null ) theSection = new Rep_Section();
		theSection.setColNames(names, true);
	}
	
	public void setColNames(Rep_ColumnFormatter[] f){
		if( theSection == null ) theSection = new Rep_Section();
		theSection.setColNames(f, true);
	}
	
	public void addRow(List<Object> row){ 
		if( theSection == null ) theSection = new Rep_Section();
		theSection.addRow(row);
	}
	
	public String getColumnNames(){ 
		return theSection != null ? theSection.getColumnNames() : null;
	} 
	
	public List<String> getRows(){ 
		return theSection != null ? theSection.getRows() : null;
	}
	
	public void addSection(Rep_Section s ){
		sections.add(s);
	}
	
	public List<Rep_Section> getSections(){ 
		if( theSection != null ) sections.add( theSection );
		return sections;
	}
	
}