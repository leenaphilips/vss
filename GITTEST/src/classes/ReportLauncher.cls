public class ReportLauncher {
	
	private static Map<String, ICsvReport> objectMap = new Map<String, ICsvReport>{
		Rep_Pse_InvSum.NAME => new Rep_Pse_InvSum(),
		Rep_Pse_Markdown.NAME => new Rep_Pse_Markdown(),
		Rep_Pse_MouExport.NAME => new Rep_Pse_MouExport(),
		Rep_Pse_SalesByPart.NAME => new Rep_Pse_SalesByPart(),
		Rep_Sge_InvSum.NAME => new Rep_Sge_InvSum(),
		Rep_Sge_Markdown.NAME => new Rep_Sge_Markdown(),
		Rep_Sge_MouExport.NAME => new Rep_Sge_MouExport(),
		Rep_Sge_SalesByPart.NAME => new Rep_Sge_SalesByPart(),
		Rep_Pse_RebatesByInvoice.NAME => new Rep_Pse_RebatesByInvoice(),
		Rep_Pse_Allocation.NAME => new Rep_Pse_Allocation(),
		Rep_Lipa_Summary.NAME => new Rep_Lipa_Summary(),
		Rep_Lipa_ProductRebates.NAME => new Rep_Lipa_ProductRebates(),
		Rep_SCL_Summary.NAME => new Rep_SCL_Summary(),
		Rep_SCL_ProductRebates.NAME => new Rep_SCL_ProductRebates(),
		Rep_SCL_FuelEfficiency.NAME => new Rep_SCL_FuelEfficiency()
	};
	
	private ICsvReport report;
	private Boolean isTest;
	
	public ReportLauncher(){
		this(false);
	}
	
	public ReportLauncher(Boolean isTest){
		this.isTest = isTest;	
		init();
	}
	
	private void init(){
		String name = ApexPages.currentPage().getParameters().get('ReportName');
		report = objectMap.get( name != null ? name.toLowerCase() : null );
		if( report != null ){
			report = report.cloneReport(isTest);
		}
	}
	
	public String getReportLabel(){
		if( report == null )
			init();
		
		if( report == null ) 
			return 'CsvReport';
			
		return report.getReportLabel();
	}
	
	public Rep_ResultSet getResultSet(){
		if( report == null ) 
			init();
		if( report == null ) 
			return null;
		
		String code = ApexPages.currentPage().getParameters().get('Program');
		if( Utils.isEmpty(code))
			code = ApexPages.currentPage().getParameters().get('FormCode');
		return report.getResultSet(code);
	}
}