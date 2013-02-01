public with sharing class MapList {

	private Map<String, List<Object>> mapList = new Map<String, List<Object>>();
	private Boolean isCaseSensitive;
	
	public MapList(Boolean caseSense){ 
		isCaseSensitive = caseSense;
	}
	
	public MapList(){
		this(false);
	}
	
	public void addObject(String key, Object value){
		
		if( !isCaseSensitive && key != null ) key = key.toLowerCase();
		
		List<Object> l = mapList.get(key);
		if( l == null ){
			mapList.put(key, l = new List<Object>());
		}
		l.add(value);
	}
	
	public List<Object> getAllValues(){
		List<Object> l = new List<Object>();
		for(List<Object> v : mapList.values()){
			l.addAll(v);
		}
		return l;
	}
	
	public boolean containsKey(String key){
		if( !isCaseSensitive && key != null ) key = key.toLowerCase();
		return mapList.containsKey(key);
	}
	
	public List<Object> get(String key){ 
		if( !isCaseSensitive && key != null ) key = key.toLowerCase();
		return mapList.get(key); 
	}
	
	public Boolean isEmpty(){ return mapList.isEmpty(); }
	
	public Set<String> keySet(){ return mapList.keySet(); }

}