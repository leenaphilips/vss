/*
    Interface for VisualForce component that can display a file type(s).  Used to display document inside of FDC page
*/
public abstract class ExternalDocumentViewer {

    public abstract boolean canDisplay(String fileType);
    
    public abstract Component.Apex.OutputPanel displayDocument(String url); 
    
    private static List<ExternalDocumentViewer> viewers = new List<ExternalDocumentViewer>{
        new ImageDocumentViewer(), 
        new DefaultDocumentViewer()
    };
    
    public static ExternalDocumentViewer findViewer(ExternalDocument doc){
        
        for(ExternalDocumentViewer v : viewers){
            if( v.canDisplay(doc.getFileSuffix()) ){
                return v;
            }
        }
        return null;
    }
}