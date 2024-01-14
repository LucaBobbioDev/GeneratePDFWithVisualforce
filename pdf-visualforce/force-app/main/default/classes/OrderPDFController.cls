public with sharing class OrderPDFController {
    public Order order {get;set;}
    public OrderPDFController(ApexPages.StandardController standardPageController) {
        order = (Order) standardPageController.getRecord();
        Id orderId = Id.valueOf(String.escapeSingleQuotes(ApexPages.currentPage().getParameters().get('Id').escapeHtml4()));
        System.debug('orderId: ' + orderId);
        if (orderId != null) {
            Order order = getOrder(orderId);
            OrderPDFController.OrderData currentOrder = new OrderPDFController.OrderData(order);
            
            List<OrderItem> orderItems = getOrderItems(orderId);
            currentOrder.orderItems = new List<OrderPDFController.OrderItemData>();
            for (OrderItem currentItem : orderItems) {
                currentOrder.orderItems.add(new OrderPDFController.OrderItemData(currentItem));
            }
        }
    }

    public PageReference savePDF() {
        Id orderId = Id.valueOf(String.escapeSingleQuotes(ApexPages.currentPage().getParameters().get('Id').escapeHtml4()));
        PageReference currentPDf = Page.GenerateOrderPDF;
        currentPDf.getParameters().put('id', orderId);
        Blob pdfBlob;
        if (!Test.isRunningTest()) {
			pdfBlob = currentPDf.getContent();
		} else {
			pdfBlob = Blob.valueOf('PDF file...');
		}

        List<Attachment> attRelatedToOrder = [SELECT Id FROM Attachment WHERE ParentId =: orderId];

        Attachment pdf = new Attachment();
        pdf.Body = pdfBlob;
        //pdf.Name = 'Pedido ' + this.currentOrder.orderNumber + ' ' + String.valueOf(System.today()) + ' V' + attRelatedToOrder.size() + '.pdf';
        pdf.IsPrivate = false;
        pdf.ParentId = orderId;
        insert pdf;

        Pagereference newTab = new Pagereference('/servlet/servlet.FileDownload?file=' + pdf.Id);
        return newTab;
    }

    public static Order getOrder(Id orderId) {
        Order order = [
            SELECT Id,
                   Account.Name,
                   Account.CNPJ__c,
                   AccountAddress__r.Name,
                   Address__r.Name,
                   AddressCode__c,
                   CurrencyIsoCode,
                   DeliveryDate__c,
                   DeliveryDateERP__c,
                   DistributionCenter__r.Name,
                   EffectiveDate,
                   EndDate__c,
                   Payment__c,
                   PaymentTerms__r.Name,
                   Pricebook2.Name,
                   TotalAmount,
                   TypeOfFreight__c,
                   Owner.LastName,
                   Owner.FirstName,
                   CreatedBy.FirstName,
                   Status,
                   OrderNumber,
                   OrderNumber__c,
                   Observations__c
            FROM Order
            WHERE Id =: orderId
        ];

        return order;
    }

    public static List<OrderItem> getOrderItems(String orderId) {
        List<OrderItem> orderItems = [
            SELECT Id,
                   OrderId,
                   Discount__c,
                   Quantity,
                   UnitPrice,
                   TotalPrice,
                   Product2.Name,
                   ProductCode__c,
                   OrderItemCode__c,
                   OrderItemNumber,
                   TotvsItem__c
              FROM OrderItem
             WHERE OrderId =: orderId
        ];

        return orderItems;
    }

    public class OrderData {
        public String orderId {get; set;}
        public String accountName {get; set;}
        public String accountCnpj {get; set;}
        public String addressName {get; set;}      
        public String addressCode {get; set;}  
        public String orderCurrency {get; set;}  
        public String deliveryDate {get; set;}
        public String deliveryDateERP {get; set;}
        public String distributionCenterName {get; set;}
        public String effectiveDate {get; set;}
        public String endDate {get; set;}
        public String paymentConditionName {get; set;}       
        public String paymentMethodName {get; set;}
        public String pricebookName {get; set;}       
        public String typeOfFreight {get; set;}   
        public Decimal totalAmount {get; set;}
        public String ownerFullName {get; set;}
        public String externalOrderNumber {get; set;}
        public String orderNumberSF {get; set;}
        public String status {get; set;}
        public String createdBy {get; set;}
        public String observations {get; set;}

        public List<OrderItemData> orderItems {get; set;}

        public OrderData(Order order){
            this.orderId = order.Id;
            this.accountName = order.Account.Name;
            this.accountCnpj = order.Account.CNPJ__c;
            this.addressName = order.AccountAddress__r.Name;
            this.addressCode = order.AddressCode__c;
            this.orderCurrency = order.CurrencyIsoCode;
            this.deliveryDate = String.valueOf(order.DeliveryDate__c); 
            this.deliveryDateERP = String.valueOf(order.DeliveryDateERP__c);
            this.distributionCenterName = order.DistributionCenter__r.Name;
            this.effectiveDate = String.valueOf(order.EffectiveDate);
            this.endDate = String.valueOf(order.EndDate__c);
            this.paymentConditionName = order.PaymentTerms__r.Name;
            this.paymentMethodName = order.Payment__c;
            this.pricebookName = order.Pricebook2.Name;
            this.totalAmount = order.TotalAmount;
            this.typeOfFreight = order.TypeOfFreight__c;
            this.ownerFullName = order.Owner.FirstName + ' ' + order.Owner.LastName;
            this.createdBy = order.CreatedBy.FirstName;
            this.status = order.Status;
            this.orderNumberSF = order.OrderNumber;
            this.externalOrderNumber = order.OrderNumber__c;
            this.observations = order.Observations__c;
        }
    }

    public class OrderItemData {
        public String orderItemId {get; set;}
        public String orderItemCode {get; set;}
        public String orderItemNumber {get; set;}
        public String orderId {get; set;}
        public String productCode {get; set;}
        public String productId {get; set;}
        public String productName {get; set;}
        public Decimal quantity {get; set;}
        public String unitPrice {get; set;}
        public String totalPrice {get; set;}
        public String discount {get; set;}
        public Boolean totvsItem {get; set;}
    
        public OrderItemData(OrderItem item){
            this.orderItemId = item.Id;
            this.orderItemCode = item.OrderItemCode__c;
            this.orderItemNumber = item.OrderItemNumber;
            this.orderId = item.OrderId;
            this.productCode = item.ProductCode__c;
            this.productId = item.Product2Id;
            this.productName = item.Product2.Name;
            this.quantity = item.Quantity;
            this.unitPrice = String.valueOf(item.UnitPrice); 
            this.totalPrice = String.valueOf(item.TotalPrice);
            this.discount = String.valueOf(item.Discount__c);
            this.totvsItem = item.TotvsItem__c;
        }
    }
}