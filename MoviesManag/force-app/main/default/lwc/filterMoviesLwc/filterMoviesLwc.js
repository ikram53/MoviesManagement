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
      console.log('hello1');
      this.movieName=event.target.value;
      console.log('hello1');
      console.log(this.movieName);
      this.template.querySelector('c-movies-results-lwc').searchMovies(this.movieName);
      console.log('fin');
    }

    
}