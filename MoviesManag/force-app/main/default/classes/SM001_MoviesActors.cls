public with sharing class SM001_MoviesActors {

    public SM001_MoviesActors() {

    }

    /*
        * @method uploadFile() 
        * @desc Creates a content version from a given file's base64 and name
        * 
        * @param {String} base64 - base64 string that represents the file
        * @param {String} filename - full file name with extension, i.e. 'products.csv'
        * @param {String} recordId - Id of the record you want to attach this file to
        * 
        * @return {ContentVersion} - returns the created ContentDocumentLink Id if the
        *   upload was successful, otherwise returns null
   */
   @AuraEnabled
   public static String uploadFile(String base64, String filename, String recordId) {
         ContentVersion cv = createContentVersion(base64, filename,null);
         ContentDocumentLink cdl = createContentLink(cv.Id, recordId);
         if (cv == null || cdl == null) { return null; }
         return cdl.Id;
   }

   /*
        * @method createContentVersion() [private]
        * @desc Creates a content version from a given file's base64 and name
        * 
        * @param {String} base64 - base64 string that represents the file
        * @param {String} filename - full file name with extension, i.e. 'products.csv'
        * 
        * @return {ContentVersion} - returns the newly created ContentVersion, or null
        *   if there was an error inserting the record
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
        * @method createContentLink() [private]
        * @desc Creates a content link for a given ContentVersion and record
        * 
        * @param {String} contentVersionId - Id of the ContentVersion of the file
        * @param {String} recordId - Id of the record you want to attach this file to
        * 
        * @return {ContentDocumentLink} - returns the newly created ContentDocumentLink, 
        *   or null if there was an error inserting the record
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
         System.debug('newMovieToinsert'+newMovieToinsert);

         ContentDocumentLink cdl = createContentLink(cv.Id, newMovieToinsert.Id);

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
    public static void updateMoviePic(String base64,String filename,String contentDocumentId){
         ContentVersion cv = createContentVersion(base64, filename,contentDocumentId);
        
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
        public String  rating {get;set;}
        @AuraEnabled
        public Date releaseDate {get;set;}
        @AuraEnabled
        public String contentDocumentId {get;set;}

      
    }
}
