# CompanyDB – 300 SQL Practice Questions

**Database:** CompanyDB  
**Schemas:** `hr`, `sales`, `inventory` (or all in `public`)

**Tables:**
- hr.departments, hr.employees, hr.projects, hr.employee_projects
- sales.customers, sales.archived_customers, sales.orders, sales.order_items
- inventory.products, inventory.categories

---

## 1. Basic SELECT & Filtering (Questions 1–40)

1. Select all columns from the employees table.
2. Select only first_name, last_name and salary from employees.
3. List all unique job titles.
4. Find all employees with salary greater than 100000.
5. Find employees with salary between 60000 and 90000.
6. Find employees whose status is 'Active'.
7. Find employees whose status is not 'Terminated'.
8. Find employees hired after '2020-01-01'.
9. Find employees hired in the year 2019.
10. Find employees whose first name starts with 'J'.
11. Find employees whose last name ends with 'son'.
12. Find employees whose email contains 'emp10'.
13. Find employees with NULL phone numbers.
14. Find employees who have no manager (manager_id IS NULL).
15. Find employees in department_id 1 or 2.
16. Find employees in departments 1, 3 and 5 using IN.
17. Find employees not in departments 4 and 6.
18. List the 10 highest paid employees.
19. List the 5 lowest paid active employees.
20. Find employees whose salary is higher than the average salary (use subquery later if needed).
21. Select distinct cities from customers.
22. Find customers from the state 'CA'.
23. Find customers with customer_segment = 'Platinum'.
24. Find inactive customers (is_active = false).
25. Find customers who signed up after '2022-01-01'.
26. Find products with stock_quantity less than 20.
27. Find discontinued products.
28. Find products with unit_price > 100.
29. Find products supplied by 'SupplierA'.
30. Find orders with status 'Delivered'.
31. Find orders with status 'Pending' or 'Cancelled'.
32. Find orders placed in 2023.
33. Find orders with shipping_cost = 0.
34. Find orders paid by 'PayPal'.
35. Find order items with discount greater than 0.1.
36. Find order items with quantity >= 3.
37. List all project names and their status.
38. Find projects with budget over 150000.
39. Find projects that are 'In Progress'.
40. Find employees with job_title containing 'Engineer' or 'Analyst'.

---

## 2. JOINs (Questions 41–90)

41. List employee full name and their department name.
42. List employee name, department name and location.
43. List all departments and the employees in them (include departments with no employees).
44. List all employees and their department (include employees with no department if any).
45. Find employees who work in 'Engineering'.
46. Find employees who work in 'Sales' or 'Marketing'.
47. List each employee with their manager’s full name (self-join).
48. List employees who have no manager.
49. List managers and how many people report directly to them.
50. Find the manager of employee_id 1010.
51. List orders with customer first_name and last_name.
52. List orders with customer name and city.
53. List all customers and their orders (include customers with no orders).
54. Find customers who have never placed an order.
55. List order_id, product_name, quantity and unit_price.
56. List complete order details: customer name, order_date, product_name, quantity, line total.
57. Calculate line total (quantity * unit_price * (1 - discount)) for every order item.
58. List products with their category name.
59. Find all products in the 'Electronics' category.
60. List orders that contain at least one product from 'Clothing'.
61. List employees and the projects they are assigned to.
62. List project name and the names of employees working on it.
63. Find employees who are not assigned to any project.
64. Find projects that have no employees assigned.
65. List employee name, project name, role and hours_worked.
66. Find employees who work as 'Lead' on any project.
67. Join employees → departments → and show department budget.
68. List customers, their total number of orders and total amount spent (join + later aggregate).
69. Find the top 10 customers by number of orders.
70. List every order item with product name, category name and customer name.
71. Find orders shipped to customers in 'New York' or 'Los Angeles'.
72. List employees in the same department as employee_id 1005.
73. Find pairs of employees who share the same manager.
74. List products that have never been ordered.
75. List categories that have no products.
76. Show employee name, manager name and department name in one result.
77. Find all 'Senior Engineer' employees and their department location.
78. List orders placed by 'Gold' or 'Platinum' customers.
79. Find the products ordered by customer_id 5010.
80. List the full hierarchy: department → employee → project.
81. Find employees who work on projects with budget > 200000.
82. List customers who ordered products from more than one category.
83. Find orders that include both an Electronics and a Clothing product.
84. List employees and the total hours they have worked across all projects.
85. Find the project with the most employees assigned.
86. List each department and the highest paid employee in it.
87. Find customers whose first order was in 2022.
88. List products and how many times they have been ordered.
89. Find employees who manage other employees and also work on projects.
90. Write a query that joins all major tables and returns a sales report row.

