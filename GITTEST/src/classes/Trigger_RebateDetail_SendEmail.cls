/*
 * Detects changes to RebateDetail.DetailStatus and sets Rebate.SendStatusEmail IFF
 *    1. The DetailStatus changed
 *    2. The Associated Form is Active
 *    3. There exists an associated FormParameters corresponding to the DetailStatus with a value of 'true' (or any other Boolean.valueOf recognized value)
      4. The rebate is sentfrompdx
      5. The detail is customer payable
 *
 * 2012.07.12:CEV::Moved to class to support multiple before triggers
 *
 * 2012.07.11:CEV::Changed from Workflow -> Trigger to
 *    a) reduce liklihood of accidental batch updates using IsSentFromPdx (MUST BE MOVED TO OTHER BEFORE TRIGGER)
 *    b) check for FormParamter existence that controls sending emails / program
 *
 */
public class Trigger_RebateDetail_SendEmail extends Trigger_Class {

    //-- allows for actual trigger to listen for more events than this handler can actually use
    public override boolean canHandleTrigger(){
        return (Trigger.isUpdate || Trigger.isInsert) && Trigger.isBefore;
    }

    
    public override void processTrigger(){
    
        //-- holds the rebateID -> Set of detail statuses
        Map<ID, Set<String>> rebateStatuses = new Map<ID, Set<String>>();

        for(Integer i =0; i < Trigger.size; i++){
            
            RebateDetail__c oldDetail = Trigger.isUpdate ? (RebateDetail__c)Trigger.old[i] : null;
            RebateDetail__c newDetail = (RebateDetail__c)Trigger.new[i];
            
            //-- check for status change and that the detail is payable to the customer and that this event was triggered from PDX
            if( newDetail.isSentFromPdx__c && newDetail.isCustomerPayable__c && (oldDetail == null || oldDetail.DetailStatus__c != newDetail.DetailStatus__c) ){
                Set<String> statuses = rebateStatuses.get( newDetail.rebateId__c );
                if( statuses == null ){
                    rebateStatuses.put( newDetail.rebateId__c, statuses = new Set<String>());
                }
                statuses.add( Utils.toLowerCase(newDetail.DetailStatus__c) );
            }
        }
        System.debug('RebateStatuses: '+rebateStatuses);
        
        //-- if there are no matching  statuses then exit
        if( rebateStatuses.size() == 0 ) return;
        
        //-- look up formIds
        Map<ID, ID> rebateToFormIds = new Map<ID, ID>();

        for(Rebate__c r : [select Id, FormId__c FROM Rebate__c where FormId__r.IsActive__c = true AND id in: rebateStatuses.keySet()]){
            rebateToFormIds.put( r.id, r.FormId__c );
        }
        
        System.debug('rebatesToForms: '+rebateToFormIds);
        if( rebateToFormIds.isEmpty() ) return;
        
        //-- holds the list of statuses defined in the formparameter that are configured to receive emails
        IndexedMap emailMap = new IndexedMap();
        for(FormParameter__c p : [select id, FormId__c, SelectorName__c, ParameterValue__c FROM FormParameter__c WHERE ParameterName__c = 'StatusEmail' and FormId__c in :rebateToFormIds.values()]){
            //System.debug('Setting Object: '+p.formId__c+', '+p.ParameterValue__c+', '+p.SelectorName__c);
            emailMap.setObject( p.formId__c, Utils.toLowerCase(p.SelectorName__c), p.ParameterValue__c );
        }
        
        System.debug('EmailMap: '+emailMap);
        if( emailMap.getSize() == 0 ) return;
        
        Map<ID, Rebate__c> rebates = new Map<ID, Rebate__c>();
        //-- look at all rebates, find the form parameters for the associated form
        for(ID rebateId : rebateStatuses.keySet()){
            ID formId = rebateToFormIds.get(rebateId);
            if( formId == null ) continue;
            
            //-- look for the first parameter that can be cast to true.  If found, update the rebate and then exit (no need to process the rest)
            for(String status : rebateStatuses.get(rebateId)){
                String sendEmail = (String)emailMap.getValue(formId, status);
                if( sendEmail != null && Boolean.valueOf( sendEmail )){
                    rebates.put(rebateId, new Rebate__c( id = rebateId, SendStatusEmail__c = true ));
                    break;
                }
            }
        }
        
        System.debug('rebates: '+rebates);
        if( !rebates.isEmpty() ){
            update rebates.values();
        }
    }
}