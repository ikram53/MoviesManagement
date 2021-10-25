import { LightningElement,track ,wire,api} from 'lwc';
import getMoviesByKey from '@salesforce/apex/SM001_MoviesActors.getMoviesByKey';
import getAllMovies from '@salesforce/apex/SM001_MoviesActors.getAllMovies';

export default class MoviesResultsLwc extends LightningElement {
    @api movieName;
     movies=[];
    currentmovie='';
    handlemovieNameChange(event){
        this.movieName = event.target.value;
    }

    @wire(getAllMovies)
    wiredMovies({ error, data }) {
        if (data) {
            console.log('data'+JSON.stringify(data[0]));
            console.log('data'+data[0].rating_pic__c);
            this.movies = data;
        } else if (error) {
            this.error = error;
        }
    }
  @api
  searchMovies(searchKey) {
   this.getMoviesByKey(searchKey);
  }

    getMoviesByKey(searchKey){

        getMoviesByKey({ movieName: searchKey })
        .then(result => {
            this.movies = result;
            console.log(this.movies);
        })
        .catch(error => {
            this.error = error;
        });
}
     getId(event){
        this.currentmovie=event.target.value;
         console.log(event.target.value);
     }
    }


