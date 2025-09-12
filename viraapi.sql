-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Generation Time: Sep 12, 2025 at 07:31 AM
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
(122, 7, 'متن', 'text', 'textarea', NULL),
(123, 8, 'متن', 'text', 'textarea', NULL),
(167, 15, 'سبک تصویر', 'style', 'select', '[\"سینمایی\", \"کارتونی\", \"فانتزی\", \"شیشه ای\", \"کلاسیک\", \"نقاشی آبرنگ\", \"رئال\", \"نئون\"]'),
(168, 15, 'نور', 'lighting', 'radiobutton', '[\"نور نرم\", \"نور دراماتیک\", \"نور پس‌زمینه\", \"نور ساعت طلایی\", \"سایه‌های شدید\", \"نور نئون\"]'),
(169, 15, 'محیط', 'environment', 'radiobutton', '[\"جنگل مه‌آلود\", \"خیابان شلوغ شهر\", \"کتابخانه ساکت\", \"صحنه زیر آب\", \"اتاق دنج با نور گرم\"]'),
(170, 15, 'فضا', 'mood', 'select', '[\"جو رمزآلود\", \"آرام و صلح‌آمیز\", \"تاریک و وهم‌آور\", \"روشن و شاد\", \"فضای باز وسیع\"]'),
(186, 1, 'موضوع', 'subject', 'text', NULL),
(187, 9, 'سن', 'age', 'number', NULL),
(188, 9, 'قد', 'height', 'number', NULL),
(189, 9, 'وزن', 'weight', 'number', NULL),
(190, 9, 'سطح تناسب اندام', 'fitness_level', 'select', '[\"مبتدی\", \"متوسط\", \"پیشرفته\"]'),
(191, 9, 'هدف', 'goal', 'select', '[\"چاقی\", \"لاغری\", \"تناسب اندام\", \"عضله سازی\"]'),
(192, 5, 'نوع خودرو', 'vehicle_type', 'text', NULL),
(193, 5, 'برند و مدل', 'brand_model', 'text', NULL),
(194, 5, 'سال ساخت', 'manufacture_year', 'text', NULL),
(195, 5, 'نوع سوخت', 'fuel_type', 'text', NULL),
(196, 5, 'مسافت پیموده شده فعلی', 'current_mileage', 'text', NULL),
(197, 5, 'آخرین سرویس عمومی (تاریخ)', 'last_general_service_date', 'text', NULL),
(198, 5, 'آخرین سرویس عمومی (کیلومتر)', 'last_general_service_km', 'text', NULL),
(199, 5, 'آخرین تعویض روغن (تاریخ)', 'last_oil_change_date', 'text', NULL),
(200, 5, 'آخرین تعویض روغن (کیلومتر)', 'last_oil_change_km', 'text', NULL),
(201, 5, 'آخرین تعویض فیلتر (تاریخ)', 'last_filter_change_date', 'text', NULL),
(202, 5, 'آخرین تعویض فیلتر (کیلومتر)', 'last_filter_change_km', 'text', NULL),
(203, 5, 'آخرین تعویض (ترمز، باتری، تسمه تایم و غیره)', 'last_replacement_info', 'textarea', NULL),
(204, 5, 'سفرهای طولانی یا استفاده سنگین اخیر (تاریخ تقریبی و توضیحات)', 'long_trip_info', 'textarea', NULL),
(207, 2, 'عنوان بیماری', 'subject', 'text', NULL),
(212, 4, 'موضوع کتاب', 'subject', 'text', NULL),
(218, 3, 'موضوع محتوا', 'topic', 'text', NULL),
(219, 3, 'نوع محتوا', 'type', 'radiobutton', '[\"پست\", \"استوری\"]');

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
  `type` enum('image','text','video','audio','vision','speech_audio','analyst','text_image') CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `ai_models`
--

