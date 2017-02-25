public class V1_RN_NoteSelectionItemsListing 
{
	public static final String		IS_BLANK_SPEC	= 'IS_BLANK';
	
	private String groupBySpec;

	private List<V1_Release_Notes_Table_Content__c> resultsList; 
	private List<V1_NoteSelectionItems> displayList;
	private List<V1_NoteSelectionItems> prodFilterList, versionFilterList, componentFilterList, backlogFilterList;
	
	private List<V1_NoteSelectionItems> groupedPDFListing;
	private List<V1_Release_Notes_Table_Content__c> rNotesListForPDF;
	
	private List<V1_NoteSelectionItems> rNotesPDFDisplayObject;
		
	private Set<String> allRNDisplaySelectedProducts;
	private Set<String> allRNDisplaySelectedVersions;
		
	public enum GroupByOptions { BacklogGroup, Component, SubComponent }
	
	public V1_RN_NoteSelectionItemsListing(Set<String> matriarchSet)
	{
		this.prodFilterList = new List<V1_NoteSelectionItems>();
		this.resultsList = [select V1_RN_ItemTitle__c, V1_RN_IDNumber__c, V1_RN_BacklogGroup__c, V1_RN_CaseAccount__c, V1_RN_Source__c,
				V1_RN_Matriarch__c, V1_RN_Component__c, V1_RN_SubComponent__c, V1_RN_ProductVersion__c, V1_RN_ReleaseNotes__c, 
				V1_RN_Case_ID__c,V1_RN_Request_ID__c, V1_RN_CR_ID__c, V1_RN_Type__c, V1_RN_FixedInVersion__c
			from V1_Release_Notes_Table_Content__c
			where V1_RN_Matriarch__c IN :matriarchSet];
				
		System.debug('Release notes total: ' + this.resultsList.size() + ' for matriarch set: ' + matriarchSet);
		getProductsForDisplay(matriarchSet);
		setNoteSelectionItemDisplayListing();
		setupSelectionListings();
		
	}
    	
	private void setupSelectionListings()
	{
		getVersionsForDisplay();
		getComponentsForDisplay();
		getBacklogForDisplay();
	}

	private void getProductsForDisplay(Set<String> allowedProducts)
	{
		V1_NoteSelectionItems currentItem;
		Set<String> filterCompare = new Set<String>();
		Set<String> prodFilterCompare = new Set<String>();
		for(V1_Release_Notes_Table_Content__c curItem: this.resultsList)
		{
			System.debug('Table item: ' + curItem.V1_RN_ProductVersion__c + 
			', ' + curItem.V1_RN_Component__c +
			', ' + curItem.V1_RN_BacklogGroup__c +
			', ' + curItem.V1_RN_Matriarch__c);
			currentItem = new V1_NoteSelectionItems(curItem.V1_RN_ProductVersion__c, curItem.V1_RN_Component__c, 
					curItem.V1_RN_BacklogGroup__c, curItem.V1_RN_Matriarch__c);
			String newFilter = curItem.V1_RN_ProductVersion__c + ',' + curItem.V1_RN_Matriarch__c;
			// Don't have it, should it be added?
			if(!prodFilterCompare.contains(currentItem.Entitlement))
			{
				// Part of user's entitlement?
				if(!allowedProducts.contains(currentItem.Entitlement))
				{
					System.debug('Product '+ currentItem.Entitlement + ' is not part of user\'s entitlement');
					continue;
				}
				currentItem.SortBy = currentItem.Entitlement;
				this.prodFilterList.add(currentItem);
				prodFilterCompare.add(currentItem.Entitlement);
				System.debug('Added ' + currentItem.Entitlement + ' to product filter list');
			}
			else
				System.debug('Item ' + currentItem.Entitlement + ' already in the Product filter list');
		}
		this.prodFilterList.sort();
		System.debug('Prod Filter list size: ' + this.prodfilterList.size());
	}

	private void getVersionsForDisplay()
	{
		Set<String> filterCompare = new Set<String>();
		this.versionFilterList = new List<V1_NoteSelectionItems>();
 		for(V1_NoteSelectionItems curItem: this.displayList)
		{

			System.debug('Table item: ' + curItem.ProductVersion);
   			
			// Don't have it, should it be added?
			if(!filterCompare.contains(curItem.ProductVersion))
			{
				filterCompare.add(curItem.ProductVersion);
				curItem.SortBy = curItem.ProductVersion;
				this.versionFilterList.add(curItem);
				System.debug('Added ' + curItem.Entitlement + ' to version filter list');
			}
			else
				System.debug('Item ' + curItem.Entitlement + ' already in the Version filter list');
    			
		}
		this.versionFilterList.sort();
		System.debug('Version Filter list size: ' + this.versionFilterList.size());
	}

	private void getComponentsForDisplay()
	{
		Set<String> filterCompare = new Set<String>();
		this.componentFilterList = new List<V1_NoteSelectionItems>();
		V1_NoteSelectionItems newItem;
		for(V1_NoteSelectionItems curItem: this.displayList)
		{

			System.debug('Table item: ' + curItem.Component);
		
	    	if(curItem.Component == null || curItem.Component == '')
			{
				newItem = new V1_NoteSelectionItems('', IS_BLANK_SPEC, '', '');
			}
			else
				newItem = curItem;
			
			// Don't have it, should it be added?
			if(!filterCompare.contains(newItem.Component))
			{
				filterCompare.add(newItem.Component);
				newItem.SortBy = newItem.Component;
				this.componentFilterList.add(curItem);
				System.debug('Added ' + newItem.Component + ' to component filter list');
			}
		}
		this.componentFilterList.sort();
		System.debug('Component Filter list size: ' + this.componentFilterList.size());
	}

	private void getBacklogForDisplay()
	{
		String tempValue;
		Set<String> filterCompare = new Set<String>();
		V1_NoteSelectionItems newItem;
		this.backlogFilterList = new List<V1_NoteSelectionItems>();
		for(V1_NoteSelectionItems curItem: this.displayList)
		{

			System.debug('Table item: ' + curItem.Backlog);

	    	if(curItem.Backlog == null || curItem.Backlog == '')
			{
				newItem = new V1_NoteSelectionItems('', '', IS_BLANK_SPEC, '');
			}
			else
				newItem = curItem;

			// Don't have it, should it be added?
			if(!filterCompare.contains(newItem.Backlog))
			{
				filterCompare.add(newItem.Backlog);
				newItem.SortBy = newItem.Backlog;
				this.backlogFilterList.add(newItem);
				System.debug('Added ' + newItem.Backlog + ' to backlog filter list');
			}
		}
		this.backlogFilterList.sort();
		System.debug('Backlog Filter list size: ' + this.backlogFilterList.size());
	}

	public void setNoteSelectionItemDisplayListing()
	{
		V1_NoteSelectionItems currentItem;
		this.displayList = new List<V1_NoteSelectionItems>();
		Set<String> setupCompare = new Set<String>();
		for(V1_Release_Notes_Table_Content__c curItem: this.resultsList)
		{
			System.debug('Table item: ' + curItem.V1_RN_ProductVersion__c + 
			', ' + curItem.V1_RN_Component__c +
			', ' + curItem.V1_RN_BacklogGroup__c +
			', ' + curItem.V1_RN_Matriarch__c);
			currentItem = new V1_NoteSelectionItems(curItem.V1_RN_ProductVersion__c, curItem.V1_RN_Component__c, 
					curItem.V1_RN_BacklogGroup__c, curItem.V1_RN_Matriarch__c);
			if(!setupCompare.contains(currentItem.CombinedItems))
			{
				displayList.add(currentItem);
				setupCompare.add(currentItem.CombinedItems);
				System.debug('Added ' + currentItem.CombinedItems + ' to display list');
			}
			else
				System.debug('Item ' + currentItem.CombinedItems + ' already in display list');
			
		}
		displayList.sort();
		System.debug('Display list size: ' + displayList.size());
	}

    public List<String> createPDFOutputList(List<V1_NoteSelectionItems> selectedItems, String groupBySpec)
    {
    	this.groupBySpec = groupBySpec;
    	createRNotesTableListForPDF(selectedItems);
    	return formatPDFReleaseNotes();
    }
    
    private boolean shouldAddToPDFList(String matriarch, String productVersion, String component, 
    	String backlogGroup, V1_Release_Notes_Table_Content__c curNote)
    {
   		System.debug('Cur Matriarch: "' + curNote.V1_RN_Matriarch__c + 
   			'" Product: "' + curNote.V1_RN_ProductVersion__c +
   			'" Backlog: "' + curNote.V1_RN_BacklogGroup__c + 
   			'" Component: "' + curNote.V1_RN_Component__c + 
   			'"');
   		if(curNote.V1_RN_Matriarch__c != matriarch || curNote.V1_RN_ProductVersion__c != productVersion 
   			|| curNote.V1_RN_Component__c != component || curNote.V1_RN_BacklogGroup__c != backlogGroup)
   		{
   			System.debug('Rejected Cur Matriarch: "' + curNote.V1_RN_Matriarch__c + 
    			'" Product: "' + curNote.V1_RN_ProductVersion__c +
    			'" Component: "' + curNote.V1_RN_Component__c + 
    			'" Backlog: "' + curNote.V1_RN_BacklogGroup__c + '"');
    			return false;
   		}
    	return true;
    }
    
    private void createRNotesTableListForPDF(List<V1_NoteSelectionItems> selectedItems)	
    {
    	this.rNotesListForPDF = new List<V1_Release_Notes_Table_Content__c>();
		allRNDisplaySelectedProducts = new Set<String>();
		allRNDisplaySelectedVersions = new Set<String>();
    	
    	for(V1_NoteSelectionItems curItem: selectedItems)
    	{
	    	for(V1_Release_Notes_Table_Content__c curNote: ResultsListing)
	    	{
	    		if(shouldAddToPDFList(curItem.Entitlement, curItem.ProductVersion, 
	    			curItem.Component, curItem.Backlog, curNote))
	    			this.rNotesListForPDF.add(curNote);
	    	}
	    	allRNDisplaySelectedProducts.add(curItem.Entitlement);
	    	allRNDisplaySelectedVersions.add(curItem.ProductVersion);
    	}
    	createRNotesPDFOutputObject();    	
    }
    
    private void createRNotesPDFOutputObject()
    {
    	String tempGroupBy;
    	List<V1_NoteSelectionItems> itemsForOutput = new List<V1_NoteSelectionItems>();
    	V1_NoteSelectionItems curItem;
    	Map<String,V1_NoteSelectionItems> mappedGrouping = new Map<String,V1_NoteSelectionItems>(); 
    	
    	for(V1_Release_Notes_Table_Content__c curNote: this.rNotesListForPDF)
    	{
			// TODO how to setup for different group by specs (backlog group for now) Must be not null
			if(this.groupBySpec.equals(GroupByOptions.BacklogGroup.name()))
				tempGroupBy = (curNote.V1_RN_BacklogGroup__c == null) ? '' : curNote.V1_RN_BacklogGroup__c;
			else if(this.groupBySpec.equals(GroupByOptions.Component.name()))
				tempGroupBy = (curNote.V1_RN_Component__c == null) ? '' : curNote.V1_RN_Component__c;
			else if(this.groupBySpec.equals(GroupByOptions.SubComponent.name()))
				tempGroupBy = (curNote.V1_RN_SubComponent__c == null) ? '' : curNote.V1_RN_SubComponent__c;
			else
			{
				throw new V1Exception('ERROR: Unrecognized group by specification: "' + this.groupBySpec + '"');
			}
			
    		if((curItem = mappedGrouping.get(tempGroupBy)) == null)
    		{
    			curItem = new V1_NoteSelectionItems(tempGroupBy);
    			curItem.attachNewChild(new V1_NoteSelectionItems(curNote));
    			mappedGrouping.put(tempGroupBy, curItem);
    			
    		}
    		else
			{
    			curItem.attachNewChild(new V1_NoteSelectionItems(curNote));
    			mappedGrouping.put(tempGroupBy, curItem);
			}
    	}
    	this.rNotesPDFDisplayObject = mappedGrouping.values();
    	if(this.rNotesPDFDisplayObject.size() > 0)
    		this.rNotesPDFDisplayObject.sort();
    }
    
    public List<String> formatPDFReleaseNotes()
    {
    	List<String> currentList = new List<String>();
    	for(V1_NoteSelectionItems groupedNote: this.rNotesPDFDisplayObject)
    	{
    	    // GroupBy
    	    if(groupedNote.SortBy != null && groupedNote.SortBy != '')
    	    	currentList.add('<br/><b style="color:#0000CD; font-size: 14pt;">' + groupedNote.SortBy + '</b>');
    	    	
    	    if(groupedNote.AttachedItems != null && groupedNote.AttachedItems.size() > 0)
    	    {
    	    	for(V1_NoteSelectionItems attachedItem: groupedNote.AttachedItems)
    	    	{
    	    		currentList.addAll(formatPDFNote(attachedItem));
    	    	}
    	    }
    		
    	}
    	return currentList;
    }
    
    public List<String> formatPDFNote(V1_NoteSelectionItems attachedItem)
    {
    	List<String> currentList = new List<String>();

 	    // Name
	    currentList.add('<b style="color:#076B70">' + attachedItem.ItemTitle + '</b>');
	    
	    // number
	    currentList.add('<b>' + setCorrectLabel(attachedItem.IDNumber) + '</b>'+ attachedItem.IDNumber);
        
        // Feature/Backlog
		if(attachedItem.Backlog != null && attachedItem.Backlog != '')
	        currentList.add('<b >Backlog Group </b>' + attachedItem.Backlog +'<br/>');
	        
	    // V1 Request id
		if(attachedItem.RequestId != null && attachedItem.RequestId != '')
	        currentList.add('<b >V1 R ID       </b>' + attachedItem.RequestId +'<br/>');
	        
	    // SFDC CR id
		if(attachedItem.CRId != null && attachedItem.CRId != '')
	        currentList.add('<b >SFDC CR ID    </b>' + attachedItem.CRId +'<br/>');
	        
	    // SFDC Case id
		if(attachedItem.CaseId != null && attachedItem.CaseId != '')
	        currentList.add('<b >SFDC Case ID  </b>' + attachedItem.CaseId +'<br/>');
	        
        if(attachedItem.Component != null && attachedItem.Component != '')
        	currentList.add('<b>Component      </b>'+ attachedItem.Component);
        	
        if(attachedItem.SubComponent != null && attachedItem.SubComponent != '')
        	currentList.add('<b>Sub-Component  </b>'+ attachedItem.SubComponent);
        	
		if(attachedItem.ReleaseNotes !=null && attachedItem.ReleaseNotes != '')
		{
		    currentList.add('<b>Release Note </b>'+'<br/>'+ attachedItem.ReleaseNotes);
		}
    	System.debug('PDF display list size: ' + currentList.size());
    	return currentList;
    }

    private String setCorrectLabel(String idNumber)
    {
    	if(idNumber == null || idNumber.equals(''))
    		return '';
    		
    	if(idNumber.startsWith('D-'))
    		return 'Defect Number: ';
    		
    	else if (idNumber.startsWith('E-'))
    		return 'Epic Number: ';
    		
    	else if (idNumber.startsWith('B-'))
    		return 'Enhancement Number: ';
    		
    	return 'Unknown ID type: ';
    }
    
    public void SetSelectedItemsList(Set<String> products, Set<String> productVersions, 
    	Set<String> components, Set<String> backlogs)
    {
    	List<V1_NoteSelectionItems> workingListing = DisplayListing;
    	
    	workingListing = filterDisplayListByEntitlement(workingListing, products);
    	workingListing = filterDisplayListByVersion(workingListing, productVersions);
    	workingListing = filterDisplayListByComponent(workingListing, components);
    	workingListing = filterDisplayListByBacklog(workingListing, backlogs);
    	this.DisplayListing =  workingListing;
    	System.debug('Utilities DisplayListing size: ' + this.DisplayListing.size());
    }
    
    private List<V1_NoteSelectionItems> filterDisplayListByEntitlement(List<V1_NoteSelectionItems> listToWork, Set<String> productsToFilter)
    {
    	List<V1_NoteSelectionItems> workingList = new List<V1_NoteSelectionItems>();
    	
    	if(productsToFilter.isEmpty())
    		return listToWork;
    		
    	System.debug('List To work size: ' + listToWork.size());
    	for(V1_NoteSelectionItems curItem: listToWork)
    	{
    		System.debug('Filter display items products- working item: "' + curItem.Entitlement + '"');
    		if(productsToFilter.contains(curItem.Entitlement))
    			workingList.add(curItem);
    		else
    			System.debug('Not adding Note selection item: ' + curItem);
    	}
    	System.debug('Working list size: ' + workingList.size());
    	return workingList;
    }
    
    private List<V1_NoteSelectionItems> filterDisplayListByVersion(List<V1_NoteSelectionItems> listToWork, Set<String> versionsToFilter)
    {
    	List<V1_NoteSelectionItems> workingList = new List<V1_NoteSelectionItems>();
    	
    	if(versionsToFilter.isEmpty())
    		return listToWork;
    		
    	System.debug('List To work size: ' + listToWork.size());
    	for(V1_NoteSelectionItems curItem: listToWork)
    	{
    		System.debug('Filter display items versions- working item: "' + curItem.ProductVersion + '"');
    		if(versionsToFilter.contains(curItem.ProductVersion))
    			workingList.add(curItem);
    		else
    			System.debug('Not adding Note selection item: ' + curItem);
    	}
    	System.debug('Working list size: ' + workingList.size());
    	return workingList;
    }
    
    private List<V1_NoteSelectionItems> filterDisplayListByComponent(List<V1_NoteSelectionItems> listToWork, Set<String> componentsToFilter)
    {
    	List<V1_NoteSelectionItems> workingList = new List<V1_NoteSelectionItems>();
    	
    	if(componentsToFilter.isEmpty())
    		return listToWork;
    		
    	System.debug('List To work size: ' + listToWork.size());
    	for(V1_NoteSelectionItems curItem: listToWork)
    	{
    		String tempComponent = (curItem.Component == null || curItem.Component == '') ? IS_BLANK_SPEC : curItem.Component;
    		System.debug('Filter display items components- working item: "' + tempComponent + '"');
    		if(componentsToFilter.contains(tempComponent))
    			workingList.add(curItem);
    		else
    			System.debug('Not adding Note selection item: ' + curItem);
    	}
    	System.debug('Working list size: ' + workingList.size());
    	return workingList;
    }
    
    private List<V1_NoteSelectionItems> filterDisplayListByBacklog(List<V1_NoteSelectionItems> listToWork, Set<String> backlogsToFilter)
    {
    	List<V1_NoteSelectionItems> workingList = new List<V1_NoteSelectionItems>();
    	
    	if(backlogsToFilter.isEmpty())
    		return listToWork;
    		
    	System.debug('List To work size: ' + listToWork.size());
    	for(V1_NoteSelectionItems curItem: listToWork)
    	{
    		String tempBacklog = (curItem.Backlog == null || curItem.Backlog == '') ? IS_BLANK_SPEC : curItem.Backlog;
    		System.debug('Filter display items backlog- working item: "' + tempBacklog + '"');
    		if(backlogsToFilter.contains(tempBacklog))
    			workingList.add(curItem);
    		else
    			System.debug('Not adding Note selection item: ' + curItem);
    	}
    	System.debug('Working list size: ' + workingList.size());
    	return workingList;
    }
    
	public List<V1_Release_Notes_Table_Content__c> ResultsListing
	{
		get
		{
			return this.resultsList;
		}
		set;
	}
    	
	public List<V1_NoteSelectionItems> DisplayListing
	{
		get
		{
			return this.displayList;
		}
		set
		{
			this.displayList = value;
		}
	}

	public List<V1_NoteSelectionItems> ProdFilterListing
	{
		get
		{
			return this.prodFilterList;
		}
		set;
	}
    	
	public List<V1_NoteSelectionItems> VersionFilterListing
	{
		get
		{
			return this.versionFilterList;
		}
		set;
	}

	public List<V1_NoteSelectionItems> ComponentFilterListing
	{
		get
		{
			return this.componentFilterList;
		}
		set;
	}
	public List<V1_NoteSelectionItems> BacklogFilterListing
	{
		get
		{
			return this.backlogFilterList;
		}
		set;
	}
	
	public Set<String> SelectedRNDisplayProducts
	{
		get
		{
			return this.allRNDisplaySelectedProducts;
		}
		set;
	}
    
    public Set<String> SelectedRNDisplayVersions
    {
    	get
    	{
    		return this.allRNDisplaySelectedVersions;
    	}
    	set;
    }
    
}