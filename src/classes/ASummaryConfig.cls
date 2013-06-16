/**
 * ASummaryConfig
 */
public with sharing class ASummaryConfig {
	public static final String APEX_CLASS_QUERY 		= 'SELECT Name, ApiVersion, LengthWithoutComments, CreatedDate, LastModifiedDate FROM ApexClass';
	public static final String APEX_TRIGGER_QUERY 	= 'SELECT Name, ApiVersion, LengthWithoutComments, CreatedDate, LastModifiedDate FROM ApexTrigger';
	public static final String APEX_PAGE_QUERY 		= 'SELECT Name, ApiVersion, CreatedDate, LastModifiedDate FROM ApexPage';
	public static final String APEX_COMPONENT_QUERY 	= 'SELECT Name, ApiVersion, CreatedDate, LastModifiedDate FROM ApexComponent';
}