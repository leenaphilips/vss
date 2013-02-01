public with sharing class Rep_SCL_FuelEfficiency implements ICsvReport {

    public static final String NAME = 'rep_scl_fuelefficiency';
    private static final String CLIENT_CODE = 'SCL';
    
    private static final Double[] EFF_RANGES = new Double[]{2.2, 2.46, 2.7};
    
    private static final String CD_FUEL = 'cd_fuel';
    private static final String WH_FUEL = 'wh_fuel';
    
    private static final Set<String> ELEC = new Set<String>{'', 'elec'};
    private static final Set<String> GAS = new Set<String>{'ngas', 'prop'};
    
    private Integer queryLimit;
    private Date InvoiceDate;
    private Integer InvoiceYear;
    private ReportDateHelper rdh;
    private boolean isTest = false; 
    
    public Rep_SCL_FuelEfficiency(){ this(false); }
    
    public Rep_SCL_FuelEfficiency(boolean test){
        isTest = test;
        queryLimit = isTest ? 10 : 100000;
        rdh = new ReportDateHelper();   
    } 
    
    public String getReportName(){ return NAME; }
    
    public String getReportLabel(){ return 'FuelEfficiency'; }
    
    public ICsvReport cloneReport(Boolean isTest){ return new Rep_SCL_FuelEfficiency(isTest); }
    
     //-- code is the Program (e.g. LIRF, LIDH)
    public Rep_ResultSet getResultSet(String code){
    
        //-- must have invoice date -- pick latest if none specified
        Date invoiceDate = rdh.getInvoiceDate();
        if( invoiceDate == null){
            Rep_DateLoader dp = new Rep_DownDateLoader();
            invoiceDate = dp.getMaxInvoiceDate(CLIENT_CODE);
        }
        
        System.debug('InvoiceDate: '+invoiceDate);
        if( invoiceDate == null ) return null;
        
        EfficiencySpec[] specs = loadSpecs(invoiceDate);
        System.debug('LOADED '+specs.size()+' SPECS');
        FuelSurvey[] surveys = loadSurveys(invoiceDate);
        System.debug('LOADED '+surveys.size()+' SURVEYS');
        
        Map<String, EfficiencySpec> specMap = new Map<String, EfficiencySpec>();
        Map<String, FuelSurvey> surveyMap = new Map<String, FuelSurvey>();
        
        for(EfficiencySpec spec : specs){
            System.debug('SPEC: '+spec);
            if( Utils.isEmpty( spec.binName ) ) continue;
            specMap.put( spec.rebateId, spec);
        }
        
        for(FuelSurvey survey : surveys){
            System.debug('SURVEY: '+survey);
            if( Utils.isEmpty( survey.binName)) continue;
            surveyMap.put( survey.rebateId, survey);
        }
        
        Map<String, Map<String, Integer>> binMap = new Map<String, Map<String, Integer>>();
        
        for(String rebateId : specMap.keySet()){
            EfficiencySpec spec = specMap.get(rebateId);
            FuelSurvey survey = surveyMap.get(rebateId);
            
            if( spec == null || survey == null ) continue;
            System.debug('Binning '+rebateId+'; spec: '+spec+'; survey: '+survey);
            binRebate(binMap, spec.binName, survey.binName);    
        }
        
        System.debug('BINMAP: '+binMap);
        
        Rep_ResultSet results = new Rep_ResultSet();
        
        String[] colNames = new List<String>{'WH - CD FUEL'};
        String[] dataColNames = new List<String>();
        Map<String, Integer> colTotals = new Map<String, Integer>();
        for(Integer i=0; i < EFF_RANGES.size(); i++){
            String colName = getEfficiencyBinName(i);
            colNames.add( colName );
            dataColNames.add( colName );
            colTotals.put(colName, 0);
        }
        colNames.add('Grand Total');
        
        results.setColNames(colNames);
        
        String[] dataRowNames = new String[]{'ELEC - ELEC', 'ELEC - GAS', 'GAS - ELEC'};
        for(String rowName : dataRowNames){
            String[] values = new List<String>{rowName};
            Integer rowTotal = 0;
            for(String colName : dataColNames){
                Integer value = getBinValue(binMap, colName, rowName);
                colTotals.put( colName, colTotals.get(colName)+ value);
                rowTotal += value;
                values.add(value+'');
            }
            values.add(rowTotal+'');
            results.addRow(values);
        }
        
        String[] totals = new List<String>{'Grand Total'};
        Integer gTotal = 0;
        for(Integer i=0; i < dataColNames.size(); i++){
            String colName = dataColNames[i];
            Integer total = colTotals.get(colName);
            totals.add(total + '');
            gTotal += total;
        }
        totals.add( gTotal + '');
        results.addRow(totals);
        return results;
    }
    
    private Integer getBinValue(Map<String, Map<String, Integer>> binMap, String outerBin, String innerBin){
        return binMap.containsKey(outerBin) && binMap.get(outerBin).containsKey(innerBin) ? binMap.get(outerBin).get(innerBin) : 0;
    }
    
    private void binRebate(Map<String, Map<String, Integer>> binMap, String outerBin, String innerBin){
        Map<String, Integer> innerMap = binMap.get(outerBin);
        if( innerMap == null ){
            binMap.put(outerBin, innerMap = new Map<String, Integer>());
        }
        
        Integer value = innerMap.get(innerBin);
        if( value == null ){
            value = 0;
        }
        innerMap.put(innerBin, value + 1);
    }
    
    private EfficiencySpec[] loadSpecs(Date invoiceDate){
        
        EfficiencySpec[] specs = new List<EfficiencySpec>();
        Date startDate = Date.newInstance( invoiceDate.Year(), 1, 1);
        
        for(Specifications__c[] specList : [
        	SELECT SpecificationValue__c, RebateDetailId__r.Id, RebateDetailId__r.RebateId__c 
            FROM Specifications__c 
            WHERE 
            	SpecificationCode__c = 'MEF' AND 
            	RebateDetailId__r.RebateId__r.FormCode__c = 'SCLCW2012' AND 
            	RebateDetailId__r.RebateId__r.ClientInvoiceDate__c >= :startDate AND
            	RebateDetailId__r.RebateId__r.ClientInvoiceDate__c <= :invoiceDate
            LIMIT :queryLimit]){
            
            for(Specifications__c spec : specList){
                try{
                    EfficiencySpec eSpec = new EfficiencySpec(spec.RebateDetailId__r.RebateId__c, Double.valueOf(spec.SpecificationValue__c));
                    setEfficiencyBin( eSpec );
                    specs.add(eSpec);
                } catch(Exception e){
                    System.debug('Exception while creating EfficiencySpec: '+e.getMessage());
                }
            }
        }
        return specs;
        
    }
    
    private void setEfficiencyBin(EfficiencySpec s){
        
        Integer binIndex = null; //-- will only be null if the value isnt found
        for(Integer i=0; i < EFF_RANGES.size(); i++){
        	System.debug(EFF_RANGES[i]+' vs. ' + s.value);
            if( s.value < EFF_RANGES[i] ){
                binIndex = i - 1;
                break;
            }
        }
        
        if( binIndex == null ) binIndex = EFF_RANGES.size() - 1;
        if( binIndex < 0 ) return;
        
        s.binName = getEfficiencyBinName(binIndex);
        System.debug(s.value+' @ '+binIndex+': '+s.binName);
    }
    
    private String getEfficiencyBinName(Integer index){
        if( index < 0 || index >= EFF_RANGES.size()) return null;
        return EFF_RANGES[index] + ' ' + (index + 1 >= EFF_RANGES.size() ? '+' : 'to '+EFF_RANGES[index+1])+' MEF';
    }
    
    private FuelSurvey[] loadSurveys(Date invoiceDate){
        FuelSurvey[] surveys = new List<FuelSurvey>();
        Date startDate = Date.newInstance( invoiceDate.Year(), 1, 1);
        for(Rebate__c[] rebateList : [SELECT id, 
        		(SELECT ColumnName__c, Answer__c FROM RebateSurveys__r WHERE ColumnName__c IN ('CD_FUEL', 'WH_FUEL')) 
            FROM Rebate__c 
            WHERE 
            	ClientInvoiceDate__c >= :startDate AND
				ClientInvoiceDate__c <= :invoiceDate AND 
            	FormCode__c = 'SCLCW2012' 
            LIMIT :queryLimit]){
            
            for(Rebate__c r : rebateList){
                if( r.RebateSurveys__r == null || r.RebateSurveys__r.isEmpty()){
                    continue;
                }
                
                FuelSurvey fSurvey = new FuelSurvey( r.Id, '', '' );
                for(RebateSurvey__c rs : r.RebateSurveys__r){
                    if( CD_FUEL.equalsIgnoreCase( rs.ColumnName__c )){
                        fSurvey.cdFuel = Utils.toLowerCase(rs.Answer__c);
                    }
                    if( WH_FUEL.equalsIgnoreCase(rs.ColumnName__c)){
                        fSurvey.whFuel = Utils.toLowerCase(rs.Answer__c);
                    }
                }
                
                setFuelBin(fSurvey);
                surveys.add(fSurvey);
            }
        }
        return surveys;
    }
    
    private void setFuelBin(FuelSurvey fs){
        if( ELEC.contains(fs.cdFuel) && ELEC.contains(fs.whFuel) ){
            fs.binName = 'ELEC - ELEC';
            return;
        }
        
        if( GAS.contains(fs.whFuel) && ELEC.contains(fs.cdFuel)){
            fs.binName = 'GAS - ELEC';
            return;
        }
        
        if( ELEC.contains(fs.whFuel) && GAS.contains(fs.cdFuel)){
            fs.binName = 'ELEC - GAS';
            return;
        }
    }
    
    class FuelSurvey {
        public String whFuel {get; set;}
        public String cdFuel {get; set;}
        public String binName {get; set;}
        public String rebateId {get; set;}
        
        public FuelSurvey(String rebateId, String wh, String cd){
            this.rebateId = rebateId;
            this.whFuel = wh;
            this.cdFuel = cd;
        }
    }
    
    class EfficiencySpec {
        public Double value {get; set; }
        public String rebateId {get; set; } 
        public String binName {get; set; }
        
        public EfficiencySpec(String rebateId, Double value){
            this.rebateId = rebateId;
            this.value = value;
        }
    }
}