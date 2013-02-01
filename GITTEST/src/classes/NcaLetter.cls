public class NcaLetter extends StatusEmail {

    public String NcaLetterId {
        get;
        set{
            NcaLetterId = value;
            
            NcaLetter__c l = [select id, title__c, NcaId__c, ControlNumber__c, Header__c, Footer__c from NcaLetter__c where id = :NcaLetterId];
            
            if( l == null ) return;
            title = l.title__c;
            header = l.Header__c;
            footer = l.Footer__c;
            ControlNumber = l.ControlNumber__c+'';
            
            List<Rebate__c> rebates = new List<Rebate__c>([select id, FormId__r.PrimaryColor__c, FormId__r.ClientCode__c FROM Rebate__c where NcaId__c =: l.ncaId__c LIMIT 1]);
            if( rebates == null || rebates.isEmpty() ) return;
            
            primaryColor = rebates[0].FormId__r.PrimaryColor__c;
            ClientCode = rebates[0].FormId__r.ClientCode__c;
            
        }
    }
    
    public String title {get; private set; }
    public String header {get; private set; }
    public String footer {get; private set; }
    public String controlNumber {get; private set; }
    public String primaryColor {get; private set; }
    
    public List<NcaGroup__c> getGroups(){
    
        return [select GroupText__c, (Select LetterText__c FROM NCAText__r ORDER BY LineNumber__c ASC) 
            FROM NcaGroup__c 
            WHERE NcaLetterId__c = :NcaLetterId
            ORDER BY groupNumber__c ASC];
    
    }
}