---

## 3. GROUP BY & Aggregations (Questions 91–130)

91. Count the total number of employees.
92. Count employees per department.
93. Calculate average salary per department.
94. Calculate min, max and average salary overall.
95. Find the total salary expense per department.
96. Count employees by status.
97. Count employees by job_title.
98. Find departments with more than 15 employees.
99. Find the department with the highest average salary.
100. Calculate average salary by job_title and department.
101. Count customers per state.
102. Count customers per customer_segment.
103. Find the number of active vs inactive customers.
104. Count orders per status.
105. Count orders per year.
106. Count orders per month (year-month).
107. Calculate total shipping cost per year.
108. Find the average shipping cost by payment_method.
109. Calculate total revenue (sum of quantity * unit_price * (1-discount)).
110. Calculate revenue per product.
111. Calculate revenue per category.
112. Calculate revenue per customer.
113. Find the top 10 products by revenue.
114. Find the top 10 customers by revenue.
115. Calculate average order value.
116. Find customers with more than 5 orders.
117. Find products ordered more than 50 times.
118. Count the number of items per order.
119. Find orders that contain more than 3 different products.
120. Calculate total hours_worked per project.
121. Calculate total hours_worked per employee.
122. Find projects with total hours_worked > 1000.
123. Average hours_allocated vs hours_worked per project.
124. Count employees per project.
125. Find the project with the highest total hours.
126. Group employees by year of hire and count them.
127. Calculate average salary by year of hire.
128. Find the total budget of all 'In Progress' projects.
129. Count discontinued vs active products.
130. Calculate total stock value (stock_quantity * cost) per category.

---

## 4. Date & Text Functions (Questions 131–165)

131. Extract the year from hire_date for all employees.
132. Extract month and year from order_date.
133. Calculate the number of years each employee has been with the company (tenure).
134. Find employees with tenure greater than 5 years.
135. Calculate the number of days between order_date and ship_date (shipping delay).
136. Find orders that took more than 5 days to ship.
137. Find orders placed on a weekend (if your SQL supports it).
138. Find employees hired in the last 3 years from today.
139. Find customers who signed up in the same month and year.
140. Format hire_date as 'DD-Mon-YYYY'.
141. Concatenate first_name and last_name as full_name.
142. Create email-style name: lower(first_name) || '.' || lower(last_name).
143. Convert all product names to uppercase.
144. Convert all customer cities to lowercase.
145. Find product names that contain the word 'Set'.
146. Find product names that start with 'Wireless' or 'Smart'.
147. Find customers whose last name is longer than 8 characters.
148. Trim any possible spaces from names (practice with TRIM).
149. Extract the domain from email addresses (everything after @).
150. Find employees whose phone number starts with '555'.
151. Replace 'emp' with 'staff' in the email column (for display only).
152. Find the length of every product_name.
153. Pad employee_id with leading zeros to 6 digits.
154. Find orders placed between two specific dates.
155. Find the first and last order date for each customer.
156. Calculate the age of each project in days (end_date - start_date).
157. Find projects that lasted more than 200 days.
158. Extract the quarter from order_date.
159. Count orders per quarter.
160. Find employees hired on the same day of the year (any year).
161. Create a full address-like string from city and state.
162. Find customers with email ending in '.com'.
163. Use CASE to classify salary into 'Low', 'Medium', 'High'.
164. Use CASE to classify shipping delay into 'Fast', 'Normal', 'Slow'.
165. Create a descriptive label for each order status using CASE.

