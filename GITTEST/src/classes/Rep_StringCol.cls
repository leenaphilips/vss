public with sharing class Rep_StringCol extends Rep_ColumnFormatter {

	public Rep_StringCol(String name){
		super(name);
	}
	
	public override String format(Object o){
		if( o instanceof String){
			return ((String)o);
		}
		return '';
	}
}