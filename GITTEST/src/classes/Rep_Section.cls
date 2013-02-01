public with sharing class Rep_Section {
	
	private List<Rep_ColumnFormatter> columns = new List<Rep_ColumnFormatter>();
	private List<List<Object>> rows = new List<List<Object>>();
	private Boolean showColNames = true;
	public String sectionName {get; set;}
	
	public void setColNames(Rep_ColumnFormatter[] cols){
		setColNames(cols, true);
	}
	
	public void setColNames(Rep_ColumnFormatter[] cols, Boolean showNames){
		columns = cols;
		showColNames = showNames;
	}
	
	public void setColNames(String[] names, Boolean showNames){ 
		for(String name : names){
			columns.add( new Rep_StringCol(name));
		}
		showColNames = showNames;
	}
	
	public void addRow(List<Object> row){ rows.add(row); }
	
	public String getColumnNames(){ 
		if( !showColNames ) return ''; 
		
		List<String> colNames = new List<String>();
		for(Rep_ColumnFormatter f : columns){
			colNames.add( f.name );
		}
		return pack(colNames);
	}
	
	public List<String> getRows(){ 
		List<String> display = new List<String>();
		for(List<Object> row : rows){
			
			List<String> dispRow = new List<String>();
			for(Integer i=0; i < row.size(); i++){
				Rep_ColumnFormatter f = i < columns.size() ? columns.get(i) : null;
				dispRow.add( f != null ? f.format(row.get(i)) : 'ERR');
			}
			display.add( pack(dispRow) );
		}
		return display;
	}
	
	private String pack(List<String> data){
		String row = '';
		for(Integer i=0; i < data.size(); i++){
			row += (!Utils.isEmpty(data[i]) ? data[i] : '')+(i < data.size() - 1 ? ',' : '');
		}
		
		return row;
	}
	

}