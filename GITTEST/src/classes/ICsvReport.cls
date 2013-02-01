public interface ICsvReport {

	String getReportName();
	
	String getReportLabel();
	
	Rep_ResultSet getResultSet(String formCode);
	
	ICsvReport cloneReport(Boolean isTest);

}