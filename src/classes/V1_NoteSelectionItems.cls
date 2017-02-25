public with sharing class V1_NoteSelectionItems implements Comparable
{
					
	private String Backlog_Group,
			Case_ID,
			Case_Account,
			Component_Name,
			CR_ID,
			Fixed_In_Version,
			ID_Number,
			Item_Title,
			Matriarch_Name,
			Product_Version,
			Release_Notes,
			Request_ID,
			Source_Name,
			Sub_Component,
			Type_Name,
			sortByValue = null,
			thisCombinedItems;
	
	private V1_Release_Notes_Table_Content__c curContent;
	private List<V1_NoteSelectionItems> childItems;
					
	public String Backlog
	{
		get
		{
			return this.Backlog_Group;
		}
		set;
	}
	
	public String CaseID
	{
		get
		{
			return this.Case_ID;
		}
		set;
	}
	
	public String CaseAccount
	{
		get
		{
			return this.Case_Account;
		}
		set;
	}
	
	public String Component
	{
		get
		{
			return this.Component_Name;
		}
		set;
	}
	
	public String CRId
	{
		get
		{
			return this.CR_ID;
		}
		set;
	} 
	
	public String FixedInVersion
	{
		get
		{
			return this.Fixed_In_Version;
		}
		set;
	} 
	
	public String IDNumber
	{
		get
		{
			return this.ID_Number;
		}
		set;
	} 
	
	public String ItemTitle
	{
		get
		{
			return this.Item_Title;
		}
		set;
	} 
	
	public String Entitlement
	{
		get
		{
			return this.Matriarch_Name;
		}
		set;
	}
	
	public String ProductVersion
	{
		get
		{
			return this.Product_Version;
		}
		set;
	} 
	
	public String ReleaseNotes
	{
		get
		{
			return this.Release_Notes;
		}
		set;
	}
	
	public String RequestId
	{
		get
		{
			return this.Request_Id;
		}
		set;
	}
	
	public String Source
	{
		get
		{
			return this.Source_Name;
		}
		set;
	}
	
	public String SubComponent
	{
		get
		{
			return this.Sub_Component;
		}
		set;
	}
	
	public String Type
	{
		get
		{
			return this.Type_Name;
		}
		set;
	}
	
	public String SortBy
	{
		get
		{
			return this.sortByValue;
		}
		set
		{
			this.sortByValue = value;
		}
	}

	public String CombinedItems
	{
		get
		{
			return this.thisCombinedItems;
		}
		set;
	}
	
	public List<V1_NoteSelectionItems> AttachedItems
	{
		get
		{
			return this.childItems;
		}
		set
		{
			this.childItems = value;
		}
	}
	
	public void attachNewChild(V1_NoteSelectionItems itemToAttach)
	{
		if(this.childItems == null)
			this.childItems = new List<V1_NoteSelectionItems>();
			
		this.childItems.add(itemToAttach);
	}
					
	public V1_NoteSelectionItems(String productVersion, String component, String backlog, String matriarch)
	{
		this.Product_Version = productVersion;
		this.Component_Name = component;
		this.Backlog_Group = backlog;
		this.Matriarch_Name = matriarch;
		this.thisCombinedItems = this.Matriarch_Name + ',' + this.Product_Version + ',' + this.Component_Name + ',' + this.Backlog_Group;
		this.childItems = new List<V1_NoteSelectionItems>();
		
	}
					
	public V1_NoteSelectionItems(String groupByValue)
	{
		this.sortByValue = groupByValue;
		this.thisCombinedItems = groupByValue;
		childItems = new List<V1_NoteSelectionItems>();
	}
	
	public V1_NoteSelectionItems(V1_Release_Notes_Table_Content__c newContent)
	{
		this.curContent = newContent;
		this.Backlog_Group = newContent.V1_RN_BacklogGroup__c;
		this.Case_ID = newContent.V1_RN_Case_ID__c;
		this.Case_Account = newContent.V1_RN_CaseAccount__c;
		this.Component_Name = newContent.V1_RN_Component__c;
		this.CR_ID = newContent.V1_RN_CR_ID__c;
		this.Fixed_In_Version = newContent.V1_RN_FixedInVersion__c;
		this.ID_Number = newContent.V1_RN_IDNumber__c;
		this.Item_Title = newContent.V1_RN_ItemTitle__c;
		this.Matriarch_Name = newContent.V1_RN_Matriarch__c;
		this.Product_Version = newContent.V1_RN_ProductVersion__c;
		this.Release_Notes = newContent.V1_RN_ReleaseNotes__c;
		this.Request_ID = newContent.V1_RN_Request_ID__c;
		this.Source_Name = newContent.V1_RN_Source__c;
		this.Sub_Component = newContent.V1_RN_SubComponent__c;
		this.Type_Name = newContent.V1_RN_Type__c;
		this.sortByValue = newContent.V1_RN_IDNumber__c;
		this.thisCombinedItems = newContent.V1_RN_IDNumber__c;
		
	}
	
	public Integer compareTo(Object compareToObject)
	{
		V1_NoteSelectionItems compareToItem = (V1_NoteSelectionItems) compareToObject;
        if(this.SortBy == null)
        {
        	return (this.CombinedItems.compareTo(compareToItem.CombinedItems));     
        }
        else
        {
        	return this.SortBy.compareTo(compareToItem.SortBy);
        }
	}
}