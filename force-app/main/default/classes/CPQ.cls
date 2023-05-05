public with sharing class CPQ {

    @AuraEnabled
    public static String subscription(Id Recordid){
        List<SBQQ__Subscription__c> sub = new List<SBQQ__Subscription__c>();
        Opportunity op = [SELECT AccountId, ContractId FROM Opportunity WHERE Id =: Recordid];
        List<SBQQ__QuoteLine__c> quoteline = new List<SBQQ__QuoteLine__c>();
        SBQQ__Quote__c quote = new SBQQ__Quote__c();

        if([SELECT Count() FROM SBQQ__Quote__c WHERE SBQQ__Opportunity2__c =: Recordid] > 0){
        quote = [SELECT Id FROM SBQQ__Quote__c WHERE SBQQ__Opportunity2__c =: Recordid Limit 1];   // Limit 1 : If any opp have more than 1 Quote
        }
        else{
             return 'No Quote';
        }
        if([SELECT Count() FROM SBQQ__QuoteLine__c WHERE SBQQ__Quote__c =: quote.Id] > 0){
        quoteline = [SELECT Id FROM SBQQ__QuoteLine__c WHERE SBQQ__Quote__c =: quote.Id];
        }
        else{
            return 'No QuoteLines';
        }

        for(SBQQ__QuoteLine__c ql : quoteline){
            sub.add(new SBQQ__Subscription__c(SBQQ__Account__c = op.AccountId, SBQQ__Contract__c = op.ContractId, SBQQ__Quantity__c = 1, SBQQ__QuoteLine__c = ql.Id));
        }
        insert sub;
        return 'Subscription created';
    }
}