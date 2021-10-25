public with sharing class MovieActorTriggerHandler {

    public MovieActorTriggerHandler() {}

    public static void calculateGenderPercentage(List<Actor__c> movieActors,Id currentMovieId){


        Integer actorsNumber = movieActors.size();
        Integer femaleActorsNumber=0;
        Integer maleActorsNumber=0;

  
        
        for(Actor__c actor:movieActors){

            if(actor.Gender__c == System.Label.Gender_Female){
                femaleActorsNumber++;
                system.debug(femaleActorsNumber);
            }else {
                maleActorsNumber++;
                system.debug(maleActorsNumber);
            }
        }

        Movie__c currentMovie = new Movie__c(Id=currentMovieId);
        
        currentMovie.Female_Actors_Percentage__c = (femaleActorsNumber*100)/actorsNumber;
        currentMovie.Male_Actors_Percentage__c = (maleActorsNumber*100)/actorsNumber;
        update currentMovie;
        
    }

}
