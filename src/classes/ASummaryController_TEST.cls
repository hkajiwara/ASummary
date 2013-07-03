/**
 * ASummaryController_TEST
 * @author Hiroki Kajiwara
 */
@isTest
private class ASummaryController_TEST {
	/**
	 * All method test
	 * Expected: true
	 */
	 static testMethod void allMethodTest() {
	 	ASummaryController asController = new ASummaryController();
	 	
	 	// Expected: returns more than 1 class
	 	if (asController.classList.size() >= 1) {
	 		System.assert(true);
	 	} else {
	 		System.assert(false);
	 	}
	 	
	 	// Expected: returns more than 1 page
	 	if (asController.pageList.size() >= 1) {
	 		System.assert(true);
	 	} else {
	 		System.assert(false);
	 	}
	 	
	 	// Expected: returns 4 component
	 	if (asController.countDataList.size() == 4) {
	 		System.assert(true);
	 	} else {
	 		System.assert(false);
	 	}
	 	
	 	// Expected: returns 2 component including class and trigger
	 	if (asController.lengthDataList.size() == 2) {
	 		System.assert(true);
	 	} else {
	 		System.assert(false);
	 	}
	 	
	 	// Expected: returns more than 1 class
	 	if (asController.apiVersionClassList.size() >= 1) {
	 		System.assert(true);
	 	} else {
	 		System.assert(false);
	 	}
	 	
	 	// Expected: returns more than 1 page
	 	if (asController.apiVersionPageList.size() >= 1) {
	 		System.assert(true);
	 	} else {
	 		System.assert(false);
	 	}
	 }
}