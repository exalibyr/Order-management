({
    doInit : function(component, event, helper) {
        var evt = $A.get("e.force:navigateToComponent");
        evt.setParams({
            componentDef : "c:orderManagement",
            componentAttributes: {
                accountId : component.get("v.recordId")
            }
        });
        evt.fire();
    }
})