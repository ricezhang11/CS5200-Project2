# join three tables to find out customer's booking history and what category of car they booked
SELECT Customer.firstName, Customer.lastName, totalCharge, categoryType
FROM Car, Customer, Booking, Car_Category
WHERE Car.carID = Booking.carID AND Booking.customerID = Customer.customerID AND Car.carCategoryID = Car_Category.categoryID
ORDER BY Customer.customerID

# find out how many customers have booked cars with the company for more than three times using a subquery
SELECT count(*) FROM (SELECT count(*) 
FROM Customer, Booking
WHERE Customer.customerID = Booking.customerID
GROUP BY Customer.customerID
HAVING count(*) > 3)

# find out the car brands owned most by the company using group by and having clause (owns more than 50 cars in that brand)
SELECT make, count(*)  
FROM Car, Car_Make
WHERE Car.makeID = Car_Make.makeID
GROUP BY make
HAVING count(*) > 50 
ORDER BY count(*) DESC

# complex search criterion (more than one expression with logical connectors)
# The company wants to investigate their business in east coasts, so they want to look at 
# the order of popularity of the branches (based on transaction amount) in the east coast states 
# (Connecticut, Virginia, Florida, North Carolina, Massachusetts, New Jersey)
SELECT branchName, branchManager, sum(Booking.totalCharge) AS totalTransaction
FROM Booking, Rental_Branch
WHERE Booking.pickupRentalBranchID = Rental_Branch.rentalBranchID AND (Rental_Branch.state = 'Virginia' OR Rental_Branch.state = 'Connecticut' OR Rental_Branch.state = 'Florida' OR Rental_Branch.state = 'North Carolina' OR Rental_Branch.state = 'Massachusetts' OR Rental_Branch.state = 'New Jersey' )
GROUP BY Rental_Branch.rentalBranchID
ORDER BY totalTransaction DESC

# advanced query mechanism using Case When
# the company decides to award the customers with membership benefits
# Customers who have spent more than $3000 will be awarded gold membership
# Customers who have spent more than $2000 will be awarded silver membership
# Customers who have spent more than $1000 will be awarded bronze membership
SELECT firstName, lastName, sum(totalCharge) AS totalTransactionAmount,
CASE
  WHEN sum(totalCharge) > 3000 THEN 'Gold membership'
  WHEN sum(totalCharge) > 2000  THEN 'Silver membership'
  WHEN sum(totalCharge) > 1000 THEN 'Bronze membership'
  ELSE 'None'
END AS MembershipAward
FROM Customer, Booking
WHERE Customer.customerID = Booking.customerID
GROUP BY Customer.customerID
