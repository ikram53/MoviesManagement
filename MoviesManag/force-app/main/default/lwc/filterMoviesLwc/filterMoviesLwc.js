import { LightningElement,track } from 'lwc';

export default class FilterMoviesLwc extends LightningElement {

    showCreateMovieModal = false;

    createMovie(){
      this.showCreateMovieModal = true;
    }

    closeCreateMovie(){
      this.showCreateMovieModal = false;
    }

}