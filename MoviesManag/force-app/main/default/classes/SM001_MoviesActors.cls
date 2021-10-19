public with sharing class SM001_MoviesActors {

    public SM001_MoviesActors() {

    }

    @AuraEnabled
    public static void createMovie(NewMovie newMovie,List<String> movieActorsIds) {

         Movie__c newMovieToinsert = new Movie__c();

         newMovieToinsert.Name = newMovie.name;
         newMovieToinsert.category__c = newMovie.category;
         newMovieToinsert.Description__c = newMovie.description;
         newMovieToinsert.Rating__c = newMovie.rating;
         newMovieToinsert.Release_date__c = newMovie.releaseDate;
        

         insert newMovieToinsert;
       

         List<MovieActor__c> movieActorsToinsert  =new List<MovieActor__c>();

         for(String idActor : movieActorsIds){
            MovieActor__c movieActor =new MovieActor__c();
            movieActor.Actor__c=idActor;
            movieActor.Movies__c=newMovieToinsert.Id;
            movieActorsToinsert.add(movieActor);

         }
        insert movieActorsToinsert;

    
    }

    @AuraEnabled
    public static List<Movie__c> getMoviesByKey(String movieName){
            System.debug('movieName'+movieName);
            return DM001_MoviesActors.getMoviesByKey(movieName); 
    }

    @AuraEnabled(Cacheable=true)
    public static List<Movie__c> getAllMovies(){      
            return DM001_MoviesActors.getAllMovies();   
    }


    //wrapper class Entity 
    public class NewMovie{

        public newMovie(){
    
        }

        @auraEnabled
        public String name {get;set;}
        @auraEnabled
        public String category {get;set;}
        @auraEnabled
        public String  description{get;set;}
        @auraEnabled
        public Integer  rating {get;set;}
        @AuraEnabled
        public Date releaseDate {get;set;}

      
    }
}
