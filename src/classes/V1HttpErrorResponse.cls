public with sharing class V1HttpErrorResponse 
{
	public V1HttpErrorResponse(Dom.XmlNode rootNode, string AttributeDefinition)
	{
		Errors = new List<V1HttpError>();
		
		Href = rootNode.getAttribute('href', null);
		ErrorMessage = rootNode.getChildElement('Message', null).getText();
		
		List<Dom.XmlNode> exceptions = new List<Dom.XmlNode>(rootNode.getChildElements());
		
		for (Dom.XmlNode node : exceptions)
		{
			if (node.getName() == 'Message') // we don't want the top level message
				continue;
       		Errors.add(new V1HttpError(node));
		}
	}

	public List<V1HttpError> Errors {get; private set;}
	public String ErrorMessage {get; private set;}
	public String Href {get; private set;}
	
	public String ToEmailFormat()
	{
		String emailBody = '<h3>VersionOne Error: ' + href + '</h3><br/><br/>Error message: <br/><br/>';
		
		for(V1HttpError v1error: Errors)
		{
			emailBody += v1error.ExceptionType + ' ' + v1error.Message + '<br/>';
		}
		return emailBody;
	}
	
	public String ToGenericErrorFormat()
	{
		String errorBody = 'VersionOne Error:<br/><br/>';
		
		for(V1HttpError v1error: Errors)
		{
			errorBody += ' ' + v1error.Message + '<br/><br/>';
			break;
		}
		return errorBody;
	}
	
}