public class Utils{
  
  public static ApexPages.Message createErrorMessage(String m){ return new ApexPages.Message(ApexPages.Severity.ERROR, m); }    
    
  public static Boolean isEmpty(String s){ return s == null || s.trim().equals(''); }
  
  public static String nullValue(String s, String nullValue){ return isEmpty(s) ? nullValue : s; }
  
  public static String toLowerCase(String s){ return isEmpty(s) ? s : s.toLowerCase(); }
  
  public static SObject getFirstOrNull(SObject[] objects){
        if( objects != null && objects.size() > 0 )
            return objects[0];
        return null;
  }  
  
  public static String concat(Object[] words, String delim){
    String vals = '';
    
    for(Integer i=0; i < words.size(); i++){
        vals += String.valueOf(words[i]) + (i < words.size() -1 ? delim : '');
    }
    
    return vals;
  }
  
  public static String concat(Object[] words){ return concat(words, ', '); }
  
  public static String format(Date d){ return d != null ? d.month()+'/'+d.day()+'/'+d.year() : ''; }
  
    
  //-- FDC has a problem matching the full email regex against the string - 'regex too complicated' is the error I get.  Splitting on the '@' and parsing
  //    appears to work OK.
  //String regex = '^[0-9A-z_-]+(\\.?[0-9A-z_-]+)*@([0-9A-z_-]+\\.)+[A-z]{2,}$';
  public static Boolean isValidEmail(String email){
    
    //--per DK
    if( Utils.isEmpty(email)) return true;
    
    String[] parts = email.split('@');
    
    String pre = '^[0-9A-z_-]+(\\.?[0-9A-z_-]+)*$';
    String post = '^([0-9A-z_-]+\\.)+[A-z]{2,}$';
    
    return parts.size() == 2 && Pattern.compile(pre).matcher(parts[0]).matches() && Pattern.compile(post).matcher(parts[1]).matches();
  }
  
  public static String toCurrency(Double d){
    if( d== null ) return '';
    
    String s = String.valueOf(d);
    if( s.indexOf('.') == -1 ) return '$'+s+'.00';
    if( s.indexOf('.') == s.length() - 2) return '$'+s+'0';
    return '$'+s;   
  }
    
  public static String toDateString(Date d){
        if( d == null ) return '';
        return d.month() + '/' + d.day() + '/' + d.year();
  }
  
  public testMethod static void thisIsStupid(){
    createErrorMessage('TEST');
    isEmpty('TEST');
    getFirstOrNull( new SObject[]{ new Contact() } );
    concat( new String[]{'This', 'is', 'dumb'});
    isValidEmail('cvitone@gmail.com');
    toCurrency(31.234D);
    toDateString( Date.newInstance(2011,01,01));
    
  }
  
  public static String getHierarcicalUrl(PageReference page){
    String url = page.getUrl();
    if( !Utils.isEmpty(url) && url.indexOf('?') >= 0 ){
        return url.substring(0, url.indexOf('?'));
    }
    return null;
  }
  
  public static void copyTo(SObject src, SObject tgt, String objType){
    boolean isInsert = tgt.id == null;
    for(Schema.Sobjectfield f : Schema.getGlobalDescribe().get(objType.toLowerCase()).getDescribe().Fields.getMap().values()){
        Schema.DescribeFieldResult r = f.getDescribe();
        if( (isInsert && r.isCreateable()) || (!isInsert && r.isUpdateable()) ){
            tgt.put( r.getName(), src.get(r.getName() ) );
        }
    }
  }
  
  //--2012.06.25::Returns the Org Email ID of the sender for the form/Act depending on code value.  
  //    Order of search is Form/Act Sender, Def Client Sender, and EFI default.
    public static final String EMAIL_SFX = '-rebates@efi.org';
    public static ID getEmailOrgId(String code){
    
        System.debug('CODE: '+code);
    
        //-- find the default sender
        Email__c emails = Email__c.getOrgDefaults();
        
        Form__c[] forms = [select id, clientCode__c, emailSender__c  FROM Form__c where formCode__c =: code];
        Account[] accounts = [select id, clientCode__c, emailSender__c FROM Account where clientCode__c =: code];
        
        String objEmailSender = forms.isEmpty() ? accounts[0].emailSender__c : forms[0].emailSender__c;
        String clientCode = forms.isEmpty() ? accounts[0].ClientCode__c : forms[0].ClientCode__c;
        
        String[] senderAddresses = new String[]{ objEmailSender, clientCode+EMAIL_SFX, emails.DefaultSender__c};

        for(String sender : senderAddresses){
            for(OrgWideEmailAddress owa : [select id, address from OrgWideEmailAddress]){
                if( owa.address.equalsIgnoreCase(sender)){
                    return owa.id;
                }
            }
        }
        
        return null;
    }
    
