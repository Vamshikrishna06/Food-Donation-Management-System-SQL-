-- ========================================================
-- 1. Create Database
-- ========================================================
CREATE DATABASE IF NOT EXISTS fooddonationsystem;
USE fooddonationsystem;

-- ========================================================
-- 2. Create Tables
-- ========================================================

CREATE TABLE Donor (
    donor_id INT PRIMARY KEY AUTO_INCREMENT,       
    donor_name VARCHAR(100) NOT NULL,             
    donor_type VARCHAR(50),                        
    contact_no VARCHAR(15),                        
    address VARCHAR(255)                            
);

CREATE TABLE NGO (
    ngo_id INT PRIMARY KEY AUTO_INCREMENT,        
    ngo_name VARCHAR(100) NOT NULL,               
    contact_no VARCHAR(15),                        
    address VARCHAR(255)                            
);

CREATE TABLE Food_Donation (
    donation_id INT PRIMARY KEY AUTO_INCREMENT,   
    donor_id INT,                                 
    food_type VARCHAR(100),                        
    quantity INT,                                  
    expiry_time DATETIME,                          
    donation_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(20) DEFAULT 'Available',       
    FOREIGN KEY (donor_id) REFERENCES Donor(donor_id)
);

CREATE TABLE Donation_Request (
    request_id INT PRIMARY KEY AUTO_INCREMENT,    
    donation_id INT,                              
    ngo_id INT,                                   
    request_date DATETIME DEFAULT CURRENT_TIMESTAMP, 
    status VARCHAR(20) DEFAULT 'Pending',         
    FOREIGN KEY (donation_id) REFERENCES Food_Donation(donation_id),
    FOREIGN KEY (ngo_id) REFERENCES NGO(ngo_id)
);

CREATE TABLE Admin_Notifications (
    notification_id INT PRIMARY KEY AUTO_INCREMENT, 
    table_name VARCHAR(50),                         
    action_type VARCHAR(50),                        
    details VARCHAR(255),                           
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP   
);

-- ========================================================
-- 3. Triggers
-- ========================================================

DELIMITER //

-- Trigger: Notify admin when a new donor is added
CREATE TRIGGER notify_donor_insert
AFTER INSERT ON Donor
FOR EACH ROW
BEGIN
    INSERT INTO Admin_Notifications (table_name, action_type, details)
    VALUES ('Donor', 'INSERT', CONCAT('New Donor Added: ', NEW.donor_name));
END;
//

-- Trigger: Notify admin when a new NGO is added
CREATE TRIGGER notify_ngo_insert
AFTER INSERT ON NGO
FOR EACH ROW
BEGIN
    INSERT INTO Admin_Notifications (table_name, action_type, details)
    VALUES ('NGO', 'INSERT', CONCAT('New NGO Added: ', NEW.ngo_name));
END;
//

-- Trigger: Notify admin when a new food donation is added
CREATE TRIGGER notify_food_donation_insert
AFTER INSERT ON Food_Donation
FOR EACH ROW
BEGIN
    INSERT INTO Admin_Notifications (table_name, action_type, details)
    VALUES ('Food_Donation', 'INSERT', CONCAT('Food Donation Added: ', NEW.food_type, ' (Qty: ', NEW.quantity, ')'));
END;
//

-- Trigger: Update Food_Donation status to 'Complete' when request is marked complete
CREATE TRIGGER update_food_status
AFTER UPDATE ON Donation_Request
FOR EACH ROW
BEGIN
    IF NEW.status = 'Complete' THEN
        UPDATE Food_Donation
        SET status = 'Complete'
        WHERE donation_id = NEW.donation_id;

        INSERT INTO Admin_Notifications (table_name, action_type, details)
        VALUES ('Food_Donation', 'UPDATE', CONCAT('Food Donation ID ', NEW.donation_id, ' marked as Complete'));
    END IF;
END;
//

DELIMITER ;

-- ========================================================
-- 4. Sample Data (50-60 entries)
-- ========================================================

