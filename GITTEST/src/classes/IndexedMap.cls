public class IndexedMap {
    
    private Boolean isCaseSensitive;
    
    private Map<String, Map<String, Object>> theMap = new Map<String, Map<String, Object>>();
    
    public IndexedMap(Boolean isCaseSensitive){
        this.isCaseSensitive = isCaseSensitive;
    }
    
    public IndexedMap(){ this(false); }
    
    public void setObject(String index, String key, Object value){
        Map<String, Object> innerMap = theMap.get( !isCaseSensitive && index != null ? index.toLowerCase() : index );
        if( innerMap == null ){
            theMap.put( !isCaseSensitive && index != null ? index.toLowerCase() : index, innerMap = new Map<String, Object>());
        }
        
        innerMap.put( !isCaseSensitive && key != null ? key.toLowerCase() : key, value);
    }
    
    public Set<String> keySet(){ return theMap.keySet(); }
    
    public Set<String> keySet(String index){
        return getSize(index) > 0 ? theMap.get(!isCaseSensitive && index != null ? index.toLowerCase() : index).keySet() : null;
    }
     
    public Object getValue(String index, String key){
        
        Map<String, Object> innerMap = theMap.get(!isCaseSensitive && index != null ? index.toLowerCase() : index);
        if( innerMap != null ){
            return innerMap.get( !isCaseSensitive && key != null ? key.toLowerCase() : key );
        }
        
        return null;
    }
    
    public Integer getSize(){ return theMap.size(); }
    
    public Integer getSize(String index){
        Map<String, Object> innerMap = theMap.get( !isCaseSensitive && index != null ? index.toLowerCase() : index);
        return innerMap != null ? innerMap.size() : 0;
    }
    
}