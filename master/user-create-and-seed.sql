-- MySQL script to create a generic user table and seed it with 100+ random records

-- Drop table if it exists
DROP TABLE IF EXISTS `users`;

-- Create users table
CREATE TABLE `users` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `username` VARCHAR(50) NOT NULL ,
  `email` VARCHAR(100) NOT NULL ,
  `first_name` VARCHAR(50) NOT NULL,
  `last_name` VARCHAR(50) NOT NULL,
  `password_hash` VARCHAR(255) NOT NULL,
  `date_of_birth` DATE,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `last_login` TIMESTAMP NULL,
  `is_active` BOOLEAN DEFAULT TRUE,
  `role` ENUM('admin', 'user', 'moderator') DEFAULT 'user'
);

-- Seed data procedure
DELIMITER //
CREATE PROCEDURE seed_users()
BEGIN
  DECLARE i INT DEFAULT 1;
  DECLARE username_val VARCHAR(50);
  DECLARE email_val VARCHAR(100);
  DECLARE first_name_val VARCHAR(50);
  DECLARE last_name_val VARCHAR(50);
  DECLARE password_val VARCHAR(255);
  DECLARE dob_val DATE;
  DECLARE is_active_val BOOLEAN;
  DECLARE role_val VARCHAR(10);
  DECLARE last_login_val TIMESTAMP;
  
  -- Array of first names
  DECLARE first_names VARCHAR(1000) DEFAULT 'James,John,Robert,Michael,William,David,Richard,Joseph,Thomas,Charles,Mary,Patricia,Jennifer,Linda,Elizabeth,Barbara,Susan,Jessica,Sarah,Karen';
  
  -- Array of last names
  DECLARE last_names VARCHAR(1000) DEFAULT 'Smith,Johnson,Williams,Jones,Brown,Davis,Miller,Wilson,Moore,Taylor,Anderson,Thomas,Jackson,White,Harris,Martin,Thompson,Garcia,Martinez,Robinson';
    
  -- Insert 120 users
  WHILE i <= 120 DO
    -- Generate random values
    SET first_name_val = ELT(FLOOR(1 + RAND() * 20), 
                            SUBSTRING_INDEX(SUBSTRING_INDEX(first_names, ',', 1), ',', -1),
                            SUBSTRING_INDEX(SUBSTRING_INDEX(first_names, ',', 2), ',', -1),
                            SUBSTRING_INDEX(SUBSTRING_INDEX(first_names, ',', 3), ',', -1),
                            SUBSTRING_INDEX(SUBSTRING_INDEX(first_names, ',', 4), ',', -1),
                            SUBSTRING_INDEX(SUBSTRING_INDEX(first_names, ',', 5), ',', -1),
                            SUBSTRING_INDEX(SUBSTRING_INDEX(first_names, ',', 6), ',', -1),
                            SUBSTRING_INDEX(SUBSTRING_INDEX(first_names, ',', 7), ',', -1),
                            SUBSTRING_INDEX(SUBSTRING_INDEX(first_names, ',', 8), ',', -1),
                            SUBSTRING_INDEX(SUBSTRING_INDEX(first_names, ',', 9), ',', -1),
                            SUBSTRING_INDEX(SUBSTRING_INDEX(first_names, ',', 10), ',', -1),
                            SUBSTRING_INDEX(SUBSTRING_INDEX(first_names, ',', 11), ',', -1),
                            SUBSTRING_INDEX(SUBSTRING_INDEX(first_names, ',', 12), ',', -1),
                            SUBSTRING_INDEX(SUBSTRING_INDEX(first_names, ',', 13), ',', -1),
                            SUBSTRING_INDEX(SUBSTRING_INDEX(first_names, ',', 14), ',', -1),
                            SUBSTRING_INDEX(SUBSTRING_INDEX(first_names, ',', 15), ',', -1),
                            SUBSTRING_INDEX(SUBSTRING_INDEX(first_names, ',', 16), ',', -1),
                            SUBSTRING_INDEX(SUBSTRING_INDEX(first_names, ',', 17), ',', -1),
                            SUBSTRING_INDEX(SUBSTRING_INDEX(first_names, ',', 18), ',', -1),
                            SUBSTRING_INDEX(SUBSTRING_INDEX(first_names, ',', 19), ',', -1),
                            SUBSTRING_INDEX(SUBSTRING_INDEX(first_names, ',', 20), ',', -1));
                            
    SET last_name_val = ELT(FLOOR(1 + RAND() * 20), 
                            SUBSTRING_INDEX(SUBSTRING_INDEX(last_names, ',', 1), ',', -1),
                            SUBSTRING_INDEX(SUBSTRING_INDEX(last_names, ',', 2), ',', -1),
                            SUBSTRING_INDEX(SUBSTRING_INDEX(last_names, ',', 3), ',', -1),
                            SUBSTRING_INDEX(SUBSTRING_INDEX(last_names, ',', 4), ',', -1),
                            SUBSTRING_INDEX(SUBSTRING_INDEX(last_names, ',', 5), ',', -1),
                            SUBSTRING_INDEX(SUBSTRING_INDEX(last_names, ',', 6), ',', -1),
                            SUBSTRING_INDEX(SUBSTRING_INDEX(last_names, ',', 7), ',', -1),
                            SUBSTRING_INDEX(SUBSTRING_INDEX(last_names, ',', 8), ',', -1),
                            SUBSTRING_INDEX(SUBSTRING_INDEX(last_names, ',', 9), ',', -1),
                            SUBSTRING_INDEX(SUBSTRING_INDEX(last_names, ',', 10), ',', -1),
                            SUBSTRING_INDEX(SUBSTRING_INDEX(last_names, ',', 11), ',', -1),
                            SUBSTRING_INDEX(SUBSTRING_INDEX(last_names, ',', 12), ',', -1),
                            SUBSTRING_INDEX(SUBSTRING_INDEX(last_names, ',', 13), ',', -1),
                            SUBSTRING_INDEX(SUBSTRING_INDEX(last_names, ',', 14), ',', -1),
                            SUBSTRING_INDEX(SUBSTRING_INDEX(last_names, ',', 15), ',', -1),
                            SUBSTRING_INDEX(SUBSTRING_INDEX(last_names, ',', 16), ',', -1),
                            SUBSTRING_INDEX(SUBSTRING_INDEX(last_names, ',', 17), ',', -1),
                            SUBSTRING_INDEX(SUBSTRING_INDEX(last_names, ',', 18), ',', -1),
                            SUBSTRING_INDEX(SUBSTRING_INDEX(last_names, ',', 19), ',', -1),
                            SUBSTRING_INDEX(SUBSTRING_INDEX(last_names, ',', 20), ',', -1));
    
    -- Create a unique username based on first name, last name and a number
    SET username_val = CONCAT(LOWER(first_name_val), LOWER(LEFT(last_name_val, 1)), i);
    
    -- Create email
    SET email_val = CONCAT(LOWER(username_val), '@example.com');
    
    -- Create a password hash (in a real scenario, you would use a proper hashing function)
    SET password_val = CONCAT('$2a$12$', MD5(CONCAT(username_val, i)));
    
    -- Generate a random date of birth (between 18 and 70 years ago)
    SET dob_val = DATE_SUB(CURRENT_DATE, INTERVAL (18 + FLOOR(RAND() * 52)) YEAR);
    
    -- Random active status (mostly active)
    SET is_active_val = IF(RAND() > 0.1, TRUE, FALSE);
    
    -- Random role (mostly users, some moderators, few admins)
    SET role_val = ELT(1 + FLOOR(RAND() * 10), 
                      'user', 'user', 'user', 'user', 'user', 
                      'user', 'user', 'moderator', 'moderator', 'admin');
    
    -- Random last login time (NULL for new users, recent for active users)
    SET last_login_val = IF(
      RAND() > 0.2, 
      DATE_SUB(NOW(), INTERVAL FLOOR(RAND() * 30) DAY), 
      NULL
    );
    
    -- Insert the user
    INSERT INTO `users` (
      `username`, 
      `email`, 
      `first_name`, 
      `last_name`, 
      `password_hash`, 
      `date_of_birth`, 
      `is_active`, 
      `role`, 
      `last_login`
    ) VALUES (
      username_val,
      email_val,
      first_name_val,
      last_name_val,
      password_val,
      dob_val,
      is_active_val,
      role_val,
      last_login_val
    );
    
    SET i = i + 1;
  END WHILE;
END //
DELIMITER ;

-- Execute the stored procedure
CALL seed_users();

-- Drop the procedure (cleanup)
DROP PROCEDURE IF EXISTS seed_users;

-- Verify data
SELECT COUNT(*) AS total_users FROM users;
SELECT * FROM users LIMIT 10;