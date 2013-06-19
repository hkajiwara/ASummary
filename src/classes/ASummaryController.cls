/**
 * ASummaryController
 */
public with sharing class ASummaryController {
	/**
	 * Component list
	 */
	public List<ApexClass> classList {get; set;}
	public List<ApexTrigger> triggerList {get; set;}
	public List<ApexPage> pageList {get; set;}
	public List<ApexComponent> componentList {get; set;}
	
	/**
	 * Graph data
	 */
	public List<CountLenghClass> countDataList {get; set;}
	public List<CountLenghClass> lengthDataList {get; set;}
	public List<ApiVersionClass> apiVersionClassList {get; set;}
	public List<ApiVersionClass> apiVersionTriggerList {get; set;}
	public List<ApiVersionClass> apiVersionPageList {get; set;}
	public List<ApiVersionClass> apiVersionComponentList {get; set;}
	public List<CreatedModifiedDateClass> createdComponentList {get; set;}
	public List<CreatedModifiedDateClass> modifiedComponentList {get; set;}
	
	
	/**
	 * Constructor
	 */
	public ASummaryController() {
		setComponent();
		setCountData();
		setLengthData();
		setApiVersion();
		countCreatedComponent();
		countModifiedComponent();
	}
	
	/**
	 * Set component to query each component
	 */
	private void setComponent() {
		try {
			classList = Database.query(ASummaryConfig.APEX_CLASS_QUERY);
			triggerList = Database.query(ASummaryConfig.APEX_TRIGGER_QUERY);
			pageList = Database.query(ASummaryConfig.APEX_PAGE_QUERY);
			componentList = Database.query(ASummaryConfig.APEX_COMPONENT_QUERY);
		} catch (QueryException e) {
			System.debug(e);
		}
	}
	
	/**
	 * Set the length of class and trigger
	 */
	private void setLengthData() {
		lengthDataList = new List<CountLenghClass>();
		
		Integer totalLength = 0;
		for (ApexClass target : classList) {
			totalLength += target.LengthWithoutComments;
		}
		lengthDataList.add(new CountLenghClass('Apex Class', totalLength));
		
		totalLength = 0;
		for (ApexTrigger target : triggerList) {
			totalLength += target.LengthWithoutComments;
		}
		lengthDataList.add(new CountLenghClass('Apex Trigger', totalLength));
	}
	
	/**
	 * Set the count of each component
	 */
	private void setCountData() {
		countDataList = new List<CountLenghClass>();
		
		countDataList.add(new CountLenghClass('Class', classList.size()));
		countDataList.add(new CountLenghClass('Trigger', triggerList.size()));
		countDataList.add(new CountLenghClass('Page', pageList.size()));
		countDataList.add(new CountLenghClass('Component', componentList.size()));
	}
	
	/**
	 * Set the API version of each component
	 */
	private void setApiVersion() {
		apiVersionClassList = new List<ApiVersionClass>();
		apiVersionTriggerList = new List<ApiVersionClass>();
		apiVersionPageList = new List<ApiVersionClass>();
		apiVersionComponentList = new List<ApiVersionClass>();
		
		Set<Decimal> apiVersionSet;
		Map<Decimal, Integer> apiVersionMap;
		
		// Apex
		apiVersionSet = new Set<Decimal>();
		for (ApexClass target : classList) {
			apiVersionSet.add(target.ApiVersion);
		}
		apiVersionMap = new Map<Decimal, Integer>();
		for (Decimal apiVersion : apiVersionSet) {
			apiVersionMap.put(apiVersion, 0);
		}
		for (ApexClass target : classList) {
			apiVersionMap.put(target.ApiVersion, apiVersionMap.get(target.ApiVersion)+1);
		}
		for (Decimal apiVersion : apiVersionSet) {
			apiVersionClassList.add(new ApiVersionClass(String.valueOf(apiVersion), apiVersionMap.get(apiVersion)));
		}
		
		// Trigger
		apiVersionSet = new Set<Decimal>();
		for (ApexTrigger target : triggerList) {
			apiVersionSet.add(target.ApiVersion);
		}
		apiVersionMap = new Map<Decimal, Integer>();
		for (Decimal apiVersion : apiVersionSet) {
			apiVersionMap.put(apiVersion, 0);
		}
		for (ApexTrigger target : triggerList) {
			apiVersionMap.put(target.ApiVersion, apiVersionMap.get(target.ApiVersion)+1);
		}
		for (Decimal apiVersion : apiVersionSet) {
			apiVersionTriggerList.add(new ApiVersionClass(String.valueOf(apiVersion), apiVersionMap.get(apiVersion)));
		}
		
		// Page
		apiVersionSet = new Set<Decimal>();
		for (ApexPage target : pageList) {
			apiVersionSet.add(target.ApiVersion);
		}
		apiVersionMap = new Map<Decimal, Integer>();
		for (Decimal apiVersion : apiVersionSet) {
			apiVersionMap.put(apiVersion, 0);
		}
		for (ApexPage target : pageList) {
			apiVersionMap.put(target.ApiVersion, apiVersionMap.get(target.ApiVersion)+1);
		}
		for (Decimal apiVersion : apiVersionSet) {
			apiVersionPageList.add(new ApiVersionClass(String.valueOf(apiVersion), apiVersionMap.get(apiVersion)));
		}
		
		// Component
		apiVersionSet = new Set<Decimal>();
		for (ApexComponent target : componentList) {
			apiVersionSet.add(target.ApiVersion);
		}
		apiVersionMap = new Map<Decimal, Integer>();
		for (Decimal apiVersion : apiVersionSet) {
			apiVersionMap.put(apiVersion, 0);
		}
		for (ApexComponent target : componentList) {
			apiVersionMap.put(target.ApiVersion, apiVersionMap.get(target.ApiVersion)+1);
		}
		for (Decimal apiVersion : apiVersionSet) {
			apiVersionComponentList.add(new ApiVersionClass(String.valueOf(apiVersion), apiVersionMap.get(apiVersion)));
		}
	}
	
	/**
	 * Count component by created date
	 */
	public void countCreatedComponent() {
		createdComponentList = new List<CreatedModifiedDateClass>();
		
		Date targetDate = Date.newInstance(Date.today().year(), Date.today().month() + 1, 1);
		CreatedModifiedDateClass[] component = new CreatedModifiedDateClass[12];
		for (Integer i = 0 ; i < component.size(); i++) {
			Date currentDate = targetDate.addMonths(-(i + 1));
			component[i] = new CreatedModifiedDateClass(currentDate.year() + '/' + currentDate.month());
		}
		
		// Apex
		for(ApexClass target : classList) {
			targetDate = Date.newInstance(Date.today().year(), Date.today().month() + 1, 1);
			for (Integer i = 0; i < component.size(); i++) {
				if (target.CreatedDate >= Date.newInstance(targetDate.year(), targetDate.month() - 1, 1) &&
					target.CreatedDate < Date.newInstance(targetDate.year(), targetDate.month(), 1) ) {
					
					component[i].addCount('APEX');
					break;
				}
				targetDate = Date.newInstance(targetDate.year(), targetDate.month() - 1, 1);
			}
		}
		
		// Trigger
		for(ApexTrigger target : triggerList) {
			targetDate = Date.newInstance(Date.today().year(), Date.today().month() + 1, 1);
			for (Integer i = 0; i < component.size(); i++) {
				if (target.CreatedDate >= Date.newInstance(targetDate.year(), targetDate.month() - 1, 1) &&
					target.CreatedDate < Date.newInstance(targetDate.year(), targetDate.month(), 1) ) {
					
					component[i].addCount('TRIGGER');
					break;
				}
				targetDate = Date.newInstance(targetDate.year(), targetDate.month() - 1, 1);
			}
		}
		
		// Page
		for(ApexPage target : pageList) {
			targetDate = Date.newInstance(Date.today().year(), Date.today().month() + 1, 1);
			for (Integer i = 0; i < component.size(); i++) {
				if (target.CreatedDate >= Date.newInstance(targetDate.year(), targetDate.month() - 1, 1) &&
					target.CreatedDate < Date.newInstance(targetDate.year(), targetDate.month(), 1) ) {
					
					component[i].addCount('PAGE');
					break;
				}
				targetDate = Date.newInstance(targetDate.year(), targetDate.month() - 1, 1);
			}
		}
		
		// Component
		for(ApexComponent target : componentList) {
			targetDate = Date.newInstance(Date.today().year(), Date.today().month() + 1, 1);
			for (Integer i = 0; i < component.size(); i++) {
				if (target.CreatedDate >= Date.newInstance(targetDate.year(), targetDate.month() - 1, 1) &&
					target.CreatedDate < Date.newInstance(targetDate.year(), targetDate.month(), 1) ) {
					
					component[i].addCount('COMPONENT');
					break;
				}
				targetDate = Date.newInstance(targetDate.year(), targetDate.month() - 1, 1);
			}
		}
		
		for (Integer i = 0 ; i < component.size(); i++) {
			createdComponentList.add(component[i]);
		}
	}
	
	/**
	 * Count component by modified date
	 */
	public void countModifiedComponent() {
		modifiedComponentList = new List<CreatedModifiedDateClass>();
		
		Date targetDate = Date.newInstance(Date.today().year(), Date.today().month() + 1, 1);
		CreatedModifiedDateClass[] component = new CreatedModifiedDateClass[12];
		for (Integer i = 0 ; i < component.size(); i++) {
			Date currentDate = targetDate.addMonths(-(i + 1));
			component[i] = new CreatedModifiedDateClass(currentDate.year() + '/' + currentDate.month());
		}
		
		// Apex
		for(ApexClass target : classList) {
			targetDate = Date.newInstance(Date.today().year(), Date.today().month() + 1, 1);
			for (Integer i = 0; i < component.size(); i++) {
				if (target.LastModifiedDate >= Date.newInstance(targetDate.year(), targetDate.month() - 1, 1) &&
					target.LastModifiedDate < Date.newInstance(targetDate.year(), targetDate.month(), 1) ) {
					
					component[i].addCount('APEX');
					break;
				}
				targetDate = Date.newInstance(targetDate.year(), targetDate.month() - 1, 1);
			}
		}
		
		// Trigger
		for(ApexTrigger target : triggerList) {
			targetDate = Date.newInstance(Date.today().year(), Date.today().month() + 1, 1);
			for (Integer i = 0; i < component.size(); i++) {
				if (target.LastModifiedDate >= Date.newInstance(targetDate.year(), targetDate.month() - 1, 1) &&
					target.LastModifiedDate < Date.newInstance(targetDate.year(), targetDate.month(), 1) ) {
					
					component[i].addCount('TRIGGER');
					break;
				}
				targetDate = Date.newInstance(targetDate.year(), targetDate.month() - 1, 1);
			}
		}
		
		// Page
		for(ApexPage target : pageList) {
			targetDate = Date.newInstance(Date.today().year(), Date.today().month() + 1, 1);
			for (Integer i = 0; i < component.size(); i++) {
				if (target.LastModifiedDate >= Date.newInstance(targetDate.year(), targetDate.month() - 1, 1) &&
					target.LastModifiedDate < Date.newInstance(targetDate.year(), targetDate.month(), 1) ) {
					
					component[i].addCount('PAGE');
					break;
				}
				targetDate = Date.newInstance(targetDate.year(), targetDate.month() - 1, 1);
			}
		}
		
		// Component
		for(ApexComponent target : componentList) {
			targetDate = Date.newInstance(Date.today().year(), Date.today().month() + 1, 1);
			for (Integer i = 0; i < component.size(); i++) {
				if (target.LastModifiedDate >= Date.newInstance(targetDate.year(), targetDate.month() - 1, 1) &&
					target.LastModifiedDate < Date.newInstance(targetDate.year(), targetDate.month(), 1) ) {
					
					component[i].addCount('COMPONENT');
					break;
				}
				targetDate = Date.newInstance(targetDate.year(), targetDate.month() - 1, 1);
			}
		}
		
		for (Integer i = 0 ; i < component.size(); i++) {
			modifiedComponentList.add(component[i]);
		}
	}
	
	/**
	 * Count and length class
	 */
	private class CountLenghClass {
		private String name;
		private Integer countLengh;
		private CountLenghClass(String name, Integer countLengh) {
			this.name = name;
			this.countLengh = countLengh;
		}
	}
	
	/**
	 * API version class
	 */
	private class ApiVersionClass {
		private String apiVersion;
		private Integer count;
		private ApiVersionClass(String apiVersion, Integer count) {
			this.apiVersion = apiVersion;
			this.count = count;
		}
	}
	
	/**
	 * Created component class
	 */
	private class CreatedModifiedDateClass {
		private String targetDate;
		private Integer apexCount;
		private Integer triggerCount;
		private Integer pageCount;
		private Integer componentCount;
		
		private CreatedModifiedDateClass(String targetDate) {
			this.targetDate = targetDate;
			apexCount = 0;
			triggerCount = 0;
			pageCount = 0;
			componentCount = 0;
		}
		
		private void addCount(String componentType) {
			if (componentType == 'APEX') {
				this.apexCount++;
			} else if (componentType == 'TRIGGER') {
				this.triggerCount++;
			} else if (componentType == 'PAGE') {
				this.pageCount++;
			} else if (componentType == 'COMPONENT') {
				this.componentCount++;
			} else {
			}
		}
	}
}