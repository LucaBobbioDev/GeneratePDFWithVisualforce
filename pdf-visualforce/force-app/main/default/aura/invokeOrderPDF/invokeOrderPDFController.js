({
    newpagePDF: function(component, event, helper) {
        let newpage = window.open('/apex/GenerateOrderPDF?id=' + component.get("v.recordId"));
        helper.showToast('success', 'Sucesso', 'PDF gerado com sucesso!')
    }
})