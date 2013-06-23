/**
 * ASummaryController
 * @author Hiroki Kajiwara
 */
public with sharing class ASummaryController {
        /**
         * Component list
         */
        public List<ApexClass> classList {get; set;}
        public List<ApexTrigger> triggerList {get; set;}
        public List<ApexPage> pageList {get; set;}
        public List<ApexComponent> componentList {get; set;}
        
        public List<ApexClass> classDateList {get; set;}
        public List<ApexTrigger> triggerDateList {get; set;}
        public List<ApexPage> pageDateList {get; set;}
        public List<ApexComponent> componentDateList {get; set;}
        
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
                countDateOrder();
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
                        
                        Datetime targeDateTime = Datetime.newInstance(Datetime.now().year() - 1, Datetime.now().month(), Datetime.now().day());
                        String whereClause = 
                                ' WHERE' + 
                                ' CreatedDate > ' + targeDateTime.format('yyyy-MM-dd\'T\'HH:mm:ss.000\'Z\'') + ' OR' + 
                                ' LastModifiedDate > ' + targeDateTime.format('yyyy-MM-dd\'T\'HH:mm:ss.000\'Z\'');
                        
                        classDateList = Database.query(ASummaryConfig.APEX_CLASS_DATE_QUERY + whereClause);
                        triggerDateList = Database.query(ASummaryConfig.APEX_TRIGGER_DATE_QUERY + whereClause);
                        pageDateList = Database.query(ASummaryConfig.APEX_PAGE_DATE_QUERY + whereClause);
                        componentDateList = Database.query(ASummaryConfig.APEX_COMPONENT_DATE_QUERY + whereClause);
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
         * Count component by created and modified date
         */
        public void countDateOrder() {
                createdComponentList = new List<CreatedModifiedDateClass>();
                modifiedComponentList = new List<CreatedModifiedDateClass>();
                
                Date todayDate = Date.newInstance(Date.today().year(), Date.today().month(), 1);
                Date targetDate = Date.newInstance(Date.today().year(), Date.today().month() + 1, 1);
                CreatedModifiedDateClass[] createdComponent = new CreatedModifiedDateClass[ASummaryConfig.COUNT_LENGTH];
                CreatedModifiedDateClass[] modifiedComponent = new CreatedModifiedDateClass[ASummaryConfig.COUNT_LENGTH];
                for (Integer i = 0 ; i < createdComponent.size(); i++) {
                        Date currentDate = targetDate.addMonths(-(i + 1));
                        createdComponent[i] = new CreatedModifiedDateClass(currentDate.year() + '/' + currentDate.month());
                        modifiedComponent[i] = new CreatedModifiedDateClass(currentDate.year() + '/' + currentDate.month());
                }
                
                // Apex
                for(ApexClass target : classDateList) {
                        targetDate = todayDate.addMonths(1);
                        for (Integer i = 0; i < createdComponent.size(); i++) {
                                // by CreatedDate
                                if (target.CreatedDate >= targetDate.addMonths(-1) && target.CreatedDate < targetDate ) {
                                        createdComponent[i].addCount(ASummaryConfig.CLASS_SATEMENT);
                                }
                                // by LastModifiedDate
                                if (target.LastModifiedDate >= targetDate.addMonths(-1) && target.LastModifiedDate < targetDate) {
                                        modifiedComponent[i].addCount(ASummaryConfig.CLASS_SATEMENT);
                                }
                                targetDate = targetDate.addMonths(-1);
                        }
                }
                
                // Trigger
                for(ApexTrigger target : triggerDateList) {
                        targetDate = todayDate.addMonths(1);
                        for (Integer i = 0; i < createdComponent.size(); i++) {
                                // by CreatedDate
                                if (target.CreatedDate >= targetDate.addMonths(-1) && target.CreatedDate < targetDate ) {
                                        createdComponent[i].addCount(ASummaryConfig.TRIGGER_SATEMENT);
                                }
                                // by LastModifiedDate
                                if (target.LastModifiedDate >= targetDate.addMonths(-1) && target.LastModifiedDate < targetDate) {
                                        modifiedComponent[i].addCount(ASummaryConfig.TRIGGER_SATEMENT);
                                }
                                targetDate = targetDate.addMonths(-1);
                        }
                }
                
                // Page
                for(ApexPage target : pageDateList) {
                        targetDate = todayDate.addMonths(1);
                        for (Integer i = 0; i < createdComponent.size(); i++) {
                                // by CreatedDate
                                if (target.CreatedDate >= targetDate.addMonths(-1) && target.CreatedDate < targetDate ) {
                                        createdComponent[i].addCount(ASummaryConfig.PAGE_SATEMENT);
                                }
                                // by LastModifiedDate
                                if (target.LastModifiedDate >= targetDate.addMonths(-1) && target.LastModifiedDate < targetDate) {
                                        modifiedComponent[i].addCount(ASummaryConfig.PAGE_SATEMENT);
                                }
                                targetDate = targetDate.addMonths(-1);
                        }
                }
                
                // Component
                for(ApexComponent target : componentDateList) {
                        targetDate = todayDate.addMonths(1);
                        for (Integer i = 0; i < createdComponent.size(); i++) {
                                // by CreatedDate
                                if (target.CreatedDate >= targetDate.addMonths(-1) && target.CreatedDate < targetDate ) {
                                        createdComponent[i].addCount(ASummaryConfig.COMPONENT_SATEMENT);
                                }
                                // by LastModifiedDate
                                if (target.LastModifiedDate >= targetDate.addMonths(-1) && target.LastModifiedDate < targetDate) {
                                        modifiedComponent[i].addCount(ASummaryConfig.COMPONENT_SATEMENT);
                                }
                                targetDate = targetDate.addMonths(-1);
                        }
                }
                
                // Add component to list
                Integer index = createdComponent.size();
                for (Integer i = 1 ; i <= index; i++) {
                        createdComponentList.add(createdComponent[index - i]);
                        modifiedComponentList.add(modifiedComponent[index - i]);
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
                        if (componentType == ASummaryConfig.CLASS_SATEMENT) {
                                this.apexCount++;
                        } else if (componentType == ASummaryConfig.TRIGGER_SATEMENT) {
                                this.triggerCount++;
                        } else if (componentType == ASummaryConfig.PAGE_SATEMENT) {
                                this.pageCount++;
                        } else if (componentType == ASummaryConfig.COMPONENT_SATEMENT) {
                                this.componentCount++;
                        } else {
                        }
                }
        }
}