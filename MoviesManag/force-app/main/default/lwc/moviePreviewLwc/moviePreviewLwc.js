import { LightningElement,wire,api,track } from 'lwc';
import { CurrentPageReference} from 'lightning/navigation';
import { deleteRecord } from 'lightning/uiRecordApi';
import { NavigationMixin } from 'lightning/navigation';
import updateMoviePic from '@salesforce/apex/SM001_MoviesActors.updateMoviePic';
import { getRecord, getFieldValue } from 'lightning/uiRecordApi';
import NAME from '@salesforce/schema/Movie__c.Name';
import DESCRIPTION from '@salesforce/schema/Movie__c.Description__c';
import RATING from '@salesforce/schema/Movie__c.rating__c';
import CATEGORY from '@salesforce/schema/Movie__c.Category__c';
import MOVIEPIC from '@salesforce/schema/Movie__c.movie_s_pic__c';
import RELEASEDATE from '@salesforce/schema/Movie__c.Release_date__c';
import CONTENTDOCUMENTID from '@salesforce/schema/Movie__c.contentDocumentId__c';
import MALEACTORPERCENTAGE from '@salesforce/schema/Movie__c.Male_Actors_Percentage__c';
import FEMELEACTORPERCENTAGE from '@salesforce/schema/Movie__c.Female_Actors_Percentage__c';


import { ShowToastEvent } from 'lightning/platformShowToastEvent';

const fields = [CONTENTDOCUMENTID, MOVIEPIC];




export default class MoviePreviewLwc extends NavigationMixin (LightningElement) {

    @track currentPageReference;

    // Expose a field to make it available in the template
    name=NAME;
    description=DESCRIPTION;
    rating=RATING;
    category=CATEGORY;
    moviePic=MOVIEPIC;
    contentDocumentId=CONTENTDOCUMENTID;
    releaseDate=RELEASEDATE;
    maleActorPercentage=MALEACTORPERCENTAGE;
    femeleActorPercentage=FEMELEACTORPERCENTAGE;

    showMoviePreview=true;
    loading = false;
    recordId;

    showUpdateMovie=false;
    objectApiName='Movie__c';

    // Toast options
    title = '';
    message = '';
    variant = '';
    
    fileData= {
        'filename': '',
        'base64': '',
    }
  
   
    //Get Record Id from current page
    @wire(CurrentPageReference)
    setCurrentPageReference(currentPageReference) {
        console.log('setCurrentPageRef');
        this.currentPageReference = currentPageReference;
        this.recordId = this.currentPageReference?.state?.c__recordId;
    }

    @wire(getRecord, { recordId: '$recordId', fields})
    currentMovie;

   

    updateMovie(){
        this.showUpdateMovie=true;
        this.showMoviePreview=false;
    }


    deleteMovie(){
        var flag = confirm("Are you sure you want to delete?");
        if(flag == true){
            this.loading = true;
            deleteRecord(this.recordId)
            .then(() => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Success',
                        message: 'Movie deleted successfully',
                        variant: 'success'
                    })
                );
                this.loading = false;
    
                // Navigate to Movies Management page 
                this[NavigationMixin.Navigate]({
                    type: 'standard__navItemPage',
                    attributes: {
                        apiName: 'Movies_Management'
                    }
                });
                this.showMoviePreview=false;
                window.close();
            })
            .catch(error => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error while deleting record',
                        message: error.body.message,
                        variant: 'error'
                    })
                );
            });
        }

    }

    
    handleSuccess(event) {

        this.loading=true;

        this.updateMoviePic();

        this.title = 'Update Movie';
        this.message = 'Movie is updated successfly';
        this.variant = 'success';
        this.showNotification();
       
        this.showUpdateMovie=false;
        this.showMoviePreview=true;
        this.loading=false;
        
    }

    handleSubmit(event){
      //this.loading=true;
   }
    

    handleError(event){
        console.log(event);
        this.title = 'Update Movie';
        this.message = 'An error occured while trying to update the record. Please try again';
        this.variant = 'error';
        this.showNotification();
    }

    showNotification() {
        const evt = new ShowToastEvent({
            title: this._title,
            message: this.message,
            variant: this.variant,
        });
        this.dispatchEvent(evt);
    }

    backToViewRecord(){
        console.log('backToViewRecord');
        this.showUpdateMovie=false;
        this.showMoviePreview=true;
    }

    chooseFile(event){
       
        const file = event.target.files[0];
            var reader = new FileReader();
            reader.onload = () => {
                var base64 = reader.result.split(',')[1]
                this.fileData = {
                    'filename': file.name,
                    'base64': base64
                }
            }
            reader.readAsDataURL(file);
    }
   

    updateMoviePic(){

       if(this.fileData.base64){
            updateMoviePic({base64:this.fileData.base64,
                           filename:this.fileData.filename,
                           contentDocumentId:getFieldValue(this.currentMovie.data, CONTENTDOCUMENTID)})
                   .then(result =>{
                           window.location.reload();
                   })
                   .catch(error => {
                            console.log(error);
                   });
            }
        }

      
       
    

}