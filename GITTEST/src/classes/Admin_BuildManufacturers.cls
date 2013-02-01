public class Admin_BuildManufacturers {
	private boolean isTest = false;
	private Integer recLimit = 1000000;
	
// test git 
	public Admin_BuildManufacturers(){
		this(false);	
	}
	
	public Admin_BuildManufacturers(boolean isTest){ 
		this.isTest = isTest; 
		if( isTest ) recLimit = 10;
	}
	//jskdfhjsh
	//hgyhghgb
	
	public PageReference buildManufacturers(){
		
		Set<String> manNames = new Set<String>();
		
		for(List<Model__c> models : [select id, manufacturer__c from Model__c where manufacturer__c <> null LIMIT :recLimit]){
			
			for(Model__c m : models){
				manNames.add( m.Manufacturer__c );
			}
		}
		
		if( manNames.size() == 0) return null;
		
		Map<String, Manufacturer__c> manufacturers = createManufacturers(manNames);
		if( manufacturers.size() == 0 ) return null;
		
		createFormXManufacturers( manufacturers );
		
		
		return null;
	}
	
	private Map<String, Manufacturer__c> createManufacturers(Set<String> names){
		
		for(List<Manufacturer__c> mans : [select id from Manufacturer__c LIMIT :recLimit]){
			delete mans;
		}
		
		Map<String, Manufacturer__c> newManufacturers = new Map<String, Manufacturer__c>();
		for(String s : names){
			newManufacturers.put( s, new Manufacturer__c(Name = s, Manufacturer__c = s) );
		}
		
		if( newManufacturers.size() > 0 )
			insert newManufacturers.values();
		return newManufacturers;
	}
	
	private void createFormXManufacturers(Map<String, Manufacturer__c> manufacturers){
		
		for(List<FormXManufacturer__c> fxms : [select id from FormXManufacturer__c LIMIT :recLimit]){
			delete fxms;
		}
		
		Map<String, Set<String>> formManufacturers = new Map<String, Set<String>>();
		for(List<FormXModel__c> fxModels : [select Id, FormId__c, ModelId__r.Manufacturer__c from FormXModel__c WHERE ModelId__r.Manufacturer__c <> null LIMIT :recLimit]){
			
			for(FormXModel__c fxModel : fxModels){
				Set<String> man = formManufacturers.get( fxModel.FormId__c );
				if( man == null )
					formManufacturers.put( fxModel.FormId__c, man = new Set<String>());
				String manId = manufacturers.containsKey(fxModel.ModelID__r.Manufacturer__c) ? manufacturers.get(fxModel.ModelID__r.Manufacturer__c).id : null;
				if( manId != null)
					man.add( manId );
			}
		}
		
		List<FormXManufacturer__c> fxManufacturers = new List<FormXManufacturer__c>();
		for(String formId : formManufacturers.keySet() ){
			for( String manId : formManufacturers.get(formId)){
				fxManufacturers.add( new FormXManufacturer__c(FormId__c = formId, ManufacturerId__c = manId));
			}
		}
		
		if(fxManufacturers.size() > 0 )
			insert fxManufacturers;
	}
	
	public testMethod static void testIt(){
		
		(new Admin_BuildManufacturers(true)).buildManufacturers();
	}
}