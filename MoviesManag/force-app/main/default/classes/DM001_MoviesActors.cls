public with sharing class DM001_MoviesActors {

    public DM001_MoviesActors() {

    }

    /**
     * Get Movies by search key
     */
    //method imperatif  ====> Cacheable=false
    @AuraEnabled(Cacheable=false)
    public static List<Movie__c> getMoviesByKey(String searchKey){
        System.debug('searchKey'+searchKey);
        String movieName = '%' + searchKey + '%';
        
        List<Movie__c> moviesResult = [Select Name,category__c,Release_date__c from Movie__c where Name like :movieName ];
        return moviesResult;

    }
    @AuraEnabled(Cacheable=false)
    public static List<Movie__c> getAllMovies(){
 
        List<Movie__c> moviesResult = [Select Name,category__c from Movie__c ];
        return moviesResult;

    }



}
