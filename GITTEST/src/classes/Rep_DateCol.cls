public with sharing class Rep_DateCol extends Rep_ColumnFormatter {

	public Boolean withTime = false;
	public Rep_DateCol(String name){
		this(name, false);
	}
	
	public Rep_DateCol(String name, Boolean hasTime){
		super(name);
		withTime = hasTime;
	}
	
	public override String format(Object o){
		if( o instanceof Date){
			Date d = (Date)o;
			return d.month()+'/'+d.day()+'/'+d.year();
		} else if(o instanceof Datetime){
			Datetime d = (Datetime)o;
			return d.month()+'/'+d.day()+'/'+d.year()+(withTime ? d.hour()+':'+d.minute() : '');
		} else {
			return '';
		}
	}
}