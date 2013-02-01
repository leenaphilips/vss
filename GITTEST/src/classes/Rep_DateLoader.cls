public abstract class Rep_DateLoader {

    private List<Integer> validYears;
    private MapList invoiceDates;
    
    public abstract void init(String clientCode);
    
    public void init(String soql, String dateFieldName){
    	System.debug('DateLoader.init called: '+soql+'; '+dateFieldName); 
        validYears = new List<Integer>();
        invoiceDates = new MapList();
        
        Set<Integer> years = new Set<Integer>(); 
        Set<Date> dates = new Set<Date>();
        
        System.debug('sending query');
        for(AggregateResult r : Database.query(soql)){
            Date d = (Date)r.get(dateFieldName);
            if( d == null ) continue;
            
            years.add( d.year() );
            invoiceDates.addObject( d.year()+'', d);
            dates.add(d);
            
        }
        
        System.debug('Found '+years.size()+' years');
        
        List<Integer> sorted = new List<Integer>();
        sorted.addAll(years);
        sorted.sort();
        
        for(Integer i = sorted.size()-1; i >=0; i--){
            validYears.add(sorted.get(i));
        }
    }
    
    public List<Integer> getYears(String clientCode){
        
        if( validYears == null )
            init(clientCode);
        return validYears;
    }
    
    public Date getMaxInvoiceDate(String clientCode){
        if( invoiceDates == null ) init(clientCode);
        if( invoiceDates.isEmpty() ) return null;
        
        Date maxDate = null;
        for(Object o : invoiceDates.get( validYears.get(0)+'')){
            Date iDate = (Date)o;
            if( maxDate == null || iDate > maxDate){
                maxDate = iDate;
            }
        }
        
        return maxDate;
    }
    
    public List<Date> getInvoiceDates(String clientCode, Integer year){
        if( validYears == null ) init(clientCode);
        
        List<Object> sorted = year != null && year > 0 ? invoiceDates.get(year+'') : invoiceDates.getAllValues();
        sorted.sort();
        
        List<date> revSorted = new List<Date>();
        for(Integer i=sorted.size()-1; i >= 0; i--){
            revSorted.add( (Date)sorted.get(i) );
        }
        return revSorted;
    }
}