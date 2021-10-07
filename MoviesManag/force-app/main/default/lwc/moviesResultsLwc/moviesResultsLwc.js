import { LightningElement } from 'lwc';

export default class MoviesResultsLwc extends LightningElement {
    movieName = '';

    handlemovieNameChange(event){
        this.movieName = event.target.value;
    }

}