import { LightningElement, api, track, wire } from 'lwc';
import getAccount from '@salesforce/apex/OrderManagementService.getAccount';
import findProducts from '@salesforce/apex/OrderManagementService.findProducts';
import getUser from '@salesforce/apex/OrderManagementService.getUser';
import checkOut from '@salesforce/apex/OrderManagementService.checkOut';
import USER_ID from '@salesforce/user/Id';
import CHANNEL from '@salesforce/messageChannel/channel__c';
import { subscribe, MessageContext, APPLICATION_SCOPE } from 'lightning/messageService';

export default class OrderManagement extends LightningElement {

    @wire(MessageContext) messageContext;
    @api accountId;
    account;
    user;
    searchProductName = '';
    productsInCart = [];
    productsInCartMap = new Map;
    @track products;
    @track selectedProductTypes = ['type 1', 'type 2', 'type 3'];
    @track selectedProductFamilies = ['family 1', 'family 2', 'family 3'];
    openProductModal = false;
    openCartModal = false;

    connectedCallback() {
        this.subscribeToMessageChannel();
        this.loadUserInfo(USER_ID);
        this.handleAccountLoad();
        this.handleSearch();
    }

    resetCart() {
        this.productsInCartMap = new Map;
        this.productsInCart = [];
    }

    handleCheckout() {
        this.handleCloseCartModal();
        var productIds = [];
        for (const item of this.productsInCart) {
            while(item.amount > 0) {
                productIds.push(item.product.Id)
                item.amount--;
            }
        }
        checkOut({productIds: productIds, accountId: this.account.Id})
            .then(result => {
                if (result) {
                    this.resetCart();
                    alert('Order has been created');
                } else {
                    this.resetCart();
                    this.handleError('Check out failed on backend');
                }
            })
            .catch(error => {
                this.resetCart();
                this.handleError(error);
            });
    }

    subscribeToMessageChannel() {
        if (!this.subscription) {
            this.subscription = subscribe(
                this.messageContext,
                CHANNEL,
                (message) => this.handleMessage(message),
                { scope: APPLICATION_SCOPE }
            );
        }
    }

    handleMessage(message) {
        switch (message.name) {
            case "checkout": {
                this.handleCheckout();
                break;
            }
            case "add": {
                var item = this.productsInCartMap.get(message.value.Id);
                if (item == undefined) {
                    this.productsInCartMap.set(message.value.Id, {product: message.value, amount: 1});
                } else {
                    item.amount++;
                }
                this.productsInCart = this.productsInCartMap.values();
                break;
            }
            case "remove": {
                var item = this.productsInCartMap.get(message.value.Id);
                if (item.amount > 1) {
                    item.amount--;
                } else {
                    this.productsInCartMap.delete(message.value.Id);
                }
                this.productsInCart = this.productsInCartMap.values();
                break;
            }
        }
    }

    handleCloseCartModal() {
        this.openCartModal = false;
        this.productsInCart = this.productsInCartMap.values();
    }

    handleCloseProductModal() {
        this.openProductModal = false;
    }

    createProduct() {
        this.openProductModal = true;
    }

    openCart() {
        this.openCartModal = true;
    }

    loadUserInfo(userId) {
        getUser({id: userId})
            .then(result => {
                this.user = result;
            })
            .catch(error => {
                this.handleError(error);
            });
    }

    handleFilterClear() {
        this.selectedProductFamilies = [];
        this.selectedProductTypes = [];
    }

    handleAccountLoad() {
        getAccount({ id : this.accountId })
            .then(result => {
                this.account = result;
            })
            .catch(error => {
                this.handleError(error);
            });
    }

    handleSearch() {
        findProducts({
                name: this.searchProductName,
                types: this.selectedProductTypes,
                families: this.selectedProductFamilies
            })
            .then(result => {
                this.products = result;
            })
            .catch(error => {
                this.handleError(error);
            });
    }

    handleKeyChange(event) {
        this.searchProductName = event.target.value;
    }

    handleTypeValuesChange(event) {
        this.selectedProductTypes = event.target.value;
    }

    handleFamilyValuesChange(event) {
        this.selectedProductFamilies = event.target.value;
    }

    get typeOptions() {
        return [
            {label: 'type 1', value: 'type 1'},
            {label: 'type 2', value: 'type 2'},
            {label: 'type 3', value: 'type 3'}
        ];
    }

    get familyOptions() {
        return [
            {label: 'family 1', value: 'family 1'},
            {label: 'family 2', value: 'family 2'},
            {label: 'family 3', value: 'family 3'}
        ];
    }

    handleError(error) {
        console.log('Error');
        console.log(error);
        this.dispatchEvent(new ShowToastEvent({
            title: "Error",
            message: error,
            variant: "error"
        }));
    }

}