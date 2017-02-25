public class V1HttpError
{
	public V1HttpError(Dom.XmlNode childNode)
	{
		ExceptionType = childNode.getAttribute('class', null);
        Message = childNode.getChildElement('Message', null).getText();
	}
	
	public String ExceptionType {get; private set;}
	public String Message {get; private set;}
}