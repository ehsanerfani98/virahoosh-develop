-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Generation Time: Aug 11, 2025 at 07:35 PM
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
-- Table structure for table `ai_archives`
--

CREATE TABLE `ai_archives` (
  `id` int NOT NULL,
  `ai_model_id` int DEFAULT NULL,
  `prompt` text,
  `response` text,
  `created_at` datetime DEFAULT NULL,
  `title` varchar(255) NOT NULL,
  `type` varchar(20) DEFAULT NULL,
  `url` varchar(512) DEFAULT NULL,
  `user_id` varchar(36) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `ai_archives`
--

INSERT INTO `ai_archives` (`id`, `ai_model_id`, `prompt`, `response`, `created_at`, `title`, `type`, `url`, `user_id`) VALUES
(61, 6, 'Please explain the following topic in simple and clear terms: سلام کمکم کن. I want to understand the main points, important details, and any necessary steps or precautions related to it.', 'خطا در پاسخ‌دهی: Error code: 401 - {\'error\': {\'message\': \'Incorrect API key provided: sk-proj-********************************************************************************************************************************************************IjgA. You can find your API key at https://platform.openai.com/account/api-keys.\', \'type\': \'invalid_request_error\', \'param\': None, \'code\': \'invalid_api_key\'}}', '2025-07-21 11:04:32', '', 'image', '', '92ac38ff-eeeb-461d-b291-a69660b83c46'),
(62, 6, 'Please explain the following topic in simple and clear terms: سلام کمکم کن. I want to understand the main points, important details, and any necessary steps or precautions related to it.', 'خطا در پاسخ‌دهی: Error code: 401 - {\'error\': {\'message\': \'Incorrect API key provided: sk-proj-********************************************************************************************************************************************************IjgA. You can find your API key at https://platform.openai.com/account/api-keys.\', \'type\': \'invalid_request_error\', \'param\': None, \'code\': \'invalid_api_key\'}}', '2025-07-21 12:00:30', '', 'image', '', '92ac38ff-eeeb-461d-b291-a69660b83c46'),
(63, 6, 'Please explain the following topic in simple and clear terms: سلام کمکم کن. I want to understand the main points, important details, and any necessary steps or precautions related to it.', 'خطا در پاسخ‌دهی: Error code: 401 - {\'error\': {\'message\': \'Incorrect API key provided: sk-proj-********************************************************************************************************************************************************IjgA. You can find your API key at https://platform.openai.com/account/api-keys.\', \'type\': \'invalid_request_error\', \'param\': None, \'code\': \'invalid_api_key\'}}', '2025-07-21 12:00:48', '', 'image', '', '92ac38ff-eeeb-461d-b291-a69660b83c46'),
(64, 6, 'Please explain the following topic in simple and clear terms: سلام کمکم کن. I want to understand the main points, important details, and any necessary steps or precautions related to it.', 'خطا در پاسخ‌دهی: Error code: 401 - {\'error\': {\'message\': \'Incorrect API key provided: sk-proj-********************************************************************************************************************************************************IjgA. You can find your API key at https://platform.openai.com/account/api-keys.\', \'type\': \'invalid_request_error\', \'param\': None, \'code\': \'invalid_api_key\'}}', '2025-07-21 12:01:00', '', 'image', '', '92ac38ff-eeeb-461d-b291-a69660b83c46'),
(65, 6, 'Please explain the following topic in simple and clear terms: سلام. I want to understand the main points, important details, and any necessary steps or precautions related to it.', 'خطا در پاسخ‌دهی: Error code: 401 - {\'error\': {\'message\': \'Incorrect API key provided: sk-proj-********************************************************************************************************************************************************IjgA. You can find your API key at https://platform.openai.com/account/api-keys.\', \'type\': \'invalid_request_error\', \'param\': None, \'code\': \'invalid_api_key\'}}', '2025-07-21 12:01:43', '', 'image', '', '92ac38ff-eeeb-461d-b291-a69660b83c46'),
(66, 6, 'Please explain the following topic in simple and clear terms: سلام خوبی. I want to understand the main points, important details, and any necessary steps or precautions related to it.', 'سلام! امیدوارم حالتون خوب باشه. اگر موضوع خاصی مد نظر دارید که می‌خواهید درباره‌اش اطلاعات بیشتری به دست بیارید، لطفاً مشخص‌تر توضیح بدید تا بتونم کمک کنم. برای مثال، اگر در مورد یک موضوع حقوقی خاص مثل قوانین ارث، قراردادها، یا مسائل خانوادگی سوالی دارید، لطفاً بفرمایید تا به بهترین شکل راهنمایی‌تون کنم. منتظر توضیحات بیشترتون هستم.', '2025-07-21 12:12:17', '', 'image', '', '92ac38ff-eeeb-461d-b291-a69660b83c46'),
(67, 8, 'Please summarize the following text: دستیار خلاصه‌ساز متن ابزاری هوشمند است که به شما کمک می‌کند متون طولانی را به صورت خلاصه و مفید دریافت کنید. این دستیار با حفظ نکات کلیدی و مفهوم اصلی، متن را به زبان ساده‌تر و کوتاه‌تر ارائه می‌دهد تا در زمان شما صرفه‌جویی کند و فهم موضوع را آسان‌تر کند. مناسب دانشجویان، پژوهشگران، روزنامه‌نگاران و هر کسی که با حجم زیادی از اطلاعات متنی سروکار دارد. Make sure to keep the important details and main ideas clear and concise.\r\nAlways respond in Persian (Farsi).', 'دستیار خلاصه‌ساز متن یک ابزار هوشمند است که متون طولانی را به صورت خلاصه و مفید ارائه می‌دهد. این ابزار با حفظ نکات کلیدی و مفهوم اصلی، متن را ساده‌تر و کوتاه‌تر می‌کند تا در زمان صرفه‌جویی شود و فهم موضوع آسان‌تر گردد. این ابزار برای دانشجویان، پژوهشگران، روزنامه‌نگاران و افرادی که با اطلاعات متنی زیادی سروکار دارند، مناسب است.', '2025-08-11 01:30:01', '', 'image', '', '92ac38ff-eeeb-461d-b291-a69660b83c46'),
(68, 8, 'Please summarize the following text: دستیار خلاصه‌ساز متن ابزاری هوشمند است که به شما کمک می‌کند متون طولانی را به صورت خلاصه و مفید دریافت کنید. این دستیار با حفظ نکات کلیدی و مفهوم اصلی، متن را به زبان ساده‌تر و کوتاه‌تر ارائه می‌دهد تا در زمان شما صرفه‌جویی کند و فهم موضوع را آسان‌تر کند. مناسب دانشجویان، پژوهشگران، روزنامه‌نگاران و هر کسی که با حجم زیادی از اطلاعات متنی سروکار دارد. Make sure to keep the important details and main ideas clear and concise.\r\nAlways respond in Persian (Farsi).', 'دستیار خلاصه‌ساز متن یک ابزار هوشمند است که به کاربر کمک می‌کند تا متون طولانی را به صورت خلاصه و مفید دریافت کند. این ابزار با حفظ نکات کلیدی و مفهوم اصلی، متن را به زبانی ساده‌تر و کوتاه‌تر ارائه می‌دهد. هدف آن صرفه‌جویی در زمان و تسهیل فهم موضوع است. این ابزار برای دانشجویان، پژوهشگران، روزنامه‌نگاران و هر فردی که با حجم زیادی از اطلاعات متنی مواجه است، مناسب می‌باشد.', '2025-08-11 01:32:44', '', 'image', '', '92ac38ff-eeeb-461d-b291-a69660b83c46'),
(69, 8, 'Please summarize the following text: دستیار خلاصه‌ساز متن ابزاری هوشمند است که به شما کمک می‌کند متون طولانی را به صورت خلاصه و مفید دریافت کنید. این دستیار با حفظ نکات کلیدی و مفهوم اصلی، متن را به زبان ساده‌تر و کوتاه‌تر ارائه می‌دهد تا در زمان شما صرفه‌جویی کند و فهم موضوع را آسان‌تر کند. مناسب دانشجویان، پژوهشگران، روزنامه‌نگاران و هر کسی که با حجم زیادی از اطلاعات متنی سروکار دارد. Make sure to keep the important details and main ideas clear and concise.\r\nAlways respond in Persian (Farsi).', 'دستیار خلاصه‌ساز متن یک ابزار هوشمند است که متون طولانی را به صورت خلاصه و مفید ارائه می‌دهد. این دستیار با حفظ نکات کلیدی و مفهوم اصلی، متن را ساده‌تر و کوتاه‌تر می‌کند تا در زمان صرفه‌جویی شود و فهم موضوع آسان‌تر گردد. این ابزار برای دانشجویان، پژوهشگران، روزنامه‌نگاران و هر کسی که با حجم زیادی از اطلاعات متنی سروکار دارد، مناسب است.', '2025-08-11 01:33:06', '', 'image', '', '92ac38ff-eeeb-461d-b291-a69660b83c46'),
(70, 8, 'Please summarize the following text: دستیار خلاصه‌ساز متن ابزاری هوشمند است که به شما کمک می‌کند متون طولانی را به صورت خلاصه و مفید دریافت کنید. این دستیار با حفظ نکات کلیدی و مفهوم اصلی، متن را به زبان ساده‌تر و کوتاه‌تر ارائه می‌دهد تا در زمان شما صرفه‌جویی کند و فهم موضوع را آسان‌تر کند. مناسب دانشجویان، پژوهشگران، روزنامه‌نگاران و هر کسی که با حجم زیادی از اطلاعات متنی سروکار دارد. Make sure to keep the important details and main ideas clear and concise.\r\nAlways respond in Persian (Farsi).', 'خطا در پاسخ‌دهی: Error code: 401 - {\'error\': {\'message\': \'Incorrect API key provided: sk-1proj*********************************************************************************************************************************************************bSUA. You can find your API key at https://platform.openai.com/account/api-keys.\', \'type\': \'invalid_request_error\', \'param\': None, \'code\': \'invalid_api_key\'}}', '2025-08-11 11:33:03', '', 'image', '', '92ac38ff-eeeb-461d-b291-a69660b83c46');

-- --------------------------------------------------------

--
-- Table structure for table `ai_inputs`
--

CREATE TABLE `ai_inputs` (
  `id` int NOT NULL,
  `ai_model_id` int NOT NULL,
  `title` varchar(255) NOT NULL,
  `name` varchar(100) NOT NULL,
  `input_type` varchar(50) NOT NULL,
  `options` text
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `ai_inputs`
--

INSERT INTO `ai_inputs` (`id`, `ai_model_id`, `title`, `name`, `input_type`, `options`) VALUES
(104, 6, 'توضیحات', 'description', 'textarea', NULL),
(105, 5, 'نوع خودرو', 'vehicle_type', 'text', NULL),
(106, 5, 'برند و مدل', 'brand_model', 'text', NULL),
(107, 5, 'سال ساخت', 'manufacture_year', 'text', NULL),
(108, 5, 'نوع سوخت', 'fuel_type', 'text', NULL),
(109, 5, 'مسافت پیموده شده فعلی', 'current_mileage', 'text', NULL),
(110, 5, 'آخرین سرویس عمومی (تاریخ)', 'last_general_service_date', 'text', NULL),
(111, 5, 'آخرین سرویس عمومی (کیلومتر)', 'last_general_service_km', 'text', NULL),
(112, 5, 'آخرین تعویض روغن (تاریخ)', 'last_oil_change_date', 'text', NULL),
(113, 5, 'آخرین تعویض روغن (کیلومتر)', 'last_oil_change_km', 'text', NULL),
(114, 5, 'آخرین تعویض فیلتر (تاریخ)', 'last_filter_change_date', 'text', NULL),
(115, 5, 'آخرین تعویض فیلتر (کیلومتر)', 'last_filter_change_km', 'text', NULL),
(116, 5, 'آخرین تعویض (ترمز، باتری، تسمه تایم و غیره)', 'last_replacement_info', 'textarea', NULL),
(117, 5, 'سفرهای طولانی یا استفاده سنگین اخیر (تاریخ تقریبی و توضیحات)', 'long_trip_info', 'textarea', NULL),
(118, 4, 'موضوع کتاب', 'subject', 'text', NULL),
(119, 3, 'موضوع محتوا', 'subject', 'text', NULL),
(120, 2, 'عنوان بیماری', 'subject', 'text', NULL),
(122, 7, 'متن', 'text', 'textarea', NULL),
(123, 8, 'متن', 'text', 'textarea', NULL),
(167, 15, 'سبک تصویر', 'style', 'select', '[\"سینمایی\", \"کارتونی\", \"فانتزی\", \"شیشه ای\", \"کلاسیک\", \"نقاشی آبرنگ\", \"رئال\", \"نئون\"]'),
(168, 15, 'نور', 'lighting', 'radiobutton', '[\"نور نرم\", \"نور دراماتیک\", \"نور پس‌زمینه\", \"نور ساعت طلایی\", \"سایه‌های شدید\", \"نور نئون\"]'),
(169, 15, 'محیط', 'environment', 'radiobutton', '[\"جنگل مه‌آلود\", \"خیابان شلوغ شهر\", \"کتابخانه ساکت\", \"صحنه زیر آب\", \"اتاق دنج با نور گرم\"]'),
(170, 15, 'فضا', 'mood', 'select', '[\"جو رمزآلود\", \"آرام و صلح‌آمیز\", \"تاریک و وهم‌آور\", \"روشن و شاد\", \"فضای باز وسیع\"]'),
(181, 9, 'سن', 'age', 'number', NULL),
(182, 9, 'قد', 'height', 'number', NULL),
(183, 9, 'وزن', 'weight', 'number', NULL),
(184, 9, 'سطح تناسب اندام', 'fitness_level', 'select', '[\"مبتدی\", \"متوسط\", \"پیشرفته\"]'),
(185, 9, 'هدف', 'goal', 'select', '[\"چاقی\", \"لاغری\", \"تناسب اندام\", \"عضله سازی\"]'),
(186, 1, 'موضوع', 'subject', 'text', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `ai_models`
--

CREATE TABLE `ai_models` (
  `id` int NOT NULL,
  `title` varchar(255) NOT NULL,
  `description` text,
  `prompt` text,
  `system_prompt` text,
  `max_tokens` int DEFAULT '500',
  `provider` varchar(255) NOT NULL,
  `model` varchar(255) NOT NULL,
  `icon` varchar(255) DEFAULT NULL,
  `type` enum('image','text','video','audio') NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `ai_models`
--

INSERT INTO `ai_models` (`id`, `title`, `description`, `prompt`, `system_prompt`, `max_tokens`, `provider`, `model`, `icon`, `type`) VALUES
(1, 'آشپز', 'دستیار آشپز یک متخصص در حوزه آشپزی است که هدف اصلی او کمک به شما در تهیه، پخت و سرو غذاهاست. این دستیار به موضوعات مربوط به آشپزی، دستور پخت، مواد اولیه، روش‌های پخت، ترفندهای آشپزی و نکات تغذیه‌ای مربوط به غذاها پاسخ می‌دهد.', 'Generate a comprehensive and well-structured article in Persian (Farsi) about the topic of {subject}.', 'You are a chef and must only talk about cooking.  \r\nDo not discuss any other topics.  \r\nAlways respond in Persian (Farsi).', 16000, 'deepseek', 'deepseek-chat', '<i class=\"fa-solid fa-kitchen-set\"></i>', 'text'),
(2, 'چشم پزشک', 'دستیار چشم‌پزشک یک ابزار هوشمند برای راهنمایی بیماران در مسیر مراجعه، معاینه و پیگیری درمان‌های چشمی است. این دستیار با پاسخ به سوالات رایج، یادآوری نوبت‌ها و ارائه اطلاعات کاربردی، تجربه‌ای سریع‌تر و آگاهانه‌تر فراهم می‌کند. با زبان ساده و قابل فهم، همیشه کنار شماست تا در مسیر سلامت چشم، همراهتان باشد.', 'Can you explain {subject} in simple terms? I want to understand what it is, why it matters, and what I should do if I experience it.', 'You are a helpful and knowledgeable virtual ophthalmology assistant. Your role is to explain eye-related topics clearly, simply, and accurately to patients or their families. Use friendly, non-technical language, avoid medical jargon unless necessary, and offer useful tips or warnings if applicable. You are supportive, empathetic, and focused on making complex information easy to understand for non-experts.\r\nAlways respond in Persian (Farsi).', 2000, 'openai', 'gpt-4.1-mini', '<i class=\"fa-regular fa-eye\"></i>', 'text'),
(3, 'اینستاگرام', 'دستیار اینستاگرام یک ابزار هوشمند برای تولید محتوا و انتخاب هشتگ‌های حرفه‌ای است. این دستیار به شما کمک می‌کند تا برای پست‌های خود کپشن‌های جذاب بنویسید، هشتگ‌های مرتبط و پربازده پیدا کنید، و محتوای خود را برای الگوریتم اینستاگرام بهینه‌سازی کنید.\r\nبا زبان ساده و رویکردی خلاق، این دستیار مخصوص تمام افرادی‌ست که می‌خواهند در اینستاگرام بهتر دیده شوند.\r\nاز فروشگاه‌های آنلاین و بلاگرها گرفته تا کسب‌وکارهای کوچک و برندهای شخصی.', 'I’m posting about {subject} on Instagram. Can you help me write a caption and suggest the best hashtags for it?', 'You are an AI assistant specialized in Instagram content creation and hashtag strategy. Your job is to help users write engaging captions, generate relevant hashtags, and optimize their posts for reach and engagement. Use a friendly, modern tone that matches Instagram trends. Always consider the type of content (e.g. photo, reel, carousel) and the target audience. Provide hashtags that are relevant, balanced (between popular and niche), and in line with the topic.\r\nAlways respond in Persian (Farsi).', 2000, 'openai', 'gpt-4.1-mini', '<i class=\"fa-brands fa-instagram\"></i>', 'text'),
(4, 'نویسنده کتاب', 'دستیار نویسنده کتاب یک همراه هوشمند برای نویسندگان است که در همه مراحل خلق کتاب، از ایده‌پردازی و طرح‌ریزی گرفته تا نوشتن، ویرایش و سازماندهی محتوا، به شما کمک می‌کند. این دستیار می‌تواند با ارائه پیشنهادات نوشتاری، اصلاح جملات، ساختاردهی فصل‌ها و پاسخ به سوالات شما، فرآیند نوشتن کتاب را ساده‌تر و خلاقانه‌تر کند.\r\nمناسب نویسندگان تازه‌کار و حرفه‌ای که می‌خواهند داستان یا متن خود را به بهترین شکل ممکن بیان کنند.', 'I’m writing a book about {subject}. Can you help me brainstorm ideas, outline chapters, or improve my writing on this topic?', 'You are a creative and knowledgeable book writing assistant. Your role is to help authors at every stage of the writing process, including brainstorming ideas, outlining chapters, improving writing style, editing text, and organizing content logically. Use clear, encouraging, and constructive language. Provide practical tips and examples to help the writer express their ideas better and maintain coherence throughout the manuscript.\r\nAlways respond in Persian (Farsi).', 2000, 'deepseek', 'deepseek-chat', '<i class=\"fa-solid fa-feather\"></i>', 'text'),
(5, 'مدیریت خودرو', 'دستیار مدیریت خودرو یک ابزار هوشمند برای ثبت اطلاعات کامل وسیله نقلیه و برنامه‌ریزی سرویس‌های دوره‌ای است. با وارد کردن جزئیاتی مانند نوع خودرو، مدل، سال ساخت، نوع سوخت، و کیلومتر فعلی، این دستیار به شما کمک می‌کند زمان مناسب برای تعویض روغن، فیلترها، لنت ترمز، باتری، تسمه تایم و سایر سرویس‌ها را یادآوری کند. همچنین می‌توانید با ثبت اطلاعات سفرهای طولانی، میزان استهلاک خودرو را دقیق‌تر مدیریت کنید. این دستیار مناسب رانندگان شخصی، مدیران ناوگان، و تمام کسانی است که به نگهداری بهینه خودرو اهمیت می‌دهند.', 'I want to register a vehicle and track its maintenance.\r\nHere are the details:\r\nVehicle Type: {vehicle_type}\r\nBrand & Model: {brand_model}\r\nYear of Manufacture: {manufacture_year}\r\nFuel Type: {fuel_type}\r\nCurrent Mileage: {current_mileage}\r\n🛠 Maintenance Info\r\nLast General Service (date & km): {last_general_service_date}, {last_general_service_km}\r\nLast Oil Change (date & km): {last_oil_change_date}, {last_oil_change_km}\r\nLast Filter Change (date & km): {last_filter_change_date}, {last_filter_change_km}\r\nLast Replacement (brakes, battery, timing belt, etc.): {last_replacement_info}\r\nRecent Long Trips or Heavy Use (approx. date & description): {long_trip_info}\r\nCan you help me store this and set reminders for future services?', 'You are an intelligent assistant designed to help users manage and track vehicle information and maintenance schedules. Collect and understand details about each vehicle including type, brand, model, fuel type, mileage, and key maintenance events. When possible, use this data to recommend service reminders or estimate wear based on usage. Be accurate, concise, and helpful. If certain information (like VIN or license plate) is not provided, handle gracefully but note that accuracy may be reduced.\r\nAlways respond in Persian (Farsi).', 2000, 'deepseek', 'deepseek-chat', '<i class=\"fa-solid fa-car\"></i>', 'text'),
(6, 'مشاور حقوقی', 'دستیار مشاور حقوقی یک ابزار هوشمند است که با تمرکز بر قوانین جمهوری اسلامی ایران، به شما کمک می‌کند مسائل حقوقی را به زبان ساده و قابل فهم درک کنید. این دستیار قادر است توضیحاتی درباره حقوق، تکالیف، فرآیندها و راهکارهای قانونی ارائه دهد اما نمی‌تواند جایگزین وکیل رسمی شود. اگر موضوعی نیازمند مشاوره تخصصی و وکالت باشد، شما را به مراجعه به وکیل مجاز راهنمایی می‌کند. این دستیار مناسب عموم مردم است که می‌خواهند حقوق خود را بهتر بشناسند و تصمیمات بهتری بگیرند.', 'Please explain the following topic in simple and clear terms: {description}. I want to understand the main points, important details, and any necessary steps or precautions related to it.', 'You are a legal assistant specialized in Iranian law. Your task is to provide general legal guidance based on the laws and regulations of the Islamic Republic of Iran. You explain legal topics, terms, and procedures in clear and simple Persian (Farsi), suitable for the general public. You do not offer formal legal representation or replace a licensed attorney, but you help users understand their rights, obligations, and available legal pathways. If a topic requires official legal intervention, recommend the user consult a licensed lawyer in Iran.Always respond in Persian (Farsi).', 2000, 'openai', 'gpt-4o', '<i class=\"fa-solid fa-scale-balanced\"></i>', 'text'),
(7, 'ویراستار', 'دستیار ویراستار یک ابزار هوشمند برای کمک به بهبود کیفیت متون شماست. این دستیار می‌تواند املای کلمات، نگارش جملات، دستور زبان، ساختار پاراگراف‌ها و روان بودن متن را بررسی و اصلاح کند. هدف آن ارائه پیشنهادهای دقیق و کاربردی برای ارتقای متن شما، چه در حوزه ادبیات، مقاله‌نویسی، گزارش یا هر نوع نوشته دیگر است. مناسب نویسندگان، دانشجویان، و هر کسی که می‌خواهد متنی حرفه‌ای‌تر و خواناتر داشته باشد.', 'Please review and improve the following text: {text} Focus on spelling, grammar, sentence flow, and overall clarity.', 'You are a smart and helpful editing assistant. Your role is to improve texts by checking spelling, grammar, sentence structure, and clarity. Provide constructive suggestions to enhance the readability and professionalism of the text. Be polite, clear, and concise in your feedback.\r\nAlways respond in Persian (Farsi).', 2000, 'openai', 'gpt-4o', '<i class=\"fa-solid fa-pen-to-square\"></i>', 'text'),
(8, 'خلاصه ساز متن', 'دستیار خلاصه‌ساز متن ابزاری هوشمند است که به شما کمک می‌کند متون طولانی را به صورت خلاصه و مفید دریافت کنید. این دستیار با حفظ نکات کلیدی و مفهوم اصلی، متن را به زبان ساده‌تر و کوتاه‌تر ارائه می‌دهد تا در زمان شما صرفه‌جویی کند و فهم موضوع را آسان‌تر کند. مناسب دانشجویان، پژوهشگران، روزنامه‌نگاران و هر کسی که با حجم زیادی از اطلاعات متنی سروکار دارد.', 'Please summarize the following text: {text} Make sure to keep the important details and main ideas clear and concise.\r\nAlways respond in Persian (Farsi).', 'You are an intelligent assistant specialized in summarizing long texts. Your goal is to extract the key points and main ideas, then present them concisely and clearly without losing the core meaning. Use simple and accessible language so that the summary is easy to understand.', 2000, 'openai', 'gpt-4o', '<i class=\"fa-solid fa-file-lines\"></i>', 'text'),
(9, 'مربی بدنسازی', 'دستیار مربی بدنسازی یک همراه هوشمند برای برنامه‌ریزی تمرینات، ارائه نکات ورزشی، و پاسخ به سوالات مرتبط با بدنسازی و تغذیه است. این دستیار می‌تواند به شما در تعیین برنامه‌های تمرینی مناسب سطح و هدف شما کمک کند، روش‌های صحیح انجام حرکات را توضیح دهد، و راهکارهایی برای حفظ انگیزه و پیشرفت ارائه دهد. مناسب ورزشکاران مبتدی تا حرفه‌ای که می‌خواهند با دانش و برنامه‌ریزی بهتر به اهداف بدنی خود برسند.', 'I want to improve my fitness with a workout plan focused on {subject}. My details are as follows:\r\nAge: {age}\r\nHeight: {height}\r\nWeight: {weight}\r\nFitness level: {fitness_level}\r\nGoal: {goal}\r\nPlease design a workout plan and provide tips on exercise and nutrition tailored to my needs.', 'You are a knowledgeable and supportive fitness coach assistant. Your role is to help users create effective workout plans, explain exercises with proper form, provide nutrition tips, and motivate them to reach their fitness goals. Communicate in a friendly and encouraging tone, tailoring advice to the user’s fitness level and objectives.\r\nAlways respond in Persian (Farsi).', 3000, 'deepseek', 'deepseek-chat', '<i class=\"fa-solid fa-dumbbell\"></i>', 'text'),
(15, 'تولید تصویر', 'تولید تصویر', 'برای تولید تصویر ابتدا پارامترهای زیر را در نظر بگیر\r\n{style}\r\n{lighting}\r\n{environment}\r\n{mood}', '', 2000, 'openai', 'gpt-4o', '<i class=\"fa-solid fa-image\"></i>', 'image'),
(16, 'تولید صدا', 'این دستیار متن وارد شده را به‌صورت صدای طبیعی و روان تبدیل می‌کند.\r\nبرای مثال، می‌توانید متنی را وارد کرده و خروجی آن را به‌صورت فایل صوتی (فرمت MP3) دریافت و پخش کنید.', '', '', 500, 'openai', 'gpt-4o-mini-tts', '<i class=\"fas fa-headphones-alt\"></i>', 'audio');

-- --------------------------------------------------------

--
-- Table structure for table `alembic_version`
--

CREATE TABLE `alembic_version` (
  `version_num` varchar(32) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `alembic_version`
--

INSERT INTO `alembic_version` (`version_num`) VALUES
('794b0f879c94');

-- --------------------------------------------------------

--
-- Table structure for table `assistants`
--

CREATE TABLE `assistants` (
  `id` int NOT NULL,
  `title` varchar(255) NOT NULL,
  `description` text,
  `faiss_url` varchar(500) DEFAULT NULL,
  `pkl_url` varchar(500) DEFAULT NULL,
  `excel_url` varchar(500) DEFAULT NULL,
  `status` tinyint(1) DEFAULT NULL,
  `domain` varchar(255) NOT NULL,
  `slug` varchar(36) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `assistants`
--

INSERT INTO `assistants` (`id`, `title`, `description`, `faiss_url`, `pkl_url`, `excel_url`, `status`, `domain`, `slug`) VALUES
(38, 'دستیار عمومی', 'این یک دستیار عمومی است', 'static/uploads\\user_92ac38ff-eeeb-461d-b291-a69660b83c46/vectorstores/38/index.faiss', 'static/uploads\\user_92ac38ff-eeeb-461d-b291-a69660b83c46/vectorstores/38/index.pkl', 'static/uploads\\user_92ac38ff-eeeb-461d-b291-a69660b83c46\\afdad3c9b208794b.xlsx', 1, '', '');

-- --------------------------------------------------------

--
-- Table structure for table `file_uploads`
--

CREATE TABLE `file_uploads` (
  `id` int NOT NULL,
  `user_id` varchar(36) NOT NULL,
  `filename` varchar(255) NOT NULL,
  `filepath` varchar(512) NOT NULL,
  `content_type` varchar(100) DEFAULT NULL,
  `size` int NOT NULL,
  `uploaded_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `otps`
--

CREATE TABLE `otps` (
  `id` int NOT NULL,
  `phone` varchar(20) NOT NULL,
  `otp_code` varchar(6) NOT NULL,
  `expire_at` datetime NOT NULL,
  `created_at` datetime DEFAULT NULL,
  `is_used` tinyint(1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

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
(25, 'list_subscription_plan', 'لیست پلن های اشتراک'),
(26, 'create_subscription_plan', 'ایجاد پلن اشتراک'),
(27, 'edit_subscription_plan', 'ویرایش پلن اشتراک'),
(28, 'delete_subscription_plan', 'حذف پلن اشتراک'),
(29, 'list_user_subscription', 'لیست اشتراک های کاربر'),
(30, 'delete_user_subscription', 'حذف اشتراک کاربر');

-- --------------------------------------------------------

--
-- Table structure for table `rate_limits`
--

CREATE TABLE `rate_limits` (
  `ip` varchar(45) NOT NULL,
  `request_count` int DEFAULT NULL,
  `last_request` datetime DEFAULT (now())
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `rate_limits`
--

INSERT INTO `rate_limits` (`ip`, `request_count`, `last_request`) VALUES
('127.0.0.1', 1, '2025-08-11 11:22:24');

-- --------------------------------------------------------

--
-- Table structure for table `refresh_tokens`
--

CREATE TABLE `refresh_tokens` (
  `id` int NOT NULL,
  `token` varchar(512) NOT NULL,
  `user_id` varchar(36) NOT NULL,
  `is_active` tinyint(1) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `expires_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `refresh_tokens`
--

INSERT INTO `refresh_tokens` (`id`, `token`, `user_id`, `is_active`, `created_at`, `expires_at`) VALUES
(17, '0779d039b460c43504c67a4794bbe6d0231e59eb1371b42f657810ceb22fd61c', '92ac38ff-eeeb-461d-b291-a69660b83c46', 1, '2025-08-11 11:22:24', '2025-08-18 11:22:24');

-- --------------------------------------------------------

--
-- Table structure for table `roles`
--

CREATE TABLE `roles` (
  `id` int NOT NULL,
  `name` varchar(256) DEFAULT NULL,
  `title` varchar(256) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `roles`
--

INSERT INTO `roles` (`id`, `name`, `title`) VALUES
(1, 'Admin', 'مدیر'),
(2, 'User', 'کاربر');

-- --------------------------------------------------------

--
-- Table structure for table `role_permissions`
--

CREATE TABLE `role_permissions` (
  `role_id` int DEFAULT NULL,
  `permission_id` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `role_permissions`
--

INSERT INTO `role_permissions` (`role_id`, `permission_id`) VALUES
(1, 1),
(1, 2),
(1, 3),
(1, 4),
(1, 5),
(1, 6),
(1, 7),
(1, 8),
(1, 9),
(1, 10),
(1, 11),
(1, 12),
(1, 13),
(1, 14),
(1, 15),
(1, 16),
(1, 17),
(1, 18),
(1, 19),
(1, 20),
(1, 24),
(1, 21),
(1, 23),
(1, 22),
(1, 26),
(1, 25),
(1, 27),
(1, 28),
(1, 30),
(1, 29);

-- --------------------------------------------------------

--
-- Table structure for table `subscription_plans`
--

CREATE TABLE `subscription_plans` (
  `id` varchar(36) NOT NULL,
  `title` varchar(255) NOT NULL,
  `description` varchar(500) DEFAULT NULL,
  `duration_days` int NOT NULL,
  `tokens_allowed` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `subscription_plans`
--

INSERT INTO `subscription_plans` (`id`, `title`, `description`, `duration_days`, `tokens_allowed`) VALUES
('5237e273-9e24-4349-818c-2bb6e830427a', 'بسته طلایی', '', 10, 2500),
('a6219046-0440-4979-8d75-f3855fbbe391', 'بسته نقره ای', 'ندارد', 30, 1000);

-- --------------------------------------------------------

--
-- Table structure for table `tokens`
--

CREATE TABLE `tokens` (
  `id` int NOT NULL,
  `token` varchar(512) NOT NULL,
  `user_id` varchar(36) NOT NULL,
  `is_active` tinyint(1) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `tokens`
--

INSERT INTO `tokens` (`id`, `token`, `user_id`, `is_active`, `created_at`) VALUES
(79, 'b5190368498399e7871d61a5fc5ab3c9f36c6cdc96aa126b77d989b44e6e3044', '92ac38ff-eeeb-461d-b291-a69660b83c46', 1, '2025-08-11 14:07:30');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` varchar(36) NOT NULL,
  `email` varchar(255) DEFAULT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `password` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `email`, `phone`, `password`) VALUES
('92ac38ff-eeeb-461d-b291-a69660b83c46', 'admin@gmail.com', '', '$2b$12$f5cbzLZQ33yYqowo2URA0uFD8jrZd0E6WeDvip3Z1tZbpc97HuO4i');

-- --------------------------------------------------------

--
-- Table structure for table `user_roles`
--

CREATE TABLE `user_roles` (
  `user_id` varchar(36) NOT NULL,
  `role_id` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `user_roles`
--

INSERT INTO `user_roles` (`user_id`, `role_id`) VALUES
('92ac38ff-eeeb-461d-b291-a69660b83c46', 1);

-- --------------------------------------------------------

--
-- Table structure for table `user_subscriptions`
--

CREATE TABLE `user_subscriptions` (
  `id` varchar(36) NOT NULL,
  `user_id` varchar(36) NOT NULL,
  `start_date` datetime NOT NULL,
  `end_date` datetime NOT NULL,
  `plan_id` varchar(36) NOT NULL,
  `active` tinyint(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `user_subscriptions`
--

INSERT INTO `user_subscriptions` (`id`, `user_id`, `start_date`, `end_date`, `plan_id`, `active`) VALUES
('66a790ec-ffbb-4381-aa5c-2a53b4f0ff1b', '92ac38ff-eeeb-461d-b291-a69660b83c46', '2025-08-11 11:49:35', '2025-08-11 11:49:35', 'a6219046-0440-4979-8d75-f3855fbbe391', 0),
('b582c755-e027-4443-80b7-f9b183fd7013', '92ac38ff-eeeb-461d-b291-a69660b83c46', '2025-08-11 12:20:19', '2025-08-11 12:20:19', 'a6219046-0440-4979-8d75-f3855fbbe391', 0),
('baf232d8-6f0c-47ef-a16f-8bbaac9b59a6', '92ac38ff-eeeb-461d-b291-a69660b83c46', '2025-08-11 11:53:41', '2025-08-11 11:53:41', 'a6219046-0440-4979-8d75-f3855fbbe391', 0),
('c1f2009b-fb82-456d-9ea7-f7dffe93e723', '92ac38ff-eeeb-461d-b291-a69660b83c46', '2025-08-11 12:21:02', '2025-08-11 12:21:02', 'a6219046-0440-4979-8d75-f3855fbbe391', 0),
('d94ea735-73ca-402c-bf99-f78f984dfdb0', '92ac38ff-eeeb-461d-b291-a69660b83c46', '2025-08-11 14:15:19', '2025-08-11 14:15:19', 'a6219046-0440-4979-8d75-f3855fbbe391', 0),
('f4459a01-1bf8-496b-9be3-5958e0245122', '92ac38ff-eeeb-461d-b291-a69660b83c46', '2025-08-11 14:16:50', '2025-08-11 14:16:50', '5237e273-9e24-4349-818c-2bb6e830427a', 1);

-- --------------------------------------------------------

--
-- Table structure for table `user_tokens`
--

CREATE TABLE `user_tokens` (
  `id` varchar(36) NOT NULL,
  `user_id` varchar(36) NOT NULL,
  `tokens_used` int NOT NULL,
  `created_at` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `user_tokens`
--

INSERT INTO `user_tokens` (`id`, `user_id`, `tokens_used`, `created_at`) VALUES
('26cabfba-4cf1-4f07-8971-c63e1905fa86', '92ac38ff-eeeb-461d-b291-a69660b83c46', 4486, '2025-08-11 12:20:19');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `ai_archives`
--
ALTER TABLE `ai_archives`
  ADD PRIMARY KEY (`id`),
  ADD KEY `ai_model_id` (`ai_model_id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `ai_inputs`
--
ALTER TABLE `ai_inputs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `ai_model_id` (`ai_model_id`),
  ADD KEY `ix_ai_inputs_id` (`id`);

--
-- Indexes for table `ai_models`
--
ALTER TABLE `ai_models`
  ADD PRIMARY KEY (`id`),
  ADD KEY `ix_ai_models_id` (`id`);

--
-- Indexes for table `alembic_version`
--
ALTER TABLE `alembic_version`
  ADD PRIMARY KEY (`version_num`);

--
-- Indexes for table `assistants`
--
ALTER TABLE `assistants`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `slug` (`slug`),
  ADD KEY `ix_assistants_id` (`id`);

--
-- Indexes for table `file_uploads`
--
ALTER TABLE `file_uploads`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `ix_file_uploads_id` (`id`);

--
-- Indexes for table `otps`
--
ALTER TABLE `otps`
  ADD PRIMARY KEY (`id`),
  ADD KEY `ix_otps_id` (`id`),
  ADD KEY `ix_otps_phone` (`phone`);

--
-- Indexes for table `permissions`
--
ALTER TABLE `permissions`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `ix_permissions_name` (`name`),
  ADD UNIQUE KEY `ix_permissions_title` (`title`),
  ADD KEY `ix_permissions_id` (`id`);

--
-- Indexes for table `rate_limits`
--
ALTER TABLE `rate_limits`
  ADD PRIMARY KEY (`ip`),
  ADD KEY `ix_rate_limits_ip` (`ip`);

--
-- Indexes for table `refresh_tokens`
--
ALTER TABLE `refresh_tokens`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `ix_refresh_tokens_token` (`token`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `ix_refresh_tokens_id` (`id`);

--
-- Indexes for table `roles`
--
ALTER TABLE `roles`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `ix_roles_name` (`name`),
  ADD UNIQUE KEY `ix_roles_title` (`title`),
  ADD KEY `ix_roles_id` (`id`);

--
-- Indexes for table `role_permissions`
--
ALTER TABLE `role_permissions`
  ADD KEY `permission_id` (`permission_id`),
  ADD KEY `role_id` (`role_id`);

--
-- Indexes for table `subscription_plans`
--
ALTER TABLE `subscription_plans`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `ix_subscription_plans_id` (`id`);

--
-- Indexes for table `tokens`
--
ALTER TABLE `tokens`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `token` (`token`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `ix_tokens_id` (`id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `ix_users_id` (`id`),
  ADD UNIQUE KEY `ix_users_email` (`email`),
  ADD UNIQUE KEY `ix_users_phone` (`phone`);

--
-- Indexes for table `user_roles`
--
ALTER TABLE `user_roles`
  ADD PRIMARY KEY (`user_id`,`role_id`),
  ADD KEY `role_id` (`role_id`);

--
-- Indexes for table `user_subscriptions`
--
ALTER TABLE `user_subscriptions`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `ix_user_subscriptions_id` (`id`),
  ADD KEY `ix_user_subscriptions_user_id` (`user_id`),
  ADD KEY `plan_id` (`plan_id`);

--
-- Indexes for table `user_tokens`
--
ALTER TABLE `user_tokens`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `ix_user_tokens_id` (`id`),
  ADD KEY `ix_user_tokens_user_id` (`user_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `ai_archives`
--
ALTER TABLE `ai_archives`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=71;

--
-- AUTO_INCREMENT for table `ai_inputs`
--
ALTER TABLE `ai_inputs`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=187;

--
-- AUTO_INCREMENT for table `ai_models`
--
ALTER TABLE `ai_models`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;

--
-- AUTO_INCREMENT for table `assistants`
--
ALTER TABLE `assistants`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=39;

--
-- AUTO_INCREMENT for table `file_uploads`
--
ALTER TABLE `file_uploads`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `otps`
--
ALTER TABLE `otps`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `permissions`
--
ALTER TABLE `permissions`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=31;

--
-- AUTO_INCREMENT for table `refresh_tokens`
--
ALTER TABLE `refresh_tokens`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=18;

--
-- AUTO_INCREMENT for table `roles`
--
ALTER TABLE `roles`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `tokens`
--
ALTER TABLE `tokens`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=80;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `ai_archives`
--
ALTER TABLE `ai_archives`
  ADD CONSTRAINT `ai_archives_ibfk_1` FOREIGN KEY (`ai_model_id`) REFERENCES `ai_models` (`id`),
  ADD CONSTRAINT `ai_archives_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);

--
-- Constraints for table `ai_inputs`
--
ALTER TABLE `ai_inputs`
  ADD CONSTRAINT `ai_inputs_ibfk_1` FOREIGN KEY (`ai_model_id`) REFERENCES `ai_models` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `file_uploads`
--
ALTER TABLE `file_uploads`
  ADD CONSTRAINT `file_uploads_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);

--
-- Constraints for table `refresh_tokens`
--
ALTER TABLE `refresh_tokens`
  ADD CONSTRAINT `refresh_tokens_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `role_permissions`
--
ALTER TABLE `role_permissions`
  ADD CONSTRAINT `role_permissions_ibfk_1` FOREIGN KEY (`permission_id`) REFERENCES `permissions` (`id`),
  ADD CONSTRAINT `role_permissions_ibfk_2` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`);

--
-- Constraints for table `tokens`
--
ALTER TABLE `tokens`
  ADD CONSTRAINT `tokens_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);

--
-- Constraints for table `user_roles`
--
ALTER TABLE `user_roles`
  ADD CONSTRAINT `user_roles_ibfk_1` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`),
  ADD CONSTRAINT `user_roles_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);

--
-- Constraints for table `user_subscriptions`
--
ALTER TABLE `user_subscriptions`
  ADD CONSTRAINT `user_subscriptions_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `user_subscriptions_ibfk_2` FOREIGN KEY (`plan_id`) REFERENCES `subscription_plans` (`id`);

--
-- Constraints for table `user_tokens`
--
ALTER TABLE `user_tokens`
  ADD CONSTRAINT `user_tokens_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
