create database farmers_market;
use farmers_market;

CREATE TABLE `admin` (
  `id` int NOT NULL AUTO_INCREMENT,
  `username` varchar(50) NOT NULL,
  `password` varchar(255) NOT NULL,
  `email` varchar(100) NOT NULL,
  `is_admin` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`),
  UNIQUE KEY `email` (`email`)
);

CREATE TABLE `customers` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) DEFAULT NULL,
  `phone` varchar(15) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `address` varchar(255) DEFAULT NULL,
  `password` varchar(255) DEFAULT NULL,
  `profile_pic` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `latitude` double DEFAULT NULL,
  `longitude` double DEFAULT NULL,
  `location` varchar(255) DEFAULT NULL,
  `default_address` text,
  PRIMARY KEY (`id`),
  UNIQUE KEY `phone` (`phone`),
  UNIQUE KEY `email` (`email`)
); 


CREATE TABLE `employees` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `phone` varchar(15) NOT NULL,
  `house_address` text NOT NULL,
  `location` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`)
); 

CREATE TABLE `farmers` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `age` int DEFAULT NULL,
  `phone` varchar(15) NOT NULL,
  `address` text,
  `location` varchar(255) DEFAULT NULL,
  `aadhar` varchar(20) DEFAULT NULL,
  `password` varchar(255) DEFAULT NULL,
  `profile_pic` varchar(255) DEFAULT 'default.jpg',
  `latitude` double DEFAULT NULL,
  `longitude` double DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `phone` (`phone`)
); 

CREATE TABLE `crops` (
  `id` int NOT NULL AUTO_INCREMENT,
  `farmer_id` int NOT NULL,
  `crop_name` varchar(100) NOT NULL,
  `crop_type` enum('Vegetable','Fruit','Food Grains') NOT NULL,
  `quantity` int NOT NULL,
  `price_per_kg` decimal(10,2) DEFAULT NULL,
  `offer` varchar(255) DEFAULT NULL,
  `offer_details` text,
  `image` varchar(255) DEFAULT NULL,
  `sold_quantity` int DEFAULT '0',
  `customer_count` int DEFAULT '0',
  `num_customers` int DEFAULT '0',
  `location` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `farmer_id` (`farmer_id`),
  CONSTRAINT `crops_ibfk_1` FOREIGN KEY (`farmer_id`) REFERENCES `farmers` (`id`)
);

CREATE TABLE `recipes` (
  `id` int NOT NULL AUTO_INCREMENT,
  `recipe_name` varchar(255) NOT NULL,
  `image` varchar(255) NOT NULL,
  `ingredients` text NOT NULL,
  `masala_cost` decimal(10,2) NOT NULL,
  `cooking_instructions` text NOT NULL,
  `created_by` int NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `main_items` text,
  `recipe_id` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `recipe_id` (`recipe_id`)
) ;

CREATE TABLE `cart` (
  `id` int NOT NULL AUTO_INCREMENT,
  `customer_id` int NOT NULL,
  `crop_id` int NOT NULL,
  `quantity` int NOT NULL,
  `price` decimal(10,2) NOT NULL,
  `recipe_id` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `customer_id` (`customer_id`),
  KEY `cart_ibfk_2` (`crop_id`),
  KEY `fk_recipe` (`recipe_id`),
  CONSTRAINT `cart_ibfk_1` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`id`),
  CONSTRAINT `cart_ibfk_2` FOREIGN KEY (`crop_id`) REFERENCES `crops` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_cart_crop` FOREIGN KEY (`crop_id`) REFERENCES `crops` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_recipe` FOREIGN KEY (`recipe_id`) REFERENCES `recipes` (`recipe_id`)
);

CREATE TABLE `cooked_foods` (
  `id` int NOT NULL AUTO_INCREMENT,
  `employee_id` int NOT NULL,
  `food_name` varchar(255) NOT NULL,
  `image` varchar(255) NOT NULL,
  `main_items` text NOT NULL,
  `cooked_time` datetime NOT NULL,
  `price` decimal(10,2) NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `employee_id` (`employee_id`),
  CONSTRAINT `cooked_foods_ibfk_1` FOREIGN KEY (`employee_id`) REFERENCES `employees` (`id`)
);

CREATE TABLE `crops` (
  `id` int NOT NULL AUTO_INCREMENT,
  `farmer_id` int NOT NULL,
  `crop_name` varchar(100) NOT NULL,
  `crop_type` enum('Vegetable','Fruit','Food Grains') NOT NULL,
  `quantity` int NOT NULL,
  `price_per_kg` decimal(10,2) DEFAULT NULL,
  `offer` varchar(255) DEFAULT NULL,
  `offer_details` text,
  `image` varchar(255) DEFAULT NULL,
  `sold_quantity` int DEFAULT '0',
  `customer_count` int DEFAULT '0',
  `num_customers` int DEFAULT '0',
  `location` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `farmer_id` (`farmer_id`),
  CONSTRAINT `crops_ibfk_1` FOREIGN KEY (`farmer_id`) REFERENCES `farmers` (`id`)
);