-- 4.1 Donors
INSERT INTO Donor (donor_name, donor_type, contact_no, address) VALUES
('Vamshi', 'Restaurant', '9757297205', 'Area-1 Hyderabad'),
('Ramesh', 'Household', '9192693221', 'Area-2 Hyderabad'),
('Anjali', 'Restaurant', '9988776655', 'Area-3 Hyderabad'),
('Suresh', 'Household', '8877665544', 'Area-4 Hyderabad'),
('Priya', 'Restaurant', '9123456789', 'Area-5 Hyderabad'),
('Rahul', 'Household', '9988123456', 'Area-6 Hyderabad'),
('Nithin', 'Restaurant', '9876543210', 'Area-7 Hyderabad'),
('Meena', 'Household', '9654321987', 'Area-8 Hyderabad'),
('Kiran', 'Restaurant', '9765432109', 'Area-9 Hyderabad'),
('Divya', 'Household', '9876123450', 'Area-10 Hyderabad'),
('Ajay', 'Restaurant', '9123987654', 'Area-11 Hyderabad'),
('Sneha', 'Household', '9876098765', 'Area-12 Hyderabad'),
('Vikram', 'Restaurant', '9988001122', 'Area-13 Hyderabad'),
('Ritu', 'Household', '9876540000', 'Area-14 Hyderabad'),
('Naveen', 'Restaurant', '9766554433', 'Area-15 Hyderabad'),
('Shreya', 'Household', '9876012345', 'Area-16 Hyderabad'),
('Manish', 'Restaurant', '9988771122', 'Area-17 Hyderabad'),
('Swathi', 'Household', '9876009876', 'Area-18 Hyderabad'),
('Arjun', 'Restaurant', '9766991122', 'Area-19 Hyderabad'),
('Pooja', 'Household', '9876543211', 'Area-20 Hyderabad');

-- 4.2 NGOs
INSERT INTO NGO (ngo_name, contact_no, address) VALUES
('Helping Hands', '9988776655', 'Hyderabad'),
('Food for All', '8877665544', 'Hyderabad'),
('Care & Share', '9123456789', 'Hyderabad'),
('Smile Foundation', '9988123456', 'Hyderabad'),
('Feed India', '9876543210', 'Hyderabad'),
('Support Society', '9654321987', 'Hyderabad'),
('Hope Trust', '9765432109', 'Hyderabad'),
('Samaritan NGO', '9876123450', 'Hyderabad'),
('Kindness Foundation', '9123987654', 'Hyderabad'),
('Joyful Hearts', '9876098765', 'Hyderabad');

-- 4.3 Food Donations
INSERT INTO Food_Donation (donor_id, food_type, quantity, expiry_time) VALUES
(1, 'Rice', 50, '2025-09-30 23:59:59'),
(2, 'Vegetables', 30, '2025-09-20 20:00:00'),
(3, 'Pulses', 40, '2025-09-25 22:00:00'),
(4, 'Bread', 25, '2025-09-19 18:00:00'),
(5, 'Milk', 20, '2025-09-18 12:00:00'),
(6, 'Fruits', 35, '2025-09-21 15:00:00'),
(7, 'Eggs', 60, '2025-09-23 10:00:00'),
(8, 'Cookies', 45, '2025-09-22 20:00:00'),
(9, 'Cereal', 50, '2025-09-24 08:00:00'),
(10, 'Vegetable Oil', 30, '2025-09-28 12:00:00'),
(11, 'Sugar', 40, '2025-09-27 09:00:00'),
(12, 'Salt', 25, '2025-09-29 19:00:00'),
(13, 'Spices', 35, '2025-09-30 17:00:00'),
(14, 'Pasta', 45, '2025-09-26 14:00:00'),
(15, 'Cheese', 20, '2025-09-25 18:00:00'),
(16, 'Butter', 30, '2025-09-23 12:00:00'),
(17, 'Tomatoes', 40, '2025-09-22 11:00:00'),
(18, 'Potatoes', 50, '2025-09-21 10:00:00'),
(19, 'Onions', 35, '2025-09-20 09:00:00'),
(20, 'Carrots', 25, '2025-09-19 08:00:00');

-- 4.4 Donation Requests
INSERT INTO Donation_Request (donation_id, ngo_id) VALUES
(1,1),(2,2),(3,3),(4,4),(5,5),
(6,6),(7,7),(8,8),(9,9),(10,10),
(11,1),(12,2),(13,3),(14,4),(15,5),
(16,6),(17,7),(18,8),(19,9),(20,10);

-- ========================================================
-- 5. Manual Expiry Handling
-- ========================================================

-- Mark expired food donations manually
UPDATE Food_Donation
SET status = 'Expired'
WHERE status = 'Available' AND expiry_time <= NOW();

-- Log expired donations in Admin_Notifications
INSERT INTO Admin_Notifications (table_name, action_type, details)
SELECT 'Food_Donation', 'UPDATE', CONCAT('Food Donation ID ', donation_id, ' has expired')
FROM Food_Donation
WHERE status = 'Expired' AND expiry_time <= NOW();

