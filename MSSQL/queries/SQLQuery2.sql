
	SELECT
    city,
    first_name,
    last_name
FROM
    sales.customers
ORDER BY
    city,
    first_name;

	/* 2. len(string) */
	SELECT top 3
    first_name,
    last_name
FROM
    sales.customers
ORDER BY
    LEN(first_name) DESC;

	/* 3.OFFSET 10 ROWS */
	SELECT
	product_name,
	list_price
	FROM
	production.products
	ORDER BY
	list_price,
	product_name
	OFFSET 10 ROWS;

	/* 3.OFFSET 10 ROWS AND FETCH  NEXT 10 ROWS */
	SELECT
	product_name,
	list_price
	FROM
	production.products
	ORDER BY
	list_price,
	product_name
	OFFSET 10 ROWS
	FETCH NEXT 10 ROWS ONLY;

	/*4. get the TOP 10 most expensive products */
	SELECT
		product_name,
		list_price
	FROM
		production.products
	ORDER BY
		list_price DESC,
		product_name
	OFFSET 0 ROWS
	FETCH FIRST 10 ROWS ONLY;

	/*5. Using TOP with a constant value */
	SELECT TOP 10
    product_name, 
    list_price
FROM
    production.products
ORDER BY 
    list_price DESC;

	/*6.Using TOP to return a percentage of rows*/
	SELECT TOP 1 PERCENT
    product_name, 
    list_price
FROM
    production.products
ORDER BY 
    list_price DESC;

	/*Using TOP WITH TIES to include rows that match the values in the last row*/
	SELECT TOP 3 WITH TIES
    product_name, 
    list_price
FROM
    production.products
ORDER BY 
    list_price DESC;