trigger OrderItemTrigger on OrderItem_c__c (after insert) {

    if (Trigger.isAfter && Trigger.isInsert) {
        try {
            OrderItemHandler.handleOrder(Trigger.new);
        } catch(Exception e) {
            System.debug(e);
        }
    }

}