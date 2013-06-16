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
	
	/**
	 * Constructor
	 */
	public ASummaryController() {
		setComponent();
		setCountData();
		setLengthData();
		setApiVersion();
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
}