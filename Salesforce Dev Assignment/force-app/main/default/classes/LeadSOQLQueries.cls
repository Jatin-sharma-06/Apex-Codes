public with sharing class LeadSOQLQueries {
    
    // 5. Identify the five most recently created Leads.
    public static void lastFiveLeads() {
        List<Lead> leadList = new List<Lead>();
        leadList = [SELECT Id, Name FROM Lead ORDER BY CreatedDate DESC limit 5];

        for(Lead lead : leadList  ) {
            System.debug(
                '\nLead ID ::::' + lead.Id +
                '\nLead Name ::' + lead.Name
            );
        }
    }

    //14. Find the total number of Leads in each Lead Source category.
    public static void numberOfLeadsInEachCategory() {
        List<AggregateResult> leadsCount = new List<AggregateResult>();
        leadsCount = [SELECT LeadSource, COUNT(Id) leadCounter FROM Lead GROUP BY LeadSource];

        for(AggregateResult result : leadsCount) {
            String leadSourceType = (String)result.get('LeadSource');
            Integer numberOfLeads = (Integer)result.get('leadCounter');
            System.debug('\nLead Source : ' + leadSourceType + '\nLead\'s Count : ' + numberOfLeads);
        }
    }

}