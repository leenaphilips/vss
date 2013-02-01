public with sharing abstract class Rep_ColumnFormatter {
    
    public enum ColumnType{ TYPE_STRING, TYPE_INT, TYPE_DOUBLE, TYPE_DATE, TYPE_DATETIME, TYPE_CURRENCY}
    
    public String name {get; set;}
    
    public Rep_ColumnFormatter(String name){ 
        this.name = name;
    }
    
    public abstract String format(Object val);
    
}