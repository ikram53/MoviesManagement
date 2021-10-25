global with sharing class MovieUpdateBatch implements Database.Batchable<sObject>{
    public MovieUpdateBatch() {
    }
    /*
     ***** START : collects the records to pass to the interface method execute
     ***** this is the first method which is called when we execute a batch apex
     ***** Return : Database.QueryLocator object that contains the recors passed to the job
    */

    global Database.QueryLocator start(Database.BatchableContext BC)
    {
       
        String query = 'SELECT Id,isReleased__c,Release_date__c '+
                       'FROM Movie__c '+
                       'WHERE Release_date__c <= TODAY '+
                       'AND isReleased__c != true';
        return Database.getQueryLocator(query);
    }

    /*
     ***** Execute : do the required processing of each chunk of data
     ***** Called for each batch/chunk of records that we pass
     */
    global void execute(Database.BatchableContext BC, List<Movie__c> movies)
    {
       
        List<Movie__c> moviesToUpdate = new List<Movie__c>();
        for(Movie__c movie : movies)
        {
            movie.isReleased__c = true;
            moviesToUpdate.add(movie);
            
        }
        update moviesToUpdate;
    }

    /*
     **** Finish : called after all batches are processed
     ****
     */
    global void finish(Database.BatchableContext BC) {
           system.debug('fin');
    }
}
