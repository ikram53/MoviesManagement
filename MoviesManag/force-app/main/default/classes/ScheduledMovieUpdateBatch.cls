global with sharing class ScheduledMovieUpdateBatch implements Schedulable{

    
    public ScheduledMovieUpdateBatch() {

    }
    global void execute(SchedulableContext ctx) {

        MovieUpdateBatch movieUpdateBatch = new MovieUpdateBatch();
        //Parameters of ExecuteBatch(context,BatchSize)
        ID batchprocessid = Database.executeBatch(movieUpdateBatch);

    }
}
