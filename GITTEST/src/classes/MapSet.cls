public class MapSet {
    private Map<String, Set<Object>> m = new Map<String, Set<Object>>();
    
    public void addObject(String key, Object val){
        Set<Object> s = m.get(key);
        if( s == null ) m.put(key, s = new Set<Object>());
        s.add(val);
    }
    
    public Set<Object> get(String k){ return m.get(k); }
    
    public Integer size(){ return m.size(); }
    
    public Set<String> keySet(){ return m.keySet(); }
    
    public Boolean containsKey(String key){ return m.containsKey(key); }
    
    public Boolean containsValue(String key, String value){ return m.containsKey(key) && m.get(key).contains(value); }
}