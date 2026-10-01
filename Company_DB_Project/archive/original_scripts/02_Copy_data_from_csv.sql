-- copying all csv data into tables

COPY inventory.categories
FROM 'S:\SQL\Company_DB_Project\datadets\categories.csv'
WITH (FORMAT csv, HEADER true);

COPY inventory.products
FROM 'S:\SQL\Company_DB_Project\datadets\products.csv'
WITH (FORMAT csv, HEADER true);

COPY hr.departments
FROM 'S:\SQL\Company_DB_Project\datadets\departments.csv'
WITH (FORMAT csv, HEADER true);

COPY hr.employees
FROM 'S:\SQL\Company_DB_Project\datadets\employees.csv'
WITH (FORMAT csv, HEADER true);

COPY hr.projects
FROM 'S:\SQL\Company_DB_Project\datadets\projects.csv'
WITH (FORMAT csv, HEADER true);

COPY hr.employee_projects
FROM 'S:\SQL\Company_DB_Project\datadets\employee_projects.csv'
WITH (FORMAT csv, HEADER true);

COPY sales.customers
FROM 'S:\SQL\Company_DB_Project\datadets\customers.csv'
WITH (FORMAT csv, HEADER true);

COPY sales.archived_customers
FROM 'S:\SQL\Company_DB_Project\datadets\archived_customers.csv'
WITH (FORMAT csv, HEADER true);

COPY sales.orders
FROM 'S:\SQL\Company_DB_Project\datadets\orders.csv'
WITH (FORMAT csv, HEADER true);

COPY sales.order_items
FROM 'S:\SQL\Company_DB_Project\datadets\order_items.csv'
WITH (FORMAT csv, HEADER true);