INSERT INTO `ai_models` (`id`, `title`, `description`, `prompt`, `system_prompt`, `max_tokens`, `provider`, `model`, `icon`, `type`) VALUES
(1, 'آشپز', 'دستیار آشپز یک متخصص در حوزه آشپزی است که هدف اصلی او کمک به شما در تهیه، پخت و سرو غذاهاست. این دستیار به موضوعات مربوط به آشپزی، دستور پخت، مواد اولیه، روش‌های پخت، ترفندهای آشپزی و نکات تغذیه‌ای مربوط به غذاها پاسخ می‌دهد.', 'Generate a comprehensive and well-structured article in Persian (Farsi) about the topic of {subject}.', 'You are a chef and must only talk about cooking.  \r\nDo not discuss any other topics.  \r\nAlways respond in Persian (Farsi).', 16000, 'deepseek', 'deepseek-chat', '<i class=\"fa-solid fa-kitchen-set\"></i>', 'text'),
(2, 'چشم پزشک', 'دستیار چشم‌پزشک یک ابزار هوشمند برای راهنمایی بیماران در مسیر مراجعه، معاینه و پیگیری درمان‌های چشمی است. این دستیار با پاسخ به سوالات رایج، یادآوری نوبت‌ها و ارائه اطلاعات کاربردی، تجربه‌ای سریع‌تر و آگاهانه‌تر فراهم می‌کند. با زبان ساده و قابل فهم، همیشه کنار شماست تا در مسیر سلامت چشم، همراهتان باشد.', 'Can you explain {subject} in simple terms? I want to understand what it is, why it matters, and what I should do if I experience it.', 'You are a helpful and knowledgeable virtual ophthalmology assistant. Your role is to explain eye-related topics clearly, simply, and accurately to patients or their families. Use friendly, non-technical language, avoid medical jargon unless necessary, and offer useful tips or warnings if applicable. You are supportive, empathetic, and focused on making complex information easy to understand for non-experts.\r\nAlways respond in Persian (Farsi).', 2000, 'openai', 'gpt-4o', '<i class=\"fa-regular fa-eye\"></i>', 'text'),
(3, 'اینستاگرام', 'دستیار اینستاگرام یک ابزار هوشمند برای تولید محتوا و انتخاب هشتگ‌های حرفه‌ای است. این دستیار به شما کمک می‌کند تا برای پست‌های خود کپشن‌های جذاب بنویسید، هشتگ‌های مرتبط و پربازده پیدا کنید، و محتوای خود را برای الگوریتم اینستاگرام بهینه‌سازی کنید.\r\nبا زبان ساده و رویکردی خلاق، این دستیار مخصوص تمام افرادی‌ست که می‌خواهند در اینستاگرام بهتر دیده شوند.\r\nاز فروشگاه‌های آنلاین و بلاگرها گرفته تا کسب‌وکارهای کوچک و برندهای شخصی.', 'Based on the topic {topic}, write an engaging and standard Instagram caption and use hashtags related to the subject. This is an Instagram {type}', 'You are an AI assistant specialized in Instagram content creation and hashtag strategy. Your job is to help users write engaging captions, generate relevant hashtags, and optimize their posts for reach and engagement. Use a friendly, modern tone that matches Instagram trends. Always consider the type of content (e.g. photo, reel, carousel) and the target audience. Provide hashtags that are relevant, balanced (between popular and niche), and in line with the topic.\r\nAlways respond in Persian (Farsi).', 2000, 'openai', 'gpt-4o', '<i class=\"fa-brands fa-instagram\"></i>', 'text_image'),
(4, 'نویسنده کتاب', 'دستیار نویسنده کتاب یک همراه هوشمند برای نویسندگان است که در همه مراحل خلق کتاب، از ایده‌پردازی و طرح‌ریزی گرفته تا نوشتن، ویرایش و سازماندهی محتوا، به شما کمک می‌کند. این دستیار می‌تواند با ارائه پیشنهادات نوشتاری، اصلاح جملات، ساختاردهی فصل‌ها و پاسخ به سوالات شما، فرآیند نوشتن کتاب را ساده‌تر و خلاقانه‌تر کند.\r\nمناسب نویسندگان تازه‌کار و حرفه‌ای که می‌خواهند داستان یا متن خود را به بهترین شکل ممکن بیان کنند.', 'I’m writing a book about {subject}. Can you help me brainstorm ideas, outline chapters, or improve my writing on this topic?', 'You are a creative and knowledgeable book writing assistant. Your role is to help authors at every stage of the writing process, including brainstorming ideas, outlining chapters, improving writing style, editing text, and organizing content logically. Use clear, encouraging, and constructive language. Provide practical tips and examples to help the writer express their ideas better and maintain coherence throughout the manuscript.\r\nAlways respond in Persian (Farsi).', 2000, 'openai', 'gpt-4o', '<i class=\"fa-solid fa-feather\"></i>', 'text'),
(5, 'مدیریت خودرو', 'دستیار مدیریت خودرو یک ابزار هوشمند برای ثبت اطلاعات کامل وسیله نقلیه و برنامه‌ریزی سرویس‌های دوره‌ای است. با وارد کردن جزئیاتی مانند نوع خودرو، مدل، سال ساخت، نوع سوخت، و کیلومتر فعلی، این دستیار به شما کمک می‌کند زمان مناسب برای تعویض روغن، فیلترها، لنت ترمز، باتری، تسمه تایم و سایر سرویس‌ها را یادآوری کند. همچنین می‌توانید با ثبت اطلاعات سفرهای طولانی، میزان استهلاک خودرو را دقیق‌تر مدیریت کنید. این دستیار مناسب رانندگان شخصی، مدیران ناوگان، و تمام کسانی است که به نگهداری بهینه خودرو اهمیت می‌دهند.', 'I want to register a vehicle and track its maintenance.\r\nHere are the details:\r\nVehicle Type: {vehicle_type}\r\nBrand & Model: {brand_model}\r\nYear of Manufacture: {manufacture_year}\r\nFuel Type: {fuel_type}\r\nCurrent Mileage: {current_mileage}\r\n🛠 Maintenance Info\r\nLast General Service (date & km): {last_general_service_date}, {last_general_service_km}\r\nLast Oil Change (date & km): {last_oil_change_date}, {last_oil_change_km}\r\nLast Filter Change (date & km): {last_filter_change_date}, {last_filter_change_km}\r\nLast Replacement (brakes, battery, timing belt, etc.): {last_replacement_info}\r\nRecent Long Trips or Heavy Use (approx. date & description): {long_trip_info}\r\nCan you help me store this and set reminders for future services?', 'You are an intelligent assistant designed to help users manage and track vehicle information and maintenance schedules. Collect and understand details about each vehicle including type, brand, model, fuel type, mileage, and key maintenance events. When possible, use this data to recommend service reminders or estimate wear based on usage. Be accurate, concise, and helpful. If certain information (like VIN or license plate) is not provided, handle gracefully but note that accuracy may be reduced.\r\nAlways respond in Persian (Farsi).', 2000, 'openai', 'gpt-4o', '<i class=\"fa-solid fa-car\"></i>', 'text'),
(6, 'مشاور حقوقی', 'دستیار مشاور حقوقی یک ابزار هوشمند است که با تمرکز بر قوانین جمهوری اسلامی ایران، به شما کمک می‌کند مسائل حقوقی را به زبان ساده و قابل فهم درک کنید. این دستیار قادر است توضیحاتی درباره حقوق، تکالیف، فرآیندها و راهکارهای قانونی ارائه دهد اما نمی‌تواند جایگزین وکیل رسمی شود. اگر موضوعی نیازمند مشاوره تخصصی و وکالت باشد، شما را به مراجعه به وکیل مجاز راهنمایی می‌کند. این دستیار مناسب عموم مردم است که می‌خواهند حقوق خود را بهتر بشناسند و تصمیمات بهتری بگیرند.', 'Please explain the following topic in simple and clear terms: {description}. I want to understand the main points, important details, and any necessary steps or precautions related to it.', 'You are a legal assistant specialized in Iranian law. Your task is to provide general legal guidance based on the laws and regulations of the Islamic Republic of Iran. You explain legal topics, terms, and procedures in clear and simple Persian (Farsi), suitable for the general public. You do not offer formal legal representation or replace a licensed attorney, but you help users understand their rights, obligations, and available legal pathways. If a topic requires official legal intervention, recommend the user consult a licensed lawyer in Iran.Always respond in Persian (Farsi).', 2000, 'openai', 'gpt-4o', '<i class=\"fa-solid fa-scale-balanced\"></i>', 'text'),
(7, 'ویراستار', 'دستیار ویراستار یک ابزار هوشمند برای کمک به بهبود کیفیت متون شماست. این دستیار می‌تواند املای کلمات، نگارش جملات، دستور زبان، ساختار پاراگراف‌ها و روان بودن متن را بررسی و اصلاح کند. هدف آن ارائه پیشنهادهای دقیق و کاربردی برای ارتقای متن شما، چه در حوزه ادبیات، مقاله‌نویسی، گزارش یا هر نوع نوشته دیگر است. مناسب نویسندگان، دانشجویان، و هر کسی که می‌خواهد متنی حرفه‌ای‌تر و خواناتر داشته باشد.', 'Please review and improve the following text: {text} Focus on spelling, grammar, sentence flow, and overall clarity.', 'You are a smart and helpful editing assistant. Your role is to improve texts by checking spelling, grammar, sentence structure, and clarity. Provide constructive suggestions to enhance the readability and professionalism of the text. Be polite, clear, and concise in your feedback.\r\nAlways respond in Persian (Farsi).', 2000, 'openai', 'gpt-4o', '<i class=\"fa-solid fa-pen-to-square\"></i>', 'text'),
(8, 'خلاصه ساز متن', 'دستیار خلاصه‌ساز متن ابزاری هوشمند است که به شما کمک می‌کند متون طولانی را به صورت خلاصه و مفید دریافت کنید. این دستیار با حفظ نکات کلیدی و مفهوم اصلی، متن را به زبان ساده‌تر و کوتاه‌تر ارائه می‌دهد تا در زمان شما صرفه‌جویی کند و فهم موضوع را آسان‌تر کند. مناسب دانشجویان، پژوهشگران، روزنامه‌نگاران و هر کسی که با حجم زیادی از اطلاعات متنی سروکار دارد.', 'Please summarize the following text: {text} Make sure to keep the important details and main ideas clear and concise.\r\nAlways respond in Persian (Farsi).', 'You are an intelligent assistant specialized in summarizing long texts. Your goal is to extract the key points and main ideas, then present them concisely and clearly without losing the core meaning. Use simple and accessible language so that the summary is easy to understand.', 2000, 'openai', 'gpt-4o', '<i class=\"fa-solid fa-file-lines\"></i>', 'text'),
(9, 'مربی بدنسازی', 'دستیار مربی بدنسازی یک همراه هوشمند برای برنامه‌ریزی تمرینات، ارائه نکات ورزشی، و پاسخ به سوالات مرتبط با بدنسازی و تغذیه است. این دستیار می‌تواند به شما در تعیین برنامه‌های تمرینی مناسب سطح و هدف شما کمک کند، روش‌های صحیح انجام حرکات را توضیح دهد، و راهکارهایی برای حفظ انگیزه و پیشرفت ارائه دهد. مناسب ورزشکاران مبتدی تا حرفه‌ای که می‌خواهند با دانش و برنامه‌ریزی بهتر به اهداف بدنی خود برسند.', 'I want to improve my fitness with a workout plan focused on {subject}. My details are as follows:\r\nAge: {age}\r\nHeight: {height}\r\nWeight: {weight}\r\nFitness level: {fitness_level}\r\nGoal: {goal}\r\nPlease design a workout plan and provide tips on exercise and nutrition tailored to my needs.', 'You are a knowledgeable and supportive fitness coach assistant. Your role is to help users create effective workout plans, explain exercises with proper form, provide nutrition tips, and motivate them to reach their fitness goals. Communicate in a friendly and encouraging tone, tailoring advice to the user’s fitness level and objectives.\r\nAlways respond in Persian (Farsi).', 3000, 'openai', 'gpt-4o', '<i class=\"fa-solid fa-dumbbell\"></i>', 'text'),
(15, 'تولید تصویر', 'تولید تصویر', 'برای تولید تصویر ابتدا پارامترهای زیر را در نظر بگیر\r\n{style}\r\n{lighting}\r\n{environment}\r\n{mood}', '', 2000, 'openai', 'gpt-4o', '<i class=\"fa-solid fa-image\"></i>', 'image'),
(16, 'تولید صدا', 'این دستیار متن وارد شده را به‌صورت صدای طبیعی و روان تبدیل می‌کند.\r\nبرای مثال، می‌توانید متنی را وارد کرده و خروجی آن را به‌صورت فایل صوتی (فرمت MP3) دریافت و پخش کنید.', '', '', 500, 'openai', 'gpt-4o-mini-tts', '<i class=\"fas fa-headphones-alt\"></i>', 'audio'),
(17, 'تحلیلگر اینستاگرام', 'این دستیار پیج اینستاگرام شما را تحلیل می کند و بهترین راه کارها را برای بهینه شدن پیج شما ارائه می دهد.', 'با توجه به تصویر و استانداردهای زیر پیج را تحلیل کن و در آخر نکات و اطلاعات مرتبط با پیج را برای بهبود نتایج به کاربر ارائه کن :\r\nنام کاربری مرتبط و قابل‌جستجو\r\nعکس پروفایل واضح و حرفه‌ای\r\nبیوگرافی جذاب با توضیح مختصر و لینک مرتبط\r\nاستفاده از استوری‌های هایلایت با کاورهای منظم\r\nرعایت تم بصری یکپارچه در فید\r\nانتشار منظم و با کیفیت محتوا\r\nاستفاده از هشتگ‌های مرتبط و هدفمند\r\nتعامل فعال با فالوورها\r\nاستفاده از قابلیت‌های اینستاگرام مانند Reels، IGTV و استوری\r\nتحلیل و بررسی عملکرد با استفاده از Instagram Insights\r\nتدوین استراتژی محتوایی مشخص\r\nداستان‌سرایی منحصربه‌فرد و برندینگ شخصی', 'تو یک تحلیل گر پیج اینستاگرام هستی و راهکارهای استاندارد و بهینه در زمینه بهتر شدن پیج اینستاگرام به کاربران ارائه می دهی', 5000, 'openai', 'gpt-4o', '<i class=\"fas fa-bar-chart\"></i>', 'analyst');

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
('c400414e7b02');