-- ========================================================
-- 6. Check Tables & Notifications
-- ========================================================

SELECT * FROM Admin_Notifications;
SELECT * FROM Donor;
SELECT * FROM NGO;
SELECT * FROM Food_Donation;
SELECT * FROM Donation_Request;

-- ========================================================
-- 7. Test Status Update
-- ========================================================

-- Mark request_id 1 as complete and verify triggers
UPDATE Donation_Request
SET status = 'Complete'
WHERE request_id = 1;

SELECT * FROM Food_Donation;
SELECT * FROM Admin_Notifications;


-- ========================================================
-- SQL Queries for Testing / Practice
-- ========================================================

-- -----------------------------
-- 1. Easy Queries
-- -----------------------------

-- 1.1 Select all donors
SELECT * FROM Donor;

-- 1.2 Select all NGOs
SELECT * FROM NGO;

-- 1.3 Select all food donations that are still available
SELECT * FROM Food_Donation
WHERE status = 'Available';

-- 1.4 Select all donation requests that are pending
SELECT * FROM Donation_Request
WHERE status = 'Pending';

-- 1.5 Count total number of donors
SELECT COUNT(*) AS total_donors FROM Donor;

-- 1.6 Count total number of NGOs
SELECT COUNT(*) AS total_ngos FROM NGO;

-- -----------------------------
-- 2. Medium Queries
-- -----------------------------

-- 2.1 List all donations along with donor name
SELECT fd.donation_id, fd.food_type, fd.quantity, fd.status, d.donor_name
FROM Food_Donation fd
JOIN Donor d ON fd.donor_id = d.donor_id;

-- 2.2 List all donation requests with NGO and donation details
SELECT dr.request_id, n.ngo_name, fd.food_type, fd.quantity, dr.status AS request_status
FROM Donation_Request dr
JOIN NGO n ON dr.ngo_id = n.ngo_id
JOIN Food_Donation fd ON dr.donation_id = fd.donation_id;

-- 2.3 Total quantity of food donated by each donor
SELECT d.donor_name, SUM(fd.quantity) AS total_quantity
FROM Food_Donation fd
JOIN Donor d ON fd.donor_id = d.donor_id
GROUP BY d.donor_name
ORDER BY total_quantity DESC;

-- 2.4 Total pending requests for each NGO
SELECT n.ngo_name, COUNT(dr.request_id) AS pending_requests
FROM Donation_Request dr
JOIN NGO n ON dr.ngo_id = n.ngo_id
WHERE dr.status = 'Pending'
GROUP BY n.ngo_name;

-- 2.5 List all expired donations
SELECT * FROM Food_Donation
WHERE status = 'Expired';

-- 2.6 List donations that will expire in the next 3 days
SELECT * FROM Food_Donation
WHERE expiry_time BETWEEN NOW() AND DATE_ADD(NOW(), INTERVAL 3 DAY);

-- 2.7 Count donations by status (Available, Complete, Expired)
SELECT status, COUNT(*) AS count_by_status
FROM Food_Donation
GROUP BY status;

-- 2.8 Find donors who have donated more than 40 units in total
SELECT d.donor_name, SUM(fd.quantity) AS total_quantity
FROM Food_Donation fd
JOIN Donor d ON fd.donor_id = d.donor_id
GROUP BY d.donor_name
HAVING total_quantity > 40;

-- 2.9 Find NGOs with most completed requests
SELECT n.ngo_name, COUNT(dr.request_id) AS completed_requests
FROM Donation_Request dr
JOIN NGO n ON dr.ngo_id = n.ngo_id
WHERE dr.status = 'Complete'
GROUP BY n.ngo_name
ORDER BY completed_requests DESC;

-- -----------------------------
-- 3. Hard Query
-- -----------------------------

-- 3.1 Find the top 3 donors who donated the most food of each type along with total quantity
SELECT food_type, donor_name, total_quantity
FROM (
    SELECT fd.food_type, d.donor_name, SUM(fd.quantity) AS total_quantity,
           RANK() OVER (PARTITION BY fd.food_type ORDER BY SUM(fd.quantity) DESC) AS rnk
    FROM Food_Donation fd
    JOIN Donor d ON fd.donor_id = d.donor_id
    GROUP BY fd.food_type, d.donor_name
) AS ranked_donors
WHERE rnk <= 3
ORDER BY  total_quantity DESC;

