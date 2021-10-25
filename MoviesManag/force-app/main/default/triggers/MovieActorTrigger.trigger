trigger MovieActorTrigger on MovieActor__c (after insert) {

 
    List<Actor__c> actorsToUpdate = new List<Actor__c>();
    List<MovieActor__c> movieActors = [SELECT actor__r.Number_of_movies__c,actor__r.Id,actor__r.Gender__c,movie__c
                                       FROM MovieActor__c
                                       WHERE id in :Trigger.New];

    
    Map<Id,List<Actor__c>> movieByActors = new  Map<Id,List<Actor__c>>();                              


    for(MovieActor__c movieActor:movieActors){
        
        Actor__c actor = new Actor__c(Id=movieActor.actor__r.Id);
        actor.Number_of_movies__c = movieActor.actor__r.Number_of_movies__c+1;
        actor.Gender__c = movieActor.actor__r.Gender__c;
        actorsToUpdate.add(actor); 

        //Buil movieByActors map
        if(!movieByActors.containsKey(movieActor.movie__c)){
            movieByActors.put(movieActor.movie__c,new List<Actor__c>());
            movieByActors.get(movieActor.movie__c).add(actor);
        }
        else{
            movieByActors.get(movieActor.movie__c).add(actor);
        }  
    }
        update actorsToUpdate;


        for(Id movieId:movieByActors.keySet()){
            MovieActorTriggerHandler.calculateGenderPercentage(movieByActors.get(movieId),movieId);
        }

        

}