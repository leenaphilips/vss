public abstract class StatusEmail{
    
    public String ClientCode {get; set;}
    
    public String getLogoUrl(){
    
        String logoName = ClientCode + '_Logo';
        List<Document> docs = [select id from Document where Name =: logoName];
        
        if( docs.size() == 0 ) return logoName;
        
        URL__c urls = URL__c.getOrgDefaults();
        
        //return URL.getSalesforceBaseUrl().toExternalForm()+'/servlet/servlet.ImageServer?id='+docs.get(0).Id+'&oid=' + UserInfo.getOrganizationId();
        return urls.baseForceUrl__c + '/servlet/servlet.ImageServer?id='+docs.get(0).Id+'&oid=' + UserInfo.getOrganizationId();
    }

}