public class Admin_CleanModels{

  private boolean isTest = false;
  
  
  public Admin_CleanModels(){ this(false); }
  public Admin_CleanModels(boolean isTest){ this.isTest = isTest; }
  
  public PageReference clean(){
      
      Integer resLimit = isTest ? 10 : 1000000;
      
      Map<String, String> cleaner = new Map<String, String>();
      for(DataCleanup__c dc : [select originalValue__c, newValue__c from DataCleanup__c where classification__c = 'Manufacturer' LIMIT :resLimit]){
          cleaner.put( dc.originalValue__c.toLowerCase(), dc.newValue__c);
      }

      List<Model__c> updates = new List<Model__c>();
      for(List<Model__c> models : [select Id, Manufacturer__c from Model__c LIMIT :resLimit]){
          for(Model__c m : models){
              String newVal = cleaner.get( m.manufacturer__c != null ? m.manufacturer__c.toLowerCase() : null );
              if( newVal != null ){
                  m.manufacturer__c = newVal;
                  updates.add(m);
              }
          }
      }

      if( updates.size() > 0 )
          update updates;

      return null;

  }
}