public with sharing class Rep_NumberCol extends Rep_ColumnFormatter {
	
	public Boolean round {get; set; }
	
	public Rep_NumberCol(String name, Boolean round){
		super(name);
		this.round = round;
	}
	
	public override String format(Object o){
		if( o instanceof Integer){
			return ((Integer)o)+'';
		}
		if( o instanceof Double){
			Double d = (Double)o;
			if( round )
				return Math.round(d)+'';
			return d+'';
		}
		
		return '';
	}

}