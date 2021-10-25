import { LightningElement,track } from 'lwc';

export default class FilterMoviesLwc extends LightningElement {

    showCreateMovieModal = false;
    movieName='';
    

    createMovie(){
      this.showCreateMovieModal = true;
    }

    closeCreateMovie(){
      this.showCreateMovieModal = false;
    }

    handlemovieNameChange(event){
      this.movieName=event.target.value;
      this.template.querySelector('c-movies-results-lwc').searchMovies(this.movieName);
    }

    
}