/*
 * 2012.07.12:CEV::Moved to class to support multiple before triggers
 
 * 2012.07.11:CEV::Changed from Workflow -> Trigger to
 *    a) reduce liklihood of accidental batch updates using IsSentFromPdx (MUST BE MOVED TO OTHER BEFORE TRIGGER)
 *    b) check for FormParamter existence that controls sending emails / program
 *
 */
public class Trigger_RebateDetail_UpdateLookups extends Trigger_Class {

    public override boolean canHandleTrigger(){
        return (Trigger.isUpdate || Trigger.isInsert) && Trigger.isBefore;
    }

    public override void processTrigger(){
        MapList measureDetails = new MapList(true);
        MapList modelDetails = new MapList(false);
        
        for(RebateDetail__c d: (RebateDetail__c[])Trigger.new){
            d.MeasureId__c = null;
            d.ModelId__c = null;
            System.debug('FormID: '+d.FormId__c);
            
            measureDetails.addObject(d.FormId__c, d);
            modelDetails.addObject(d.modelNumber__c, d);
            
            if( d.isSentFromPdx__c ){
                d.isSentFromPdx__c = false;
                d.IsCustomerPayable__c = !'na'.equalsIgnoreCase( d.Manufacturer__c ) || !'na'.equalsIgnoreCase( d.ModelNumber__c );
            }
        }
        
        List<Measure__c> measures = [select id, MeasureCode__c, MeasureCategoryId__r.Name, FormId__c from Measure__c where FormId__c IN :measureDetails.keySet()];
    
        if( !measures.isEmpty() ){
            for(Measure__c m : measures){
                System.debug('Returned ID: '+m.FormId__c);
                String id = m.FormId__c;
                if( measureDetails.containsKey(id.substring(0,15))){
                    for(Object o : measureDetails.get(id.substring(0,15))){
                        RebateDetail__c d = (RebateDetail__c)o;
                        if( d.MeasureCode__c == m.MeasureCode__c ){
                            d.MeasureId__c = m.id;
                        }
                    }
                }
            }
        }
        
        List<Model__c> models = [select Id, ModelNumber__c, Manufacturer__c FROM Model__c WHERE ModelNumber__c IN :modelDetails.keySet()];
        
        if( !models.isEmpty() ){
            for(Model__c m : models){
                
                if( modelDetails.containsKey(m.modelNumber__c)){
                    for(Object o : modelDetails.get(m.modelNumber__c)){
                        RebateDetail__c d = (RebateDetail__c)o;
                        if( d.Manufacturer__c == m.Manufacturer__c ){
                            d.ModelId__c = m.id;
                        }
                    }
                }
            }
        }    
    }
}