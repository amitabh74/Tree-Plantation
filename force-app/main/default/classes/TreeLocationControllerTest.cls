/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an org are executed whenever Apex code is deployed
 * to a production org to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production org. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the org size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class TreeLocationControllerTest {

    @TestSetup
    static void makeData(){
        Tree__c tree = new Tree__c(Name='Banyan Tree', Benefit__c='Dummy Benefits Here', Picture__c='');
        insert tree;

        City__c city = new City__c(name='Delhi', target__c=35000);
        city.Location__latitude__s = 28.635308;
        city.Location__longitude__s = 77.22496;
        insert city;

        Tree_Plantation__c treePlant = new Tree_Plantation__c(age__c=50, Number_Of_Tree_Planted__c=50000);
        treePlant.Planted_In__c = city.Id;
        treePlant.Tree__c = tree.id;
        insert treePlant;
    }

    @isTest
    static void testGetLoccation() {
        List<Tree__c> p = [SELECT Id, Name, Benefit__c, Picture__c FROM Tree__c];
        List<Tree_Plantation__c> plants = TreeLocationController.getTreeLocations(p.get(0).Id);

        Test.startTest();
        System.assertEquals(1, plants.size(), 'Number of tree records does not match');
        System.assertEquals(plants[0].Planted_In__r.Name, 'Delhi', 'Name does not match');
        System.assertEquals(plants[0].Planted_In__r.Location__Latitude__s, 28.635308, 'Latitude does not match');
        System.assertEquals(plants[0].Planted_In__r.Location__longitude__s, 77.22496, 'Lonngitude does not match');
        Test.stopTest();

    }
}