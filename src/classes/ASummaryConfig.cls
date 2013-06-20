/**
 * ASummaryConfig
 */
public with sharing class ASummaryConfig {
	/**
	 * Component statement
	 */
	public static final String CLASS_SATEMENT				= 'CLASS';
	public static final String TRIGGER_SATEMENT			= 'TRIGGER';
	public static final String PAGE_SATEMENT				= 'PAGE';
	public static final String COMPONENT_SATEMENT			= 'COMPONENT';
	
	/**
	 * Query
	 */
	public static final String APEX_CLASS_QUERY 			= 'SELECT Name, ApiVersion, LengthWithoutComments FROM ApexClass';
	public static final String APEX_TRIGGER_QUERY 		= 'SELECT Name, ApiVersion, LengthWithoutComments FROM ApexTrigger';
	public static final String APEX_PAGE_QUERY 			= 'SELECT Name, ApiVersion FROM ApexPage';
	public static final String APEX_COMPONENT_QUERY 		= 'SELECT Name, ApiVersion FROM ApexComponent';
	
	/**
	 * Query by CreatedDate
	 */
	public static final String APEX_CLASS_CDATE_QUERY 	= 'SELECT CreatedDate FROM ApexClass';
	public static final String APEX_TRIGGER_CDATE_QUERY 	= 'SELECT CreatedDate FROM ApexTrigger';
	public static final String APEX_PAGE_CDATE_QUERY 		= 'SELECT CreatedDate FROM ApexPage';
	public static final String APEX_COMPONENT_CDATE_QUERY = 'SELECT CreatedDate FROM ApexComponent';
	
	/**
	 * Query by LastModifiedDate
	 */
	public static final String APEX_CLASS_MDATE_QUERY 	= 'SELECT LastModifiedDate FROM ApexClass';
	public static final String APEX_TRIGGER_MDATE_QUERY 	= 'SELECT LastModifiedDate FROM ApexTrigger';
	public static final String APEX_PAGE_MDATE_QUERY 		= 'SELECT LastModifiedDate FROM ApexPage';
	public static final String APEX_COMPONENT_MDATE_QUERY = 'SELECT LastModifiedDate FROM ApexComponent';	
}