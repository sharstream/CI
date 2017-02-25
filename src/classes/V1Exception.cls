public class V1Exception extends Exception 
{
//	private Dom.XmlNode rootNode;
	private String Href;
	private String ErrorMessage;

	public V1Exception(Dom.XmlNode rootNode, String attribute)
	{
        V1HttpErrorResponse v1Error = new V1HttpErrorResponse(rootNode, attribute);
		
		this.setMessage(v1Error.ToGenericErrorFormat());
	
	}
}