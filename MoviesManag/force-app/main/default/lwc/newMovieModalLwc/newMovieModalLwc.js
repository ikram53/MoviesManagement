import { LightningElement,track,api } from 'lwc';
import ACTORS from "@salesforce/schema/MovieActor__c.Actor__c"
import NAME from "@salesforce/schema/Actor__c.Name"
import MoviesCategories from "@salesforce/schema/Movie__c.Category__c"
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import createNewMovie from '@salesforce/apex/SM001_MoviesActors.createMovie';


export default class NewMovieModalLwc extends LightningElement {

    @api showCreateMovieModal;
    @track actors = ACTORS;
    @track name = NAME;
    @track categories = MoviesCategories;

    // Toast optionsÒ
    title = '';
    message = '';
    variant = '';


    @track newMovie = {
               Name:"",
               description:"",
               category:"",
               rating:"",
               releaseDate:new Date()
            };

    @track movieActors =  [];
    currentActor = '';
    category = '';
    
   
   addActor(){
   
      if(this.movieActors.find(key => key=== this.currentActor)){

        this.title = 'Actor already exist';
        this.message = 'Choose another actor, this actor already exist';
        this.variant = 'error';
        this.currentActor = '';
        this.showNotification();
      } 

      else if(this.currentActor.length == 0){

        this.title = 'Actor';
        this.message = 'Choose an actor ! ';
        this.variant = 'warning';
        this.currentActor = '';
        this.showNotification();


      } 
      else{
        console.log('else');

        this.movieActors.push(this.currentActor);
        this.currentActor = '';
      } 
      
    }  
    
    closeModal() {
        this.showCreateMovieModal = false;

        const selectedEvent = new CustomEvent('shareclosed', { });
        this.dispatchEvent(selectedEvent);
    }

    
   

    chooseCategory(event) {
        this.newMovie.category=event.target.value;
    }  

    changeName(event){
        this.newMovie.Name=event.target.value;
    }

    changeDesc(event){
        this.newMovie.description=event.target.value;
    }

    changeReleaseDate(event){
        console.log(event.target.value);
        this.newMovie.releaseDate=event.target.value;
    }
    

    removeActor(event) {
        this.movieActors = this.movieActors.filter(actor => {return actor !== event.target.value;} );
    } 
    
    chooseActor(event){
        this.currentActor = event.target.value;
    }

    
    rating(event){
        console.log('event'+event.target.value);
        this.newMovie.rating=event.target.value;
    }


    showNotification() {
        const evt = new ShowToastEvent({
            title: this._title,
            message: this.message,
            variant: this.variant,
        });
        this.dispatchEvent(evt);
    }

    createMovie(){
        console.log('createMovie');
       
        console.log(JSON.stringify(this.newMovie));
        createNewMovie({newMovie:this.newMovie ,movieActorsIds:JSON.stringify(this.movieActors)})
                   .then(result =>{
                       console.log('result'+result);
                   })
                   .catch(error =>{
                       console.log('error'+error);
                   })
          
        
    }
}