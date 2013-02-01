public with sharing class BulkDelete {
  
    public List<SelectOption> objectsList;
  public String selectedObject{get;set;}
  public Integer deleteCount{get;set;}

    public BulkDelete(){
    }
    public void init(){
         objectsList = new List<SelectOption>();
         objectsList.add(new SelectOption('','---Select Object---'));           

         Map<String, Schema.SObjectType> gd = Schema.getGlobalDescribe();
         Set<String> objectKeys = gd.keySet();
         for(String objectKey: objectKeys) {              
             Schema.SobjectType sobjecttype = gd.get(objectKey);
             Schema.DescribeSObjectResult r = sobjecttype.getDescribe();
             if((r.getName()).contains('__c'))
                 objectsList.add(new SelectOption(r.getName(), r.getLabel()));
       }
    }

    public List<SelectOption> getobjectsList(){
        init();
        return objectsList;
    }

    public PageReference Submit(){

        List<SObject> objectRecords = new List<SObject>();
        Integer numberofRecords;

        if(selectedObject != null){
            if (deleteCount == 0) {
                String query = 'SELECT ID from ' + selectedObject;
                objectRecords = DataBase.Query(query);
            }else{
                String query = 'SELECT ID from ' + selectedObject + ' LIMIT ' + deleteCount;    
                objectRecords = DataBase.Query(query);            
            }
            try{
                numberofRecords = objectRecords.size();
                Delete objectRecords;
            }Catch(DMLException e){
                 ApexPages.addMessage( new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage()));
            }        
        } 
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Deleted ' + numberofRecords + ' records from the ' + selectedObject + ' Object'));
        return null;    
    }
    
    public PageReference cancel(){    
          return null;         
    }

  testmethod static void BulkDeleteTest() {
     BulkDelete md = new BulkDelete();
    //Test getobjectslist - this also calls and test init() 
    List<SelectOption> TestList = md.getobjectsList();
    //Set variables for test
       md.selectedObject='Rebate__c';
       md.deleteCount = 1;
       //Test submit method where record count is 0 which is all records
       system.assertEquals(null, md.submit());
       //Reset count to >0 for next test which is the specified number of records
       //md.deleteCount = 1;
       //Test submit method where record count is > 0
       //system.assertEquals(null, md.submit());
      system.assertEquals(null, md.cancel());
  }

}