-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Generation Time: Aug 28, 2025 at 10:36 AM
-- Server version: 8.0.30
-- PHP Version: 8.2.23

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `viraapi`
--

-- --------------------------------------------------------

--
-- Table structure for table `permissions`
--

CREATE TABLE `permissions` (
  `id` int NOT NULL,
  `name` varchar(256) DEFAULT NULL,
  `title` varchar(256) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `permissions`
--

INSERT INTO `permissions` (`id`, `name`, `title`) VALUES
(1, 'list_user', 'لیست کاربر'),
(2, 'create_user', 'ایجاد کاربر'),
(3, 'edit_user', 'ویرایش کاربر'),
(4, 'delete_user', 'حذف کاربر'),
(5, 'list_role', 'لیست نقش'),
(6, 'create_role', 'ایجاد نقش'),
(7, 'edit_role', 'ویرایش نقش'),
(8, 'delete_role', 'حذف نقش'),
(9, 'list_permission', 'لیست مجوز'),
(10, 'create_permission', 'ایجاد مجوز'),
(11, 'edit_permission', 'ویرایش مجوز'),
(12, 'delete_permission', 'حذف مجوز'),
(13, 'list_ai', 'لیست هوش مصنوعی'),
(14, 'create_ai', 'ایجاد هوش مصنوعی'),
(15, 'edit_ai', 'ویرایش هوش مصنوعی'),
(16, 'delete_ai', 'حذف هوش مصنوعی'),
(17, 'menu_user', 'منوی مدیریت کاربران'),
(18, 'menu_ai', 'منوی دستیارها'),
(19, 'archive_ai', 'بایگانی'),
(20, 'delete_archive', 'حذف بایگانی'),
(21, 'create_assistants', 'ایجاد دستیار اختصاصی'),
(22, 'edit_assistants', 'ویرایش دستیار اختصاصی'),
(23, 'list_assistants', 'لیست دستیارهای اختصاصی'),
(24, 'delete_assistants', 'حذف دستیار اختصاصی'),
(25, 'list_subscription_plan', 'لیست پلن های بسته'),
(26, 'create_subscription_plan', 'ایجاد پلن بسته'),
(27, 'edit_subscription_plan', 'ویرایش پلن بسته'),
(28, 'delete_subscription_plan', 'حذف پلن بسته'),
(29, 'list_user_subscription', 'لیست بسته های کاربر'),
(30, 'delete_user_subscription', 'انقضای بسته کاربر'),
(31, 'view_users_assistants', 'لیست دستیارهای  اختصاصی کاربر'),
(32, 'subscription_plan_buy', 'خرید بسته'),
(33, 'list_ai_users', 'لیست دستیارهای عمومی کاربر');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `permissions`
--
ALTER TABLE `permissions`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `ix_permissions_name` (`name`),
  ADD UNIQUE KEY `ix_permissions_title` (`title`),
  ADD KEY `ix_permissions_id` (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `permissions`
--
ALTER TABLE `permissions`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=34;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
