public with sharing class DM001_MoviesActors {

    public DM001_MoviesActors() {

    }

    /**
     * Get Movies by search key
     */
    //method imperatif  ====> Cacheable=false
    @AuraEnabled(Cacheable=false)
    public static List<Movie__c> getMoviesByKey(String searchKey){

        List<Movie__c> moviesResult = [Select Name,category__c from Movie__c where Name like :searchKey ];
        return moviesResult;

    }



}
