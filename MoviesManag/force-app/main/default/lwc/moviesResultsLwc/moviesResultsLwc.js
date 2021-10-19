import { LightningElement,track ,wire,api} from 'lwc';	
import { NavigationMixin } from 'lightning/navigation';
import getMoviesByKey from '@salesforce/apex/SM001_MoviesActors.getMoviesByKey';
import getAllMovies from '@salesforce/apex/SM001_MoviesActors.getAllMovies';

export default class MoviesResultsLwc extends LightningElement {
    @api movieName;
    movies=[];
    currentmovie='';

    showMoviePreview = false;

    handlemovieNameChange(event){
        this.movieName = event.target.value;
    }

  @wire(getAllMovies)
  wiredMovies({ error, data }) {
        if (data) {
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
  
  getCurrentMovie(event){
      console.log('******');
      console.log(event.target.value);
      this.currentmovie='a018E00000ErTZNQA3';
      this.showMoviePreview = true;
       
     
  }

  toMoviePreview(event){
        console.log('getCurrentMovie');
        console.log(event.target.value);
        this.currentmovie='a018E00000ErTZNQA3';
        this.showMoviePreview = true;
        this[NavigationMixin.Navigate]({
            type: 'standard__component',
            attributes: {
                componentName: 'c-movie-preview-lwc'
            },
            state: {
                recordId: 'a018E00000ErTZNQA3'
            }
        });
     }
    }
    


