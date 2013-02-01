public class DefaultDocumentViewer extends ExternalDocumentViewer {
	public override boolean canDisplay(String suffix){ return true; }
	
	public override Component.Apex.OutputPanel displayDocument(String url){
		Component.Apex.OutputPanel panel = new Component.Apex.OutputPanel();
		panel.childComponents.add( new Component.c.DefaultViewer() );
		return panel;
	}
}