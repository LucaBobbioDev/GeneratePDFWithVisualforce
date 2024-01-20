# Generate PDF With Visualforce - Salesforce
Simples projeto realizado no CRM Salesforce onde foi desenvolvido a funcionalidade de exportação de dados de registros de pedidos (Order) no formato de PDF construído por meio da tecnologia do Visualforce. 

### Aura Component
Componente aura que é usado pelo quick action no layout padrão de um registro onde captura o recordId do registro de Order e envia para página Visualforce.

### Visualforce Page
Página Visualforce onde são usados os dados retornados pela classe controller para a construção e estruturação do documento PDF. Faz uso de um arquivo CSS para estilização.

### Apex Class
Classe controller para a página Visualforce onde os dados são obtidos da base de dados. Há duas innerClass para o mapeamento dos campos dos objetos de Order e OrderItem que são exibidos na página Visualforce
