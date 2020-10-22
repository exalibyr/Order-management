import { LightningElement, api, wire } from 'lwc';
import CHANNEL from '@salesforce/messageChannel/channel__c';
import {publish, MessageContext} from 'lightning/messageService';

export default class ProductItem extends LightningElement {

    @wire(MessageContext)
    messageContext;
    @api product;
    @api amount;
    @api isCart;

    openProductDetails() {
        window.open('/lightning/r/Product_c__c/' + this.product.Id + '/view');
    }

    addToCard() {
        const message = {
            name: "add",
            value: this.product
        };
        publish(this.messageContext, CHANNEL, message);
    }

    removeFromCart() {
        const message = {
            name: "remove",
            value: this.product
        };
        publish(this.messageContext, CHANNEL, message);
    }

}