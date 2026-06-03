@isTest
public class AccountTriggerTest {

    // BEFORE INSERT TEST
    @isTest
    static void testBeforeInsert(){

        Account acc = new Account(
            Name = 'Media Account',
            Industry = 'Media',
            CopyBillingToShipping__c = true,
            BillingStreet = 'Test Street',
            BillingCity = 'Jaipur',
            BillingStateCode = 'RJ',
            BillingPostalCode = '302001',
            BillingCountryCode = 'IN'
        );

        Test.startTest();
        insert acc;
        Test.stopTest();

        Account insertedAcc = [SELECT Rating, ShippingStreet FROM Account WHERE Id = :acc.Id];

        System.assertEquals('Hot', insertedAcc.Rating);
        System.assertEquals('Test Street', insertedAcc.ShippingStreet);
    }

    // AFTER INSERT TEST
    @isTest
    static void testAfterInsert(){

        Account acc = new Account(
            Name = 'After Insert Test',
            Industry = 'Media',
            Active__c = 'Yes',
            CreateRelatedContact__c = true,
            CreateRelatedOpportunity__c = true
        );

        // Test.startTest();
        insert acc;
        // Test.stopTest();

        // If helper classes create related records this ensures trigger runs
        System.assertNotEquals(null, acc.Id);
    }

    // UPDATE PHONE -> CONTACT HOME PHONE
    @isTest
	static void testBeforeUpdateAccount(){
	    // Create Account
	    Account acc = new Account(Name = 'Test Account', Industry = 'Media', Phone = '9999999999');

    	insert acc;

    	// Update Phone to trigger BEFORE UPDATE logic
   	 	acc.Phone = '8888888888';

    	Test.startTest();
    	update acc;
    	Test.stopTest();

    	// Fetch updated account
    	Account updatedAcc = [ SELECT Id, Phone, Description FROM Account WHERE Id = :acc.Id];

    	// Verify phone updated
    	System.assertEquals('8888888888', updatedAcc.Phone);

    	// Verify description updated by before update logic
    	System.assert(updatedAcc.Description != null);
	}
    
    // UPDATE BILLING ADDRESS -> CONTACT MAILING ADDRESS
    @isTest
    static void testUpdateAddressPropagation(){

        // Create Account
        Account acc = new Account(
            Name = 'Test Account',
            BillingStreet = 'Old Street',
            BillingCity = 'Jaipur'
        );
        insert acc;

        // Create Contact related to Account
        Contact con = new Contact(
            LastName = 'Test Contact',
            AccountId = acc.Id
        );
        insert con;

        // Update Billing Address
        acc.BillingStreet = 'New Street';
        acc.BillingCity = 'Delhi';
        acc.BillingCountryCode = 'IN';

        Test.startTest();
        update acc;
        Test.stopTest();

        // Fetch updated Contact
        Contact updatedCon = [
            SELECT MailingStreet, MailingCity
            FROM Contact
            WHERE Id = :con.Id
        ];

        System.assertEquals('New Street', updatedCon.MailingStreet);
        System.assertEquals('Delhi', updatedCon.MailingCity);
    }

    // AFTER UPDATE -> CLOSE OPPORTUNITIES WHEN ACCOUNT DEACTIVATED
    @isTest
    static void testDeactivateAccount(){

        // Create Account
        Account acc = new Account(
            Name = 'Test Account',
            Active__c = 'Yes'
        );
        insert acc;

        // Create Opportunity
        Opportunity opp = new Opportunity(
            Name = 'Test 2 Opportunity',
            StageName = 'Prospecting',
            CloseDate = Date.today().addDays(10),
            Amount = 5000,
            AccountId = acc.Id,
            Reason_for_Loss__c = 'Price' 
        );
        insert opp;

        // Deactivate Account
        acc.Active__c = 'No';

        // Test.startTest();
        update acc;
        // Test.stopTest();

        // Verify opportunity stage updated
        Opportunity updatedOpp = [
            SELECT StageName
            FROM Opportunity
            WHERE Id = :opp.Id
        ];

        System.assertEquals('Closed Lost', updatedOpp.StageName);
    }

    // DELETE VALIDATION TEST
    @isTest
    static void testDeleteAccountValidation(){

        // Create Account
        Account acc = new Account(
            Name = 'Test Delete Account',
            Active__c = 'Yes'
        );
        insert acc;

        Test.startTest();

        try{
            delete acc;
            System.assert(false, 'Account deletion should have failed.');
        }
        catch(DmlException e){
            System.assert(
                e.getMessage().contains('Active Accounts cannot be deleted'),
                'Expected validation message not found.'
            );
        }

        Test.stopTest();
    }
	
    // Negative Case — Industry NOT Media (Rating should not become Hot)
    @isTest
    static void testBeforeInsertNegativeIndustry(){
    
        Account acc = new Account(
            Name = 'Non Media Account',
            Industry = 'Banking'
        );
    
        insert acc;
    
        Account insertedAcc = [
            SELECT Rating
            FROM Account
            WHERE Id = :acc.Id
        ];
    
        System.assertNotEquals('Hot', insertedAcc.Rating);
    }
    
    // Negative Case — CopyBillingToShipping__c = false
    @isTest
    static void testBillingNotCopiedWhenCheckboxFalse(){
    
        Account acc = new Account(
            Name = 'Test Account',
            Industry = 'Media',
            CopyBillingToShipping__c = false,
            BillingStreet = 'Street A',
            BillingCity = 'Jaipur'
        );
    
        insert acc;
    
        Account insertedAcc = [
            SELECT ShippingStreet
            FROM Account
            WHERE Id = :acc.Id
        ];
    
        System.assertEquals(null, insertedAcc.ShippingStreet);
    }
    
    // Negative Case — Phone NOT changed (Before Update logic should not run)
    @isTest
    static void testBeforeUpdatePhoneNotChanged(){
    
        Account acc = new Account(
            Name = 'Phone Test',
            Phone = '9999999999'
        );
    
        insert acc;
    
        Test.startTest();
        update acc;
        Test.stopTest();
    
        Account updatedAcc = [
            SELECT Description
            FROM Account
            WHERE Id = :acc.Id
        ];
    
        System.assertEquals(null, updatedAcc.Description);
    }
}