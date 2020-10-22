import { LightningElement , api , wire } from 'lwc';
import CHANNEL from '@salesforce/messageChannel/channel__c';
import {publish, MessageContext} from 'lightning/messageService';

export default class CartModal extends LightningElement {

    @wire(MessageContext)
    messageContext;
    @api productsInCart;
    @api openModal;

    closeCart() {
        this.openModal = false;
        this.dispatchEvent(new CustomEvent('close'));
    }

    checkOut() {
        this.openModal = false;
        const message = {
            name: "checkout"
        };
        publish(this.messageContext, CHANNEL, message);
    }

}