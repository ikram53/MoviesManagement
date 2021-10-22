import { LightningElement,track ,wire,api} from 'lwc';	
import { NavigationMixin } from 'lightning/navigation';
import { refreshApex } from '@salesforce/apex';
import getMoviesByKey from '@salesforce/apex/SM001_MoviesActors.getMoviesByKey';
import getAllMovies from '@salesforce/apex/SM001_MoviesActors.getAllMovies';

export default class MoviesResultsLwc extends  NavigationMixin(LightningElement) {
    @api movieName;
    @track movies=[];
    @track wiredMovie;
    currentmovie='';

    showMoviePreview = false;


    connectedCallback() {
        refreshApex(this.wiredMovie);
    }

    handlemovieNameChange(event){
        this.movieName = event.target.value;
    }

    @wire(getAllMovies)
    wiredMovies(result) {
        this.wiredMovie=result;
        console.log('wiredMovieeeeees ***');
            if (this.wiredMovie.data) {
                console.log(this.wiredMovie.data);
                this.movies = this.wiredMovie.data;
            } else if (this.wiredMovie.error) {
                this.error = this.wiredMovie.error;
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
        console.log('getCurrentMovie');

        this.currentmovie=event.currentTarget.dataset.id;
        this[NavigationMixin.Navigate]({
            type: 'standard__navItemPage',
                attributes: {
                    apiName: 'Movie_Preview'
                },
                state: {
                    c__recordId: this.currentmovie
                }
            }); 
    }

    

    
     
}
    