-- --------------------------------------------------------

--
-- Table structure for table `assistants`
--

CREATE TABLE `assistants` (
  `id` int NOT NULL,
  `title` varchar(255) NOT NULL,
  `description` text,
  `domain` varchar(255) NOT NULL,
  `faiss_url` varchar(500) DEFAULT NULL,
  `pkl_url` varchar(500) DEFAULT NULL,
  `excel_url` varchar(500) DEFAULT NULL,
  `status` tinyint(1) DEFAULT NULL,
  `slug` varchar(36) NOT NULL,
  `user_id` varchar(36) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `assistants`
--

INSERT INTO `assistants` (`id`, `title`, `description`, `domain`, `faiss_url`, `pkl_url`, `excel_url`, `status`, `slug`, `user_id`) VALUES
(24, 'دستیار هلو', 'دستیار هلو', 'shetabito.ir', 'static/uploads\\user_92ac38ff-eeeb-461d-b291-a69660b83c46\\vectorstores\\index.faiss', 'static/uploads\\user_92ac38ff-eeeb-461d-b291-a69660b83c46\\vectorstores\\index.pkl', NULL, 1, '49df9f03-c069-4092-9bf0-9cc0cbbbc4ba', '92ac38ff-eeeb-461d-b291-a69660b83c46');

-- --------------------------------------------------------

--
-- Table structure for table `assistant_user_infos`
--

CREATE TABLE `assistant_user_infos` (
  `id` int NOT NULL,
  `assistant_id` int NOT NULL,
  `fullname` varchar(255) NOT NULL,
  `mobile` varchar(20) NOT NULL,
  `email` varchar(255) NOT NULL,
  `slug` varchar(36) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

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

--
-- Dumping data for table `file_uploads`
--

INSERT INTO `file_uploads` (`id`, `user_id`, `filename`, `filepath`, `content_type`, `size`, `uploaded_at`) VALUES
(11, '92ac38ff-eeeb-461d-b291-a69660b83c46', '505e826164455bd9.jfif', 'static/uploads\\user_92ac38ff-eeeb-461d-b291-a69660b83c46\\505e826164455bd9.jfif', 'image/jpeg', 11546, '2025-08-30 11:46:28'),
(12, '92ac38ff-eeeb-461d-b291-a69660b83c46', 'd3645c451356cf7e.jfif', 'static/uploads\\user_92ac38ff-eeeb-461d-b291-a69660b83c46\\d3645c451356cf7e.jfif', 'image/jpeg', 11546, '2025-08-30 11:46:34'),
(21, '92ac38ff-eeeb-461d-b291-a69660b83c46', '0a70adb5149fbcff.png', 'static/uploads\\user_92ac38ff-eeeb-461d-b291-a69660b83c46\\0a70adb5149fbcff.png', 'image/png', 2635927, '2025-09-02 09:29:12'),
(22, '92ac38ff-eeeb-461d-b291-a69660b83c46', '78df7656cbf4a9b9.png', 'static/uploads\\user_92ac38ff-eeeb-461d-b291-a69660b83c46\\78df7656cbf4a9b9.png', 'image/png', 2058410, '2025-09-02 09:32:09'),
(24, '92ac38ff-eeeb-461d-b291-a69660b83c46', '5eef007348788ff1.png', 'static/uploads\\user_92ac38ff-eeeb-461d-b291-a69660b83c46\\5eef007348788ff1.png', 'image/png', 632815, '2025-09-02 11:18:52');

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

--
-- Dumping data for table `otps`
--

INSERT INTO `otps` (`id`, `phone`, `otp_code`, `expire_at`, `created_at`, `is_used`) VALUES
(2, '09191816172', '925445', '2025-08-28 11:17:15', '2025-08-28 11:12:15', 1);

-- --------------------------------------------------------

--
-- Table structure for table `payments`
--

CREATE TABLE `payments` (
  `id` varchar(36) NOT NULL,
  `user_id` varchar(36) NOT NULL,
  `user_subscription_id` varchar(36) DEFAULT NULL,
  `type` enum('wallet_topup','subscription_direct','subscription_wallet') NOT NULL,
  `amount` float NOT NULL,
  `discount_amount` float DEFAULT NULL,
  `discount_code` varchar(256) DEFAULT NULL,
  `transaction_id` varchar(256) DEFAULT NULL,
  `invoice_number` varchar(256) DEFAULT NULL,
  `authority` varchar(256) DEFAULT NULL,
  `description` varchar(256) DEFAULT NULL,
  `status` enum('pending','paid','failed') NOT NULL,
  `created_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `payments`
--

INSERT INTO `payments` (`id`, `user_id`, `user_subscription_id`, `type`, `amount`, `discount_amount`, `discount_code`, `transaction_id`, `invoice_number`, `authority`, `description`, `status`, `created_at`) VALUES
('1bd96310-b4c6-4582-a850-9d33e718cb02', '92ac38ff-eeeb-461d-b291-a69660b83c46', NULL, 'subscription_direct', 30000000, NULL, NULL, '6138001', NULL, 'S0000000000000000000000000000002z6yo', 'خرید بسته هوشمند', 'paid', '2025-08-21 13:31:19'),
('305cb0d7-70fe-4617-b314-c74b9414f32d', '92ac38ff-eeeb-461d-b291-a69660b83c46', NULL, 'subscription_direct', 25000000, NULL, NULL, NULL, NULL, NULL, 'خرید بسته هوشمند', 'pending', '2025-08-21 13:26:59'),
('7276a3fc-bd85-4b25-bb85-547c24dd6598', '92ac38ff-eeeb-461d-b291-a69660b83c46', '856c8959-ed7c-4183-bde9-da0a42b254f8', 'subscription_direct', 25000000, NULL, NULL, '7167601', NULL, 'S000000000000000000000000000000nx1ov', 'خرید بسته هوشمند', 'paid', '2025-08-27 19:01:44'),
('8f52d039-7f69-4062-835c-309b1e937245', '92ac38ff-eeeb-461d-b291-a69660b83c46', NULL, 'subscription_direct', 25000000, NULL, NULL, NULL, NULL, NULL, 'خرید بسته هوشمند', 'pending', '2025-08-21 13:28:44'),
('a9757afd-fb62-4326-9b1e-76b256f3c24f', '92ac38ff-eeeb-461d-b291-a69660b83c46', NULL, 'subscription_direct', 30000000, NULL, NULL, NULL, NULL, NULL, 'خرید بسته هوشمند', 'pending', '2025-08-21 13:20:55'),
('c4b0bb87-a9ea-4dfd-abbf-d5f33eff24a5', '9a0f58d1-c3ac-4572-9741-8cbbf74666d8', '9fc16110-ccac-47a2-a707-45cbe9c84f90', 'subscription_direct', 30000000, NULL, NULL, '7170501', NULL, 'S000000000000000000000000000000y7n2g', 'خرید بسته هوشمند', 'paid', '2025-08-27 19:20:20');

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
(33, 'list_ai_users', 'لیست دستیارهای عمومی کاربر'),
(34, 'upload_storage', 'بارگذاری استوریج');

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
('127.0.0.1', 2, '2025-09-12 10:19:15');

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
(25, '5ffc20756571292cfb5136d69742253c371e6f2f02d7263f3af04695f014819e', '9a0f58d1-c3ac-4572-9741-8cbbf74666d8', 1, '2025-08-27 17:59:01', '2025-09-03 17:59:01'),
(28, 'de0e4024c9d74dd0dd86e4da1197d42785324e5e9632bd800deeb20ffc0585bd', '9a0f58d1-c3ac-4572-9741-8cbbf74666d8', 1, '2025-08-28 11:14:19', '2025-09-04 11:14:19'),
(37, 'd7a2f142f02c6ec076ef9d723839f3e7a05d0eac02edc6f2ece4459a20aad07f', '92ac38ff-eeeb-461d-b291-a69660b83c46', 1, '2025-09-12 10:19:15', '2025-09-19 10:19:15');

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
(1, 19),
(1, 20),
(1, 24),
(1, 21),
(1, 23),
(1, 22),
(1, 26),
(1, 27),
(1, 28),
(2, 29),
(2, 24),
(2, 19),
(2, 20),
(2, 22),
(2, 18),
(1, 31),
(2, 23),
(2, 21),
(2, 32),
(2, 33),
(1, 30),
(1, 18),
(1, 25),
(1, 29),
(1, 33),
(1, 34);

-- --------------------------------------------------------

--
-- Table structure for table `subscription_plans`
--

CREATE TABLE `subscription_plans` (
  `id` varchar(36) NOT NULL,
  `title` varchar(255) NOT NULL,
  `description` varchar(500) DEFAULT NULL,
  `duration_days` int NOT NULL,
  `tokens_allowed` int NOT NULL,
  `amount` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `subscription_plans`
--

INSERT INTO `subscription_plans` (`id`, `title`, `description`, `duration_days`, `tokens_allowed`, `amount`) VALUES
('5237e273-9e24-4349-818c-2bb6e830427a', 'بسته طلایی', '', 10, 2500, '25000000'),
('a6219046-0440-4979-8d75-f3855fbbe391', 'بسته نقره ای', 'ندارد', 30, 3000, '30000000');

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
(134, 'ebc6330f08fe0bfef8d352cf23baed361ffbb67b0d7ec367c59e79faab820223', '9a0f58d1-c3ac-4572-9741-8cbbf74666d8', 1, '2025-08-28 11:58:56'),
(171, '20356f9a6cb64428047833d2051a53a4a26ad40a0eb3f9b40be20a32ae16b49a', '92ac38ff-eeeb-461d-b291-a69660b83c46', 1, '2025-09-12 10:59:59');

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
('92ac38ff-eeeb-461d-b291-a69660b83c46', 'admin@gmail.com', '', '$2b$12$f5cbzLZQ33yYqowo2URA0uFD8jrZd0E6WeDvip3Z1tZbpc97HuO4i'),
('9a0f58d1-c3ac-4572-9741-8cbbf74666d8', NULL, '09191816172', NULL);

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
('92ac38ff-eeeb-461d-b291-a69660b83c46', 1),
('9a0f58d1-c3ac-4572-9741-8cbbf74666d8', 2);

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
('856c8959-ed7c-4183-bde9-da0a42b254f8', '92ac38ff-eeeb-461d-b291-a69660b83c46', '2025-08-27 19:01:48', '2025-08-27 19:01:48', '5237e273-9e24-4349-818c-2bb6e830427a', 0),
('9fc16110-ccac-47a2-a707-45cbe9c84f90', '9a0f58d1-c3ac-4572-9741-8cbbf74666d8', '2025-08-27 19:20:23', '2025-08-27 19:20:23', 'a6219046-0440-4979-8d75-f3855fbbe391', 1);

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
('9bcf9b3b-55ca-4862-a618-1a5618e061a7', '9a0f58d1-c3ac-4572-9741-8cbbf74666d8', 47934, '2025-08-27 19:20:23'),
('dd3289e2-0132-49ea-a4b9-93a1ceb719d5', '92ac38ff-eeeb-461d-b291-a69660b83c46', 138785, '2025-08-21 13:31:21');

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
  ADD KEY `user_id` (`user_id`),
  ADD KEY `ix_assistants_id` (`id`);

--
-- Indexes for table `assistant_user_infos`
--
ALTER TABLE `assistant_user_infos`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `slug` (`slug`),
  ADD KEY `assistant_id` (`assistant_id`),
  ADD KEY `ix_assistant_user_infos_id` (`id`);

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
-- Indexes for table `payments`
--
ALTER TABLE `payments`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `ix_payments_id` (`id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `user_subscription_id` (`user_subscription_id`);

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
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=112;

--
-- AUTO_INCREMENT for table `ai_inputs`
--
ALTER TABLE `ai_inputs`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=220;

--
-- AUTO_INCREMENT for table `ai_models`
--
ALTER TABLE `ai_models`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=19;

--
-- AUTO_INCREMENT for table `assistants`
--
ALTER TABLE `assistants`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=25;

--
-- AUTO_INCREMENT for table `assistant_user_infos`
--
ALTER TABLE `assistant_user_infos`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `file_uploads`
--
ALTER TABLE `file_uploads`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=26;

--
-- AUTO_INCREMENT for table `otps`
--
ALTER TABLE `otps`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `permissions`
--
ALTER TABLE `permissions`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=35;

--
-- AUTO_INCREMENT for table `refresh_tokens`
--
ALTER TABLE `refresh_tokens`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=38;

--
-- AUTO_INCREMENT for table `roles`
--
ALTER TABLE `roles`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `tokens`
--
ALTER TABLE `tokens`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=172;

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
-- Constraints for table `assistants`
--
ALTER TABLE `assistants`
  ADD CONSTRAINT `assistants_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);

--
-- Constraints for table `assistant_user_infos`
--
ALTER TABLE `assistant_user_infos`
  ADD CONSTRAINT `assistant_user_infos_ibfk_1` FOREIGN KEY (`assistant_id`) REFERENCES `assistants` (`id`);

--
-- Constraints for table `file_uploads`
--
ALTER TABLE `file_uploads`
  ADD CONSTRAINT `file_uploads_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);

--
-- Constraints for table `payments`
--
ALTER TABLE `payments`
  ADD CONSTRAINT `payments_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `payments_ibfk_2` FOREIGN KEY (`user_subscription_id`) REFERENCES `user_subscriptions` (`id`);

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