---

## 5. Set Operators (Questions 166–185)

166. Use UNION to combine current customers and archived customers (all columns).
167. Use UNION ALL and observe the difference in row count.
168. Find customer_ids that exist in both customers and archived_customers (INTERSECT).
169. Find customer_ids that exist only in customers (EXCEPT / MINUS).
170. Find customer_ids that exist only in archived_customers.
171. Combine first_name + last_name from employees and customers into one list of people.
172. Find names that appear in both employees and customers.
173. Find job titles that are also used as project roles (if any overlap).
174. List all unique cities from customers and locations from departments.
175. Find department locations that are also customer cities.
176. Use UNION to create a single list of all “people” (employees + customers) with a type column.
177. Find products that have the same name pattern as project names (creative).
178. Combine active employees and active customers into one result set with a source label.
179. Find states that have both customers and a department location.
180. Create a set of all email addresses from employees and customers (UNION).
181. Find emails that appear in both tables (INTERSECT).
182. List all project statuses and order statuses in one column (UNION).
183. Find employees who are not in any project and customers who have no orders (combine with UNION).
184. Use EXCEPT to find departments that currently have zero employees.
185. Create a comprehensive “all parties” list: employees, customers, and archived customers.

---

## 6. Data Inspection & Cleaning (Questions 186–210)

186. Count how many employees have NULL phone.
187. Count how many employees have NULL manager_id.
188. Count how many customers have NULL email.
189. Count how many orders have NULL ship_date.
190. Find all rows with any NULL values in employees.
191. Check for duplicate emails in customers.
192. Check for duplicate first_name + last_name combinations in employees.
193. Find possible outlier salaries (very high or very low).
194. Find products where cost >= unit_price (data quality issue).
195. Find orders where ship_date < order_date (impossible).
196. Find order items with quantity = 0 or negative (if any).
197. Find customers with invalid-looking phone numbers.
198. List all distinct status values in employees and orders to check consistency.
199. Find employees whose department_id does not exist in departments (orphans).
200. Find order_items whose product_id does not exist in products.
201. Find order_items whose order_id does not exist in orders.
202. Check if any manager_id points to a non-existent employee.
203. Find customers with the same email as an employee.
204. Summarize missing data percentage for key columns.
205. Find the most common city and state combinations.
206. Detect possible inconsistent city/state pairs.
207. Find products with stock_quantity = 0 that are not discontinued.
208. Find employees with salary = 0 or NULL.
209. List the top 5 most frequent last names.
210. Create a data quality report showing null counts per column for a table.

---

## 7. Subqueries & CTEs (Questions 211–245)

211. Find employees who earn more than the average salary.
212. Find employees who earn more than the average salary of their own department.
213. Find the department with the highest total salary expense.
214. Find customers who have placed more orders than the average customer.
215. Find products that have higher than average unit_price.
216. Find orders whose total value is above the overall average order value.
217. Find employees who are managers (appear in manager_id column).
218. Find employees who are not managers.
219. Find the highest paid employee in each department (using subquery or window).
220. Find customers who ordered the most expensive product.
221. Find employees hired before their manager was hired (complex).
222. Using a CTE, calculate revenue per order and then find the top 20 orders.
223. Using a CTE, rank customers by total spend and select the top 10%.
224. Find products that have never been ordered (using NOT IN or NOT EXISTS).
225. Find customers who have ordered every product in a specific category (advanced).
226. Write a CTE that calculates monthly revenue and then computes month-over-month growth.
227. Find employees who work on more than 2 projects.
228. Find projects that have more employees than the average project.
229. Using a CTE, list each customer with their first and last order date.
230. Find the longest running project using a subquery.
231. Find departments where the average salary is higher than the company average.
232. Using multiple CTEs, create a sales summary by category and by month.
233. Find order items that have the maximum discount given.
234. Find the employee with the highest total hours_worked across projects.
235. Write a query using EXISTS to find customers who have at least one delivered order.
236. Write a query using NOT EXISTS to find products never ordered.
237. Find pairs of products that appear together in the same order more than once.
238. Using a CTE, calculate the running total of revenue by date.
239. Find the second highest salary in the company.
240. Find the second highest salary in each department.
241. List employees who earn more than all employees in department 4.
242. Find customers whose total spend is greater than any single order value of customer 5010.
243. Using a recursive CTE (if supported), show the employee → manager hierarchy.
244. Create a CTE for active high-value customers and join it to recent orders.
245. Write a multi-CTE query that produces a full departmental cost vs project budget report.