CREATE TABLE `customer_orders` (
  `id` int NOT NULL AUTO_INCREMENT,
  `food_id` int NOT NULL,
  `customer_id` int NOT NULL,
  `quantity` int NOT NULL,
  `ordered_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `status` enum('pending','ready to dispatch') DEFAULT 'pending',
  `employee_id` int NOT NULL,
  `address` varchar(255) NOT NULL,
  `total_cost` decimal(10,2) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_employee` (`employee_id`),
  KEY `fk_food` (`food_id`),
  KEY `fk_customer` (`customer_id`),
  CONSTRAINT `customer_orders_ibfk_1` FOREIGN KEY (`food_id`) REFERENCES `cooked_foods` (`id`),
  CONSTRAINT `customer_orders_ibfk_2` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`id`),
  CONSTRAINT `fk_customer` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_employee` FOREIGN KEY (`employee_id`) REFERENCES `employees` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_food` FOREIGN KEY (`food_id`) REFERENCES `cooked_foods` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
);




CREATE TABLE `food_cart` (
  `id` int NOT NULL AUTO_INCREMENT,
  `customer_id` int NOT NULL,
  `food_id` int NOT NULL,
  `quantity` int DEFAULT '1',
  `added_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `customer_id` (`customer_id`),
  KEY `food_id` (`food_id`),
  CONSTRAINT `food_cart_ibfk_1` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`id`),
  CONSTRAINT `food_cart_ibfk_2` FOREIGN KEY (`food_id`) REFERENCES `cooked_foods` (`id`)
);

CREATE TABLE `locations` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `latitude` decimal(9,6) NOT NULL,
  `longitude` decimal(9,6) NOT NULL,
  `type` enum('farmer','customer') NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `locations_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `farmers` (`id`) ON DELETE CASCADE
) ;

CREATE TABLE `orders` (
  `id` int NOT NULL AUTO_INCREMENT,
  `customer_id` int NOT NULL,
  `address` text NOT NULL,
  `total_cost` decimal(10,2) NOT NULL,
  `status` varchar(50) DEFAULT 'Placed',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `customer_id` (`customer_id`),
  CONSTRAINT `orders_ibfk_1` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`id`)
) ;

CREATE TABLE `order_items` (
  `id` int NOT NULL AUTO_INCREMENT,
  `order_id` int NOT NULL,
  `food_id` int NOT NULL,
  `quantity` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `order_id` (`order_id`),
  KEY `food_id` (`food_id`),
  CONSTRAINT `order_items_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`),
  CONSTRAINT `order_items_ibfk_2` FOREIGN KEY (`food_id`) REFERENCES `cooked_foods` (`id`)
); 


CREATE TABLE `payment_transactions` (
  `id` int NOT NULL AUTO_INCREMENT,
  `customer_id` int NOT NULL,
  `txnid` varchar(255) NOT NULL,
  `amount` decimal(10,2) NOT NULL,
  `payment_status` varchar(50) NOT NULL DEFAULT 'Pending',
  `payment_date` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `customer_id` (`customer_id`),
  CONSTRAINT `payment_transactions_ibfk_1` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`id`)
) ;



CREATE TABLE `recipe_cart` (
  `id` int NOT NULL AUTO_INCREMENT,
  `customer_id` int NOT NULL,
  `recipe_id` int NOT NULL,
  `recipe_name` varchar(255) NOT NULL,
  `image` varchar(255) NOT NULL,
  `masala_cost` decimal(10,2) NOT NULL,
  `quantity` int DEFAULT '1',
  `total_cost` decimal(10,2) GENERATED ALWAYS AS ((`quantity` * `masala_cost`)) STORED,
  PRIMARY KEY (`id`),
  KEY `customer_id` (`customer_id`),
  KEY `recipe_id` (`recipe_id`),
  CONSTRAINT `recipe_cart_ibfk_1` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`id`),
  CONSTRAINT `recipe_cart_ibfk_2` FOREIGN KEY (`recipe_id`) REFERENCES `recipes` (`id`)
) ;



CREATE TABLE `temporary_addresses` (
  `id` int NOT NULL AUTO_INCREMENT,
  `customer_id` int NOT NULL,
  `address` text NOT NULL,
  `added_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `customer_id` (`customer_id`),
  CONSTRAINT `temporary_addresses_ibfk_1` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`id`) ON DELETE CASCADE
) ;