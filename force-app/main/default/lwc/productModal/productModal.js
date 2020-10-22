import { LightningElement, api, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import PRODUCT_OBJECT from '@salesforce/schema/Product_c__c';
import PRODUCT_NAME_FIELD from '@salesforce/schema/Product_c__c.Name';
import PRODUCT_DESCRIPTION_FIELD from '@salesforce/schema/Product_c__c.Description__c';
import PRODUCT_FAMILY_FIELD from '@salesforce/schema/Product_c__c.Family__c';
import PRODUCT_TYPE_FIELD from '@salesforce/schema/Product_c__c.Type__c';
import PRODUCT_IMAGE_FIELD from '@salesforce/schema/Product_c__c.Image__c';
import PRODUCT_PRICE_FIELD from '@salesforce/schema/Product_c__c.Price__c';

export default class ProductModal extends LightningElement {

    @api openModal;
    objectApiName = PRODUCT_OBJECT;
    fields = [PRODUCT_NAME_FIELD, PRODUCT_DESCRIPTION_FIELD, PRODUCT_FAMILY_FIELD,
         PRODUCT_TYPE_FIELD, PRODUCT_IMAGE_FIELD, PRODUCT_PRICE_FIELD];

    handleProductCreated(event) {
        this.openModal = false;
        this.dispatchEvent(new ShowToastEvent({
            title: "Product created",
            message: "Record ID: " + event.detail.id,
            variant: "success"
        }));
        this.dispatchEvent(new CustomEvent('close'));
    }

    handleCanceled() {
        this.openModal = false;
        this.dispatchEvent(new CustomEvent('close'));
    }

    handleError(event) {
        this.openModal = false;
        console.log('modal = ' + this.openModal);
        this.dispatchEvent(new ShowToastEvent({
            title: "Error",
            message: event.message,
            variant: "error"
        }));
        this.dispatchEvent(new CustomEvent('close'));
    }

}