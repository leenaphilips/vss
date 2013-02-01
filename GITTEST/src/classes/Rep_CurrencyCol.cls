public with sharing class Rep_CurrencyCol extends Rep_ColumnFormatter{
	
	public Rep_CurrencyCol(String name){
		super(name);
	}
	
	public override String format(Object o){
		if( o instanceof Integer || o instanceof Double){
			String s = ((Double)o)+'';
			Integer ptIndex = s.indexOf('.');
			if(ptIndex < s.length() - 2 && ptIndex > 0)
				s = s.substring(0, ptIndex+3);
			return s;
		} else {
			return '';
		}
	}

}