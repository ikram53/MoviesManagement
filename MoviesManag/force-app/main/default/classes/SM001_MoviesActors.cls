public with sharing class SM001_MoviesActors {

    public SM001_MoviesActors() {

    }

   
   /*
    *** Creates a content version from a given file's base64 and name
   */
    private static ContentVersion createContentVersion(String base64, String filename,String contentDocumentId) {

        ContentVersion cv = new ContentVersion();
        cv.VersionData = EncodingUtil.base64Decode(base64);
        cv.Title = filename;
        cv.PathOnClient = filename;
        if(contentDocumentId  != null){
          cv.contentDocumentId = contentDocumentId;
        }
        try {
          insert cv;
          return cv;
        } catch(DMLException e) {
          System.debug(e);
          return null;
        }
  }

    /*
      *** Creates a content link for a given ContentVersion and record
    */
    private static ContentDocumentLink createContentLink(String contentVersionId, String recordId) {
          if (contentVersionId == null || recordId == null) { return null; }
          ContentDocumentLink cdl = new ContentDocumentLink();
          cdl.ContentDocumentId = DM001_MoviesActors.getContentDocumentId(contentVersionId);
          cdl.LinkedEntityId = recordId;
          // ShareType is either 'V', 'C', or 'I'
          // V = Viewer, C = Collaborator, I = Inferred
          cdl.ShareType = 'V';
          try {
              insert cdl;
              return cdl;
          } catch(DMLException e) {
              System.debug(e);
              return null;
          }
    }

    /*
      *** Creates a content link for a given ContentVersion and record
    */
    @AuraEnabled
    public static void createMovie(NewMovie newMovie,List<String> movieActorsIds,String base64,String filename) {

         Movie__c newMovieToinsert = new Movie__c();

         ContentVersion cv = createContentVersion(base64, filename,null);

         newMovieToinsert.Name = newMovie.name;
         newMovieToinsert.category__c = newMovie.category;
         newMovieToinsert.Description__c = newMovie.description;
         newMovieToinsert.Rating__c = newMovie.rating+'/5';
         newMovieToinsert.Release_date__c = newMovie.releaseDate;
         newMovieToinsert.contentDocumentId__c= DM001_MoviesActors.getContentDocumentId(cv.Id);
        

         insert newMovieToinsert;
  
         ContentDocumentLink cdl = createContentLink(cv.Id, newMovieToinsert.Id);

         List<MovieActor__c> movieActorsToinsert  =new List<MovieActor__c>();

         for(String idActor : movieActorsIds){
            MovieActor__c movieActor =new MovieActor__c();
            movieActor.Actor__c=idActor;
            movieActor.Movie__c=newMovieToinsert.Id;
            movieActorsToinsert.add(movieActor);

         }
        insert movieActorsToinsert;

    
    }

    /*
      *** Update movie's picture by creating new content version of document
    */
    @AuraEnabled
    public static void updateMoviePic(String base64,String filename,String contentDocumentId){
         ContentVersion cv = createContentVersion(base64, filename,contentDocumentId);
        
    }


    /*
      *** Search for movies by key
    */
    @AuraEnabled
    public static List<Movie__c> getMoviesByKey(String movieName){
            return DM001_MoviesActors.getMoviesByKey(movieName); 
    }

    /*
      *** Get all movies
    */
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
        public String  rating {get;set;}
        @AuraEnabled
        public Date releaseDate {get;set;}
        @AuraEnabled
        public String contentDocumentId {get;set;}

      
    }
}
