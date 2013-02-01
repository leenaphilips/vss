public abstract class Trigger_Class{
    
    public void process(){
        if( !Trigger.isExecuting ) throw new TriggerException();
        processTrigger();
    }
    
    public boolean canHandle(){
        if( !Trigger.isExecuting ) throw new TriggerException();
        return canHandleTrigger();
    }

    protected abstract void processTrigger();
    protected abstract boolean canHandleTrigger();
}