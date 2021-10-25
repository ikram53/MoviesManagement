trigger MovieTrigger on Movie__c (before insert) {
    
    List<MovieActor__c> movieActors = [SELECT actor__r.Gender__c,movie__c,actor__r.id
                                       FROM MovieActor__c
                                       WHERE movie__c IN :Trigger.New];
   

}