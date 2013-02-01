/*
    CEV:2012.08.30::Controller for ImageViewer for image documents stored in a repository
*/
public class ImageDocumentViewer extends ExternalDocumentViewer {

    private static final String[] IMAGE_TYPES = new String[]{'png', 'jpg', 'jpeg', 'gif', 'bmp'};
    
    public override boolean canDisplay(String suffix){
        if( Utils.isEmpty(suffix)) return false;
        
        for(String ft : IMAGE_TYPES){
            if( suffix.equalsIgnoreCase(ft)) return true;
        }
        
        return false;
    }
    
    //-- creates an output panel and adds the ImageViewer component 
    public override Component.Apex.OutputPanel displayDocument(String url){
        Component.Apex.OutputPanel panel = new Component.Apex.OutputPanel();
        
        Component.c.ImageViewer viewer = new Component.c.ImageViewer();
        viewer.URL = url;
        panel.childComponents.add(viewer);
        return panel;
    }
    
}