---

## 8. Window Functions (Questions 246–275)

246. Rank employees by salary within the whole company.
247. Rank employees by salary within each department (PARTITION BY).
248. Give a dense rank of employees by salary per department.
249. Assign row numbers to employees ordered by hire_date.
250. Calculate the running total of salaries ordered by employee_id.
251. Calculate the cumulative revenue by order_date.
252. Show each employee’s salary and the average salary of their department (using AVG() OVER).
253. Show each employee’s salary and the difference from the department average.
254. Find the top 3 highest paid employees in each department (using RANK or ROW_NUMBER).
255. Calculate the moving average of monthly revenue (3-month).
256. Show lag and lead salary for employees ordered by salary.
257. For each order, show the previous order date of the same customer (LAG).
258. Calculate the time between consecutive orders for each customer.
259. Rank products by revenue within each category.
260. Show the percentage of total revenue that each product contributes.
261. Show the percentage of department salary expense that each employee represents.
262. Divide employees into 4 salary quartiles (NTILE).
263. Divide customers into 5 groups by total spend.
264. For each employee, show the highest salary in their department (MAX OVER).
265. For each product, show the most expensive product in its category.
266. Calculate first_value and last_value of salary within department ordered by hire_date.
267. Show the rank of each project by total hours_worked.
268. Calculate a running count of orders per customer ordered by order_date.
269. Find employees whose salary is in the top 10% of the company.
270. Compare each month’s revenue to the previous month using LAG.
271. Show the difference in hours_worked vs hours_allocated for every assignment and rank them.
272. Create a dense ranking of customers by number of orders and by total spend.
273. For each order item, show the average unit_price of products in the same category.
274. Calculate the cumulative distribution of salaries (CUME_DIST).
275. Use WINDOW clause to define a reusable window for salary rankings.

---

## 9. Statistical Analysis (Questions 276–295)

276. Calculate mean, median (approximate), min, max and standard deviation of salary.
277. Calculate the statistical summary of unit_price and cost.
278. Calculate average order value and its standard deviation.
279. Find the correlation-like relationship: do higher paid employees work more hours on projects?
280. Calculate the variance of shipping_cost.
281. Find the 25th, 50th and 75th percentile of salary (PERCENTILE_CONT or APPROX).
282. Calculate the interquartile range (IQR) of salaries.
283. Find outlier employees using a simple 1.5 * IQR rule.
284. Calculate the average discount given and its distribution.
285. Find the mode (most frequent) of customer_segment and order status.
286. Calculate the average number of items per order and its spread.
287. Compute total revenue, average revenue per order and per customer.
288. Calculate year-over-year growth rate of revenue.
289. Calculate the proportion of orders that are cancelled or returned.
290. Find the average tenure of employees per department and overall.
291. Calculate the average project budget utilization (hours_worked / hours_allocated).
292. Statistical summary of stock_quantity by category.
293. Calculate the percentage of active vs terminated employees.
294. Find the average revenue contribution of Platinum customers vs Bronze.
295. Create a comprehensive statistical report for salaries, orders and project hours.

---

## 10. Data Modification (DML) Practice (Questions 296–300)

**Warning:** Practice these inside a transaction and ROLLBACK unless you really want to change the data.

296. Give a 5% salary increase to all employees in the Engineering department.
297. Set the status of employees who have been terminated to 'Archived' (or soft-delete).
298. Insert a new employee into the employees table (choose reasonable values).
299. Update all NULL phone numbers to 'Not Provided'.
300. Delete (or archive) all orders with status 'Cancelled' that are older than 2 years.  
    (Prefer moving them to an archive table rather than hard delete.)

---

