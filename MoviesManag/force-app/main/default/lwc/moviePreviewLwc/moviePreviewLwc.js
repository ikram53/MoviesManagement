import { LightningElement,wire,api } from 'lwc';
import NAME from '@salesforce/schema/Movie__c.Name';
import DESCRIPTION from '@salesforce/schema/Movie__c.Description__c';
import RATING from '@salesforce/schema/Movie__c.rating__c';
import CATEGORY from '@salesforce/schema/Movie__c.Category__c';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class MoviePreviewLwc extends LightningElement {
    // Expose a field to make it available in the template
    name=NAME;
    description=DESCRIPTION;
    rating=RATING;
    category=CATEGORY;

    @api showMoviePreview;
    @api recordId;

    showUpdateMovie=false;
    objectApiName='Movie__c';

    // Toast options
    title = '';
    message = '';
    variant = '';

    
    
    closeModal() {
        this.showMoviePreview = false;
    }

    updateMovie(){
        this.showUpdateMovie=true;
        this.showMoviePreview=false;
    }
    deleteMovie(){}

    handleSuccess(event) {
        console.log(event);
        this.title = 'Update Movie';
        this.message = 'Movie is updated successfly';
        this.variant = 'success';
        this.showNotification();
    }

    handleError(event){

        this.title = 'Update Movie';
        this.message = 'Error';
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

    resetForm(event) {
        const fields = this.template.querySelectorAll("lightning-input-field");
        fields.forEach((field) => {
          field.reset();
        });
      }


}