  public static String createSessionId(){
        SessionData__c sessionObj = new SessionData__c(SessionId__c = 'SessionKey', FieldName__c = 'SessionKey');
        insert sessionObj;
        return sessionObj.id;
  }
  
  public static ID[] saveSessionData(String sessionId, String key, String value){
    Map<String, String> results = saveSessionData(sessionId, new Map<String, String>{key=>value});
    if( results != null )
        return new String[]{ results.get(key) };
    return null;
  }
  
  public static Map<String, String> saveSessionData(String sessionId, Map<String, String> values){
    
    if( values == null || values.isEmpty()) return null;
    
    SessionData__c[] data = new List<SessionData__c>();
    for(String key : values.keySet()){
        data.add( new SessionData__c(Key__c=sessionId + '|' + key, SessionId__c=sessionId, FieldName__c = key, FieldValue__c = values.get(key)));
    }
    Database.upsert(data, SessionData__c.Fields.Key__c,true);
    
    Map<String, String> results = new Map<String, String>();
    for(SessionData__c sd : data){
        results.put( sd.FieldName__c, sd.id);
    }
    return results;
  }
  
  public static Map<String, String> getSessionData(String sessionId){
    Map<String, String> results = new Map<String, String>();
    for(SessionData__c sd : [select FieldName__c, FieldValue__c from SessionData__c where sessionId__c =: sessionId]){
        results.put(sd.FieldName__c, sd.FieldValue__c);
    }
    return results;
  }
  
  public static String getSessionData(String sessionId, String fieldName){
    return getSessionData(sessionId).get(fieldName);
  }
    public static String getWeekdayOpenTime(Integer offset){
        return buildTime(EFI__c.getOrgDefaults().CustomerServiceWeekdayOpen__c.intValue(), offset);
    }
    
    public static String getWeekdayCloseTime(Integer offset){
        return buildTime(EFI__c.getOrgDefaults().CustomerServiceWeekdayClose__c.intValue(), offset);
    }
    
    public static String getWeekendOpenTime(Integer offset){
        return buildTime(EFI__c.getOrgDefaults().CustomerServiceWeekendOpen__c.intValue(), offset);
    }
    
    public static String getWeekendCloseTime(Integer offset){
        return buildTime(EFI__c.getOrgDefaults().CustomerServiceWeekendClose__c.intValue(), offset);
    }
    
    private static String buildTime(Integer base, Decimal offset){
        Integer open = base + (offset != null ? offset.intValue() : 0);
        Integer openHours = (Integer)(open/100);
        
        Integer minutes = open - (openHours * 100);
        String postfix = 'AM';
        if( openHours >= 12 ){
            if( openHours > 12 ) openHours -= 12;
            postfix = 'PM';
        }
        
        String minutesString = (minutes < 10 ? '0' : '') + minutes;
        
        return openHours + (minutes > 0 ? minutesString : '') + ' '+postfix;    
    }

/*    
    public static String buildSQL(String objName){
        String[] fields = new List<String>();
        for(Schema.Sobjectfield f : Schema.getGlobalDescribe().get(objName.toLowerCase()).getDescribe().Fields.getMap().values()){
            if( f.getDescribe().isCreateable()){
                fields.add( f.getDescribe().getName() );
            }
        }
        
        return 'SELECT '+Utils.concat(fields, ', ')+' FROM '+objName;
    }
    */
    
    public static String buildSQL(String objName){
        List<Schema__c> fields = [select fieldName__c from Schema__c WHERE tableName__c = :objName ORDER BY fieldName__c ASC];
        if( fields.isEmpty() ) return null;
        
        String[] fieldNames = new List<String>();
        for(Schema__c s : fields){
            fieldNames.add( s.FieldName__c );
        }
        
        return 'SELECT '+Utils.concat(fieldNames, ', ')+' FROM '+objName;
    }
    
    //-- makes binary size into human readable
    private static final String[] SIZE_SUFFIX = new String[]{' B', ' KB', ' MB', ' GB'};
    public static String binaryToHuman(Decimal size){
        if( size == null ) return '-1';
        Integer factor = 0;
        while( size > 1024 ){
            size /= 1024;
            factor++;
        }
        return size.setScale(2)+SIZE_SUFFIX[factor];   
    }
    
    
//-- This is required because triggers cannot delete the objects on which they operate. @future is limited to 200x#license/day
//      so DO NOT USE THIS METHOD unless it is truly necessary.
  @future
  public static void deleteSObjects(Set<Id> ids, String objType){
    SObject[] l = new List<SObject>();
    for(ID sid : ids)
        l.add( Schema.getGlobalDescribe().get(objType).newSObject(sid) );
    delete l;
  }
}