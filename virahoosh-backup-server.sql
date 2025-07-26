-- MySQL dump 10.13  Distrib 8.0.42, for Linux (x86_64)
--
-- Host: localhost    Database: viraapi
-- ------------------------------------------------------
-- Server version	8.0.42-0ubuntu0.24.04.2

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `ai_archives`
--

DROP TABLE IF EXISTS `ai_archives`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ai_archives` (
  `id` int NOT NULL AUTO_INCREMENT,
  `ai_model_id` int DEFAULT NULL,
  `prompt` text,
  `response` text,
  `created_at` datetime DEFAULT NULL,
  `title` varchar(255) NOT NULL,
  `type` varchar(20) DEFAULT NULL,
  `url` varchar(512) DEFAULT NULL,
  `user_id` varchar(36) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `ai_model_id` (`ai_model_id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `ai_archives_ibfk_1` FOREIGN KEY (`ai_model_id`) REFERENCES `ai_models` (`id`),
  CONSTRAINT `ai_archives_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=85 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ai_archives`
--

LOCK TABLES `ai_archives` WRITE;
/*!40000 ALTER TABLE `ai_archives` DISABLE KEYS */;
INSERT INTO `ai_archives` VALUES (73,3,'I’m posting about بازار ترید on Instagram. Can you help me write a caption and suggest the best hashtags for it?','البته! در ادامه یک کپشن جذاب برای پست بازار ترید و هشتگ‌های مناسب آورده‌ام:\n\nکپشن:  \nبازار ترید، دنیایی پر از فرصت‌ها و چالش‌ها! 🚀  \nاگر دنبال رشد مالی و یادگیری استراتژی‌های موفق هستی، اینجا جای توست. با ما همراه باش تا بهترین نکات و تحلیل‌ها رو با هم بررسی کنیم. 💹  \nهمیشه به یاد داشته باش، صبر و دانش کلید موفقیته! 🔑  \n#ترید_موفق #بازار_مالی #سرمایه_گذاری\n\nهشتگ‌ها:  \n#بازار_ترید #تریدینگ #فارکس #کریپتوکارنسی #سرمایه_گذاری #تحلیل_فنی #معامله_گری #بورس #رمزارز #آموزش_ترید #ترید_ایران #بیتکوین #ارزدیجیتال #کسب_درآمد #بازار_مالی\n\nاگر دوست داری، می‌تونم کپشن برای نوع خاصی از پست مثل ریلز یا کاروسل هم آماده کنم.','2025-07-24 12:08:00','','text','','92ac38ff-eeeb-461d-b291-a69660b83c46'),(74,3,'I’m posting about بازار ترید on Instagram. Can you help me write a caption and suggest the best hashtags for it? سپس با توجه به توضیحات تصویر را تولید کن، توضیحات: بازار ترید',NULL,'2025-07-24 12:08:00','بازار ترید','image','https://oaidalleapiprodscus.blob.core.windows.net/private/org-belyCAEcntcV8ehT953Wxjm4/user-6y5hPqhFu8eVoQd21Er4f9nn/img-ak9SXi2aNfsQXBGBdk7GgkvK.png?st=2025-07-24T07%3A38%3A00Z&se=2025-07-24T09%3A38%3A00Z&sp=r&sv=2024-08-04&sr=b&rscd=inline&rsct=image/png&skoid=cc612491-d948-4d2e-9821-2683df3719f5&sktid=a48cca56-e6da-484e-a814-9c849652bcb3&skt=2025-07-23T14%3A17%3A18Z&ske=2025-07-24T14%3A17%3A18Z&sks=b&skv=2024-08-04&sig=qBtehoT8TOmaLGGTZC3ueMfzGLvCrK%2BS3us1KNRkvBU%3D','92ac38ff-eeeb-461d-b291-a69660b83c46'),(75,3,'As an Instagram SEO specialist, generate output for a [topic] post based on these parameters:\r\nCaption: Combination of [informative/storytelling/CTA]\r\nHashtags: Density of [15-20% high-volume, 60% medium-range, 20% niche]\r\nOptimized for 2024 algorithm','لطفاً موضوع (topic) پست مورد نظر خود را بفرمایید تا بتوانم کپشن و هشتگ‌های مناسب با توجه به پارامترهای شما برایتان تولید کنم.','2025-07-24 12:39:29','','text','','92ac38ff-eeeb-461d-b291-a69660b83c46'),(76,3,'As an Instagram SEO specialist, generate output for a [topic] post based on these parameters:\r\nCaption: Combination of [informative/storytelling/CTA]\r\nHashtags: Density of [15-20% high-volume, 60% medium-range, 20% niche]\r\nOptimized for 2024 algorithm سپس با توجه به توضیحات تصویر را تولید کن، توضیحات: نحوه درست کردن نیمرو',NULL,'2025-07-24 12:39:29','نحوه درست کردن نیمرو','image','https://oaidalleapiprodscus.blob.core.windows.net/private/org-belyCAEcntcV8ehT953Wxjm4/user-6y5hPqhFu8eVoQd21Er4f9nn/img-JcwdfL1Ip0q8pJG9gZi5FAAJ.png?st=2025-07-24T08%3A09%3A29Z&se=2025-07-24T10%3A09%3A29Z&sp=r&sv=2024-08-04&sr=b&rscd=inline&rsct=image/png&skoid=cc612491-d948-4d2e-9821-2683df3719f5&sktid=a48cca56-e6da-484e-a814-9c849652bcb3&skt=2025-07-23T23%3A03%3A21Z&ske=2025-07-24T23%3A03%3A21Z&sks=b&skv=2024-08-04&sig=cgCCrYlYzUOynINd2NFOBdD7b7Wo7H849mX0bs7ZArc%3D','92ac38ff-eeeb-461d-b291-a69660b83c46'),(77,3,'As an Instagram SEO specialist, generate output for a {topic} post based on these parameters:\r\nCaption: Combination of [informative/storytelling/CTA]\r\nType Content : پست\r\nHashtags: Density of [15-20% high-volume, 60% medium-range, 20% niche]\r\nOptimized for 2024 algorithm','لطفاً موضوع (topic) مورد نظرتان را بفرمایید تا بتوانم کپشن و هشتگ‌های مناسب را برای پست اینستاگرام شما آماده کنم.','2025-07-24 12:48:57','','text','','92ac38ff-eeeb-461d-b291-a69660b83c46'),(78,3,'As an Instagram SEO specialist, generate output for a {topic} post based on these parameters:\r\nCaption: Combination of [informative/storytelling/CTA]\r\nType Content : پست\r\nHashtags: Density of [15-20% high-volume, 60% medium-range, 20% niche]\r\nOptimized for 2024 algorithm سپس با توجه به توضیحات تصویر را تولید کن، توضیحات: نحوه درست کردن نیمرو',NULL,'2025-07-24 12:48:57','نحوه درست کردن نیمرو','image','https://oaidalleapiprodscus.blob.core.windows.net/private/org-belyCAEcntcV8ehT953Wxjm4/user-6y5hPqhFu8eVoQd21Er4f9nn/img-vOLvbghTo2Yd1xTnY8Xq5anL.png?st=2025-07-24T08%3A18%3A56Z&se=2025-07-24T10%3A18%3A56Z&sp=r&sv=2024-08-04&sr=b&rscd=inline&rsct=image/png&skoid=cc612491-d948-4d2e-9821-2683df3719f5&sktid=a48cca56-e6da-484e-a814-9c849652bcb3&skt=2025-07-24T06%3A28%3A20Z&ske=2025-07-25T06%3A28%3A20Z&sks=b&skv=2024-08-04&sig=/8dT39CV9Cht6El0tSKDRPSsBakXvFvuPGrmNr6XUik%3D','92ac38ff-eeeb-461d-b291-a69660b83c46'),(79,3,'As an Instagram SEO specialist, generate output for a {topic} post based on these parameters:\r\nCaption: Combination of [informative/storytelling/CTA]\r\nType Content : پست\r\nHashtags: Density of [15-20% high-volume, 60% medium-range, 20% niche]\r\nOptimized for 2024 algorithm','لطفاً موضوع (topic) مورد نظر خود را بفرمایید تا بتوانم کپشن و هشتگ‌های مناسب برای پست اینستاگرام شما آماده کنم.','2025-07-24 12:52:57','','text','','92ac38ff-eeeb-461d-b291-a69660b83c46'),(80,3,'As an Instagram SEO specialist, generate output for a {topic} post based on these parameters:\r\nCaption: Combination of [informative/storytelling/CTA]\r\nType Content : پست\r\nHashtags: Density of [15-20% high-volume, 60% medium-range, 20% niche]\r\nOptimized for 2024 algorithm سپس با توجه به توضیحات تصویر را تولید کن، توضیحات: نحوه درست کردن نیمرو',NULL,'2025-07-24 12:52:57','نحوه درست کردن نیمرو','image','https://oaidalleapiprodscus.blob.core.windows.net/private/org-belyCAEcntcV8ehT953Wxjm4/user-6y5hPqhFu8eVoQd21Er4f9nn/img-ESOf1fGsfo9OHRBF0v2oN93m.png?st=2025-07-24T08%3A22%3A57Z&se=2025-07-24T10%3A22%3A57Z&sp=r&sv=2024-08-04&sr=b&rscd=inline&rsct=image/png&skoid=cc612491-d948-4d2e-9821-2683df3719f5&sktid=a48cca56-e6da-484e-a814-9c849652bcb3&skt=2025-07-23T17%3A19%3A54Z&ske=2025-07-24T17%3A19%3A54Z&sks=b&skv=2024-08-04&sig=CU9XevvPvy0muMniq53Jn1Yun8cMChV1hNLYVWX16ec%3D','92ac38ff-eeeb-461d-b291-a69660b83c46'),(81,3,'As an Instagram SEO specialist, generate output for a نحوه درست کردن نیمرو post based on these parameters:\r\nCaption: Combination of [informative/storytelling/CTA]\r\nType Content : پست\r\nHashtags: Density of [15-20% high-volume, 60% medium-range, 20% niche]\r\nOptimized for 2024 algorithm','کپشن:  \nنیمرو یکی از ساده‌ترین و خوشمزه‌ترین صبحانه‌هاست که هر کسی باید روش درست کردنش رو بلد باشه! 🥚✨ امروز می‌خوام مرحله به مرحله باهاتون طرز تهیه نیمروی عالی رو بگم که زرده‌اش نرم و سفیده‌اش کاملاً پخته باشه.  \nاول تابه رو با کمی روغن داغ کنید، تخم‌مرغ رو با دقت بشکنید و داخل تابه بریزید. حرارت رو کم کنید تا نیمرو به آرامی بپزه و زرده‌اش آب‌دار بمونه. می‌تونید کمی نمک، فلفل و حتی سبزیجات تازه اضافه کنید تا طعمش بهتر بشه.  \nشما چطور نیمرو درست می‌کنید؟ اگه نکته خاصی دارید، حتما تو کامنت‌ها بنویسید! 👇  \n#نیمرو #صبحانه_سالم #طرز_تهیه_نیمرو #آشپزی_خانگی #نیمروی_خوشمزه #صبحانه_ایرانی #دستور_آشپزی #تخم_مرغ #آشپزی_ساده #نیمرو_نرمال #آشپزی_راحت #صبحانه_سریع #غذای_سالم #نیمروی_آب_دار #صبحانه_خوشمزه #آموزش_آشپزی #ایده_صبحانه #غذای_خانگی #نیمرو_2024 #آشپزی_مدرن  \n\nاین ترکیب هشتگ‌ها، هم محبوبیت بالا و هم تخصصی بودن موضوع رو حفظ می‌کنه و با الگوریتم ۲۰۲۴ اینستاگرام سازگاره تا پست شما بیشتر دیده بشه. موفق باشید! 🌟','2025-07-24 12:54:20','','text','','92ac38ff-eeeb-461d-b291-a69660b83c46'),(82,3,'As an Instagram SEO specialist, generate output for a نحوه درست کردن نیمرو post based on these parameters:\r\nCaption: Combination of [informative/storytelling/CTA]\r\nType Content : پست\r\nHashtags: Density of [15-20% high-volume, 60% medium-range, 20% niche]\r\nOptimized for 2024 algorithm سپس با توجه به توضیحات تصویر را تولید کن، توضیحات: نحوه درست کردن نیمرو',NULL,'2025-07-24 12:54:20','نحوه درست کردن نیمرو','image','https://oaidalleapiprodscus.blob.core.windows.net/private/org-belyCAEcntcV8ehT953Wxjm4/user-6y5hPqhFu8eVoQd21Er4f9nn/img-2ze6iO2MJ7GSI0OyIJwdynWS.png?st=2025-07-24T08%3A24%3A19Z&se=2025-07-24T10%3A24%3A19Z&sp=r&sv=2024-08-04&sr=b&rscd=inline&rsct=image/png&skoid=cc612491-d948-4d2e-9821-2683df3719f5&sktid=a48cca56-e6da-484e-a814-9c849652bcb3&skt=2025-07-24T09%3A24%3A19Z&ske=2025-07-25T09%3A24%3A19Z&sks=b&skv=2024-08-04&sig=9igSAPikHwHKzO/kUIm3eEZ3xgqSrdbway1t34v98Ms%3D','92ac38ff-eeeb-461d-b291-a69660b83c46'),(83,3,'As an Instagram SEO specialist, generate output for a نحوه درست کردن نیمرو post based on these parameters:\r\nCaption: Combination of [informative/storytelling/CTA]\r\nType Content : استوری\r\nHashtags: Density of [15-20% high-volume, 60% medium-range, 20% niche]\r\nOptimized for 2025 algorithm','📲 استوری امروز: طرز تهیه نیمروی خوشمزه و سریع! 🍳\n\nنیمرو همیشه یکی از ساده‌ترین و خوشمزه‌ترین صبحانه‌هاست، اما نکته‌های کوچکی هست که می‌تونه طعمش رو متفاوت کنه. مثلاً استفاده از کره به جای روغن معمولی یا اضافه کردن کمی فلفل سیاه تازه آسیاب شده. من این روش رو امتحان کردم و نتیجه عالی بود! شما هم امتحان کنید و به من بگید چطور شد. \n\n👇 اگر دوست دارید ویدئوی کامل طرز تهیه نیمرو رو ببینید، به من پیام بدید یا استوری رو ذخیره کنید!\n\n#نیمرو #صبحانه_سالم #طرز_تهیه_نیمرو #آشپزی_خانگی #صبحانه_سریع #آشپزی_ساده #نیمروی_خوشمزه #دستور_آشپزی #صبحانه_مغذی #نیمرو_ساده #خوراکی_سالم #آشپزی_ایرانی #نیمرو_خانگی #آشپزی_2025 #نیمرو_خاص #آشپزی_مدرن #صبحانه_2025 #نیمرو_فوری #آشپزی_آسان #تکنیک_آشپزی\n\nاین ترکیب هشتگ‌ها به شما کمک می‌کنه تا پست استوری نیمرو شما با الگوریتم ۲۰۲۵ اینستاگرام هماهنگ باشه و هم مخاطب‌های عمومی و هم علاقه‌مندان خاص‌تر رو جذب کنه. موفق باشید! 🍳✨','2025-07-24 12:55:37','','text','','92ac38ff-eeeb-461d-b291-a69660b83c46'),(84,3,'As an Instagram SEO specialist, generate output for a نحوه درست کردن نیمرو post based on these parameters:\r\nCaption: Combination of [informative/storytelling/CTA]\r\nType Content : استوری\r\nHashtags: Density of [15-20% high-volume, 60% medium-range, 20% niche]\r\nOptimized for 2025 algorithm سپس با توجه به توضیحات تصویر را تولید کن، توضیحات: نحوه درست کردن نیمرو',NULL,'2025-07-24 12:55:37','نحوه درست کردن نیمرو','image','https://oaidalleapiprodscus.blob.core.windows.net/private/org-belyCAEcntcV8ehT953Wxjm4/user-6y5hPqhFu8eVoQd21Er4f9nn/img-WoqDNUDXM5kxMMr4TXVnuqiy.png?st=2025-07-24T08%3A25%3A36Z&se=2025-07-24T10%3A25%3A36Z&sp=r&sv=2024-08-04&sr=b&rscd=inline&rsct=image/png&skoid=cc612491-d948-4d2e-9821-2683df3719f5&sktid=a48cca56-e6da-484e-a814-9c849652bcb3&skt=2025-07-23T17%3A41%3A52Z&ske=2025-07-24T17%3A41%3A52Z&sks=b&skv=2024-08-04&sig=xBr4IfXDLp/rckuIEY/gRy/o5b9FjcagseSMPESXqaQ%3D','92ac38ff-eeeb-461d-b291-a69660b83c46');
/*!40000 ALTER TABLE `ai_archives` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ai_inputs`
--

DROP TABLE IF EXISTS `ai_inputs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ai_inputs` (
  `id` int NOT NULL AUTO_INCREMENT,
  `ai_model_id` int NOT NULL,
  `title` varchar(255) NOT NULL,
  `name` varchar(100) NOT NULL,
  `input_type` varchar(50) NOT NULL,
  `options` text,
  PRIMARY KEY (`id`),
  KEY `ai_model_id` (`ai_model_id`),
  KEY `ix_ai_inputs_id` (`id`),
  CONSTRAINT `ai_inputs_ibfk_1` FOREIGN KEY (`ai_model_id`) REFERENCES `ai_models` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=196 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ai_inputs`
--

LOCK TABLES `ai_inputs` WRITE;
/*!40000 ALTER TABLE `ai_inputs` DISABLE KEYS */;
INSERT INTO `ai_inputs` VALUES (104,6,'توضیحات','description','textarea',NULL),(105,5,'نوع خودرو','vehicle_type','text',NULL),(106,5,'برند و مدل','brand_model','text',NULL),(107,5,'سال ساخت','manufacture_year','text',NULL),(108,5,'نوع سوخت','fuel_type','text',NULL),(109,5,'مسافت پیموده شده فعلی','current_mileage','text',NULL),(110,5,'آخرین سرویس عمومی (تاریخ)','last_general_service_date','text',NULL),(111,5,'آخرین سرویس عمومی (کیلومتر)','last_general_service_km','text',NULL),(112,5,'آخرین تعویض روغن (تاریخ)','last_oil_change_date','text',NULL),(113,5,'آخرین تعویض روغن (کیلومتر)','last_oil_change_km','text',NULL),(114,5,'آخرین تعویض فیلتر (تاریخ)','last_filter_change_date','text',NULL),(115,5,'آخرین تعویض فیلتر (کیلومتر)','last_filter_change_km','text',NULL),(116,5,'آخرین تعویض (ترمز، باتری، تسمه تایم و غیره)','last_replacement_info','textarea',NULL),(117,5,'سفرهای طولانی یا استفاده سنگین اخیر (تاریخ تقریبی و توضیحات)','long_trip_info','textarea',NULL),(118,4,'موضوع کتاب','subject','text',NULL),(120,2,'عنوان بیماری','subject','text',NULL),(122,7,'متن','text','textarea',NULL),(123,8,'متن','text','textarea',NULL),(167,15,'سبک تصویر','style','select','[\"سینمایی\", \"کارتونی\", \"فانتزی\", \"شیشه ای\", \"کلاسیک\", \"نقاشی آبرنگ\", \"رئال\", \"نئون\"]'),(168,15,'نور','lighting','radiobutton','[\"نور نرم\", \"نور دراماتیک\", \"نور پس‌زمینه\", \"نور ساعت طلایی\", \"سایه‌های شدید\", \"نور نئون\"]'),(169,15,'محیط','environment','radiobutton','[\"جنگل مه‌آلود\", \"خیابان شلوغ شهر\", \"کتابخانه ساکت\", \"صحنه زیر آب\", \"اتاق دنج با نور گرم\"]'),(170,15,'فضا','mood','select','[\"جو رمزآلود\", \"آرام و صلح‌آمیز\", \"تاریک و وهم‌آور\", \"روشن و شاد\", \"فضای باز وسیع\"]'),(181,9,'سن','age','number',NULL),(182,9,'قد','height','number',NULL),(183,9,'وزن','weight','number',NULL),(184,9,'سطح تناسب اندام','fitness_level','select','[\"مبتدی\", \"متوسط\", \"پیشرفته\"]'),(185,9,'هدف','goal','select','[\"چاقی\", \"لاغری\", \"تناسب اندام\", \"عضله سازی\"]'),(186,1,'موضوع','subject','text',NULL),(194,3,'نوع محتوا','type','radiobutton','[\"پست\", \"استوری\"]'),(195,3,'موضوع','topic','text',NULL);
/*!40000 ALTER TABLE `ai_inputs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ai_models`
--

DROP TABLE IF EXISTS `ai_models`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ai_models` (
  `id` int NOT NULL AUTO_INCREMENT,
  `title` varchar(255) NOT NULL,
  `description` text,
  `prompt` text,
  `system_prompt` text,
  `max_tokens` int DEFAULT '500',
  `provider` varchar(255) NOT NULL,
  `model` varchar(255) NOT NULL,
  `icon` varchar(255) DEFAULT NULL,
  `type` enum('image','text','text_image','video','audio','vision','speech_audio') NOT NULL,
  PRIMARY KEY (`id`),
  KEY `ix_ai_models_id` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ai_models`
--

LOCK TABLES `ai_models` WRITE;
/*!40000 ALTER TABLE `ai_models` DISABLE KEYS */;
INSERT INTO `ai_models` VALUES (1,'آشپز','دستیار آشپز یک متخصص در حوزه آشپزی است که هدف اصلی او کمک به شما در تهیه، پخت و سرو غذاهاست. این دستیار به موضوعات مربوط به آشپزی، دستور پخت، مواد اولیه، روش‌های پخت، ترفندهای آشپزی و نکات تغذیه‌ای مربوط به غذاها پاسخ می‌دهد.','Generate a comprehensive and well-structured article in Persian (Farsi) about the topic of {subject}.','You are a chef and must only talk about cooking.  \r\nDo not discuss any other topics.  \r\nAlways respond in Persian (Farsi).',16000,'deepseek','deepseek-chat','<i class=\"fa-solid fa-kitchen-set\"></i>','text'),(2,'چشم پزشک','دستیار چشم‌پزشک یک ابزار هوشمند برای راهنمایی بیماران در مسیر مراجعه، معاینه و پیگیری درمان‌های چشمی است. این دستیار با پاسخ به سوالات رایج، یادآوری نوبت‌ها و ارائه اطلاعات کاربردی، تجربه‌ای سریع‌تر و آگاهانه‌تر فراهم می‌کند. با زبان ساده و قابل فهم، همیشه کنار شماست تا در مسیر سلامت چشم، همراهتان باشد.','Can you explain {subject} in simple terms? I want to understand what it is, why it matters, and what I should do if I experience it.','You are a helpful and knowledgeable virtual ophthalmology assistant. Your role is to explain eye-related topics clearly, simply, and accurately to patients or their families. Use friendly, non-technical language, avoid medical jargon unless necessary, and offer useful tips or warnings if applicable. You are supportive, empathetic, and focused on making complex information easy to understand for non-experts.\r\nAlways respond in Persian (Farsi).',2000,'openai','gpt-4.1-mini','<i class=\"fa-regular fa-eye\"></i>','text'),(3,'اینستاگرام','دستیار اینستاگرام یک ابزار هوشمند برای تولید محتوا و انتخاب هشتگ‌های حرفه‌ای است. این دستیار به شما کمک می‌کند تا برای پست‌های خود کپشن‌های جذاب بنویسید، هشتگ‌های مرتبط و پربازده پیدا کنید، و محتوای خود را برای الگوریتم اینستاگرام بهینه‌سازی کنید.\r\nبا زبان ساده و رویکردی خلاق، این دستیار مخصوص تمام افرادی‌ست که می‌خواهند در اینستاگرام بهتر دیده شوند.\r\nاز فروشگاه‌های آنلاین و بلاگرها گرفته تا کسب‌وکارهای کوچک و برندهای شخصی.','As an Instagram SEO specialist, generate output for a {topic} post based on these parameters:\r\nCaption: Combination of [informative/storytelling/CTA]\r\nType Content : {type}\r\nHashtags: Density of [15-20% high-volume, 60% medium-range, 20% niche]\r\nOptimized for 2025 algorithm','You are an AI assistant specialized in Instagram content creation and hashtag strategy. Your job is to help users write engaging captions, generate relevant hashtags, and optimize their posts for reach and engagement. Use a friendly, modern tone that matches Instagram trends. Always consider the type of content (e.g. photo, reel, carousel) and the target audience. Provide hashtags that are relevant, balanced (between popular and niche), and in line with the topic\r\nAlways respond in Persian (Farsi)',2000,'openai','gpt-4.1-mini','<i class=\"fa-brands fa-instagram\"></i>','text_image'),(4,'نویسنده کتاب','دستیار نویسنده کتاب یک همراه هوشمند برای نویسندگان است که در همه مراحل خلق کتاب، از ایده‌پردازی و طرح‌ریزی گرفته تا نوشتن، ویرایش و سازماندهی محتوا، به شما کمک می‌کند. این دستیار می‌تواند با ارائه پیشنهادات نوشتاری، اصلاح جملات، ساختاردهی فصل‌ها و پاسخ به سوالات شما، فرآیند نوشتن کتاب را ساده‌تر و خلاقانه‌تر کند.\r\nمناسب نویسندگان تازه‌کار و حرفه‌ای که می‌خواهند داستان یا متن خود را به بهترین شکل ممکن بیان کنند.','I’m writing a book about {subject}. Can you help me brainstorm ideas, outline chapters, or improve my writing on this topic?','You are a creative and knowledgeable book writing assistant. Your role is to help authors at every stage of the writing process, including brainstorming ideas, outlining chapters, improving writing style, editing text, and organizing content logically. Use clear, encouraging, and constructive language. Provide practical tips and examples to help the writer express their ideas better and maintain coherence throughout the manuscript.\r\nAlways respond in Persian (Farsi).',2000,'deepseek','deepseek-chat','<i class=\"fa-solid fa-feather\"></i>','text'),(5,'مدیریت خودرو','دستیار مدیریت خودرو یک ابزار هوشمند برای ثبت اطلاعات کامل وسیله نقلیه و برنامه‌ریزی سرویس‌های دوره‌ای است. با وارد کردن جزئیاتی مانند نوع خودرو، مدل، سال ساخت، نوع سوخت، و کیلومتر فعلی، این دستیار به شما کمک می‌کند زمان مناسب برای تعویض روغن، فیلترها، لنت ترمز، باتری، تسمه تایم و سایر سرویس‌ها را یادآوری کند. همچنین می‌توانید با ثبت اطلاعات سفرهای طولانی، میزان استهلاک خودرو را دقیق‌تر مدیریت کنید. این دستیار مناسب رانندگان شخصی، مدیران ناوگان، و تمام کسانی است که به نگهداری بهینه خودرو اهمیت می‌دهند.','I want to register a vehicle and track its maintenance.\r\nHere are the details:\r\nVehicle Type: {vehicle_type}\r\nBrand & Model: {brand_model}\r\nYear of Manufacture: {manufacture_year}\r\nFuel Type: {fuel_type}\r\nCurrent Mileage: {current_mileage}\r\n🛠 Maintenance Info\r\nLast General Service (date & km): {last_general_service_date}, {last_general_service_km}\r\nLast Oil Change (date & km): {last_oil_change_date}, {last_oil_change_km}\r\nLast Filter Change (date & km): {last_filter_change_date}, {last_filter_change_km}\r\nLast Replacement (brakes, battery, timing belt, etc.): {last_replacement_info}\r\nRecent Long Trips or Heavy Use (approx. date & description): {long_trip_info}\r\nCan you help me store this and set reminders for future services?','You are an intelligent assistant designed to help users manage and track vehicle information and maintenance schedules. Collect and understand details about each vehicle including type, brand, model, fuel type, mileage, and key maintenance events. When possible, use this data to recommend service reminders or estimate wear based on usage. Be accurate, concise, and helpful. If certain information (like VIN or license plate) is not provided, handle gracefully but note that accuracy may be reduced.\r\nAlways respond in Persian (Farsi).',2000,'deepseek','deepseek-chat','<i class=\"fa-solid fa-car\"></i>','text'),(6,'مشاور حقوقی','دستیار مشاور حقوقی یک ابزار هوشمند است که با تمرکز بر قوانین جمهوری اسلامی ایران، به شما کمک می‌کند مسائل حقوقی را به زبان ساده و قابل فهم درک کنید. این دستیار قادر است توضیحاتی درباره حقوق، تکالیف، فرآیندها و راهکارهای قانونی ارائه دهد اما نمی‌تواند جایگزین وکیل رسمی شود. اگر موضوعی نیازمند مشاوره تخصصی و وکالت باشد، شما را به مراجعه به وکیل مجاز راهنمایی می‌کند. این دستیار مناسب عموم مردم است که می‌خواهند حقوق خود را بهتر بشناسند و تصمیمات بهتری بگیرند.','Please explain the following topic in simple and clear terms: {description}. I want to understand the main points, important details, and any necessary steps or precautions related to it.','You are a legal assistant specialized in Iranian law. Your task is to provide general legal guidance based on the laws and regulations of the Islamic Republic of Iran. You explain legal topics, terms, and procedures in clear and simple Persian (Farsi), suitable for the general public. You do not offer formal legal representation or replace a licensed attorney, but you help users understand their rights, obligations, and available legal pathways. If a topic requires official legal intervention, recommend the user consult a licensed lawyer in Iran.Always respond in Persian (Farsi).',2000,'openai','gpt-4o','<i class=\"fa-solid fa-scale-balanced\"></i>','text'),(7,'ویراستار','دستیار ویراستار یک ابزار هوشمند برای کمک به بهبود کیفیت متون شماست. این دستیار می‌تواند املای کلمات، نگارش جملات، دستور زبان، ساختار پاراگراف‌ها و روان بودن متن را بررسی و اصلاح کند. هدف آن ارائه پیشنهادهای دقیق و کاربردی برای ارتقای متن شما، چه در حوزه ادبیات، مقاله‌نویسی، گزارش یا هر نوع نوشته دیگر است. مناسب نویسندگان، دانشجویان، و هر کسی که می‌خواهد متنی حرفه‌ای‌تر و خواناتر داشته باشد.','Please review and improve the following text: {text} Focus on spelling, grammar, sentence flow, and overall clarity.','You are a smart and helpful editing assistant. Your role is to improve texts by checking spelling, grammar, sentence structure, and clarity. Provide constructive suggestions to enhance the readability and professionalism of the text. Be polite, clear, and concise in your feedback.\r\nAlways respond in Persian (Farsi).',2000,'openai','gpt-4o','<i class=\"fa-solid fa-pen-to-square\"></i>','text'),(8,'خلاصه ساز متن','دستیار خلاصه‌ساز متن ابزاری هوشمند است که به شما کمک می‌کند متون طولانی را به صورت خلاصه و مفید دریافت کنید. این دستیار با حفظ نکات کلیدی و مفهوم اصلی، متن را به زبان ساده‌تر و کوتاه‌تر ارائه می‌دهد تا در زمان شما صرفه‌جویی کند و فهم موضوع را آسان‌تر کند. مناسب دانشجویان، پژوهشگران، روزنامه‌نگاران و هر کسی که با حجم زیادی از اطلاعات متنی سروکار دارد.','Please summarize the following text: {text} Make sure to keep the important details and main ideas clear and concise.\r\nAlways respond in Persian (Farsi).','You are an intelligent assistant specialized in summarizing long texts. Your goal is to extract the key points and main ideas, then present them concisely and clearly without losing the core meaning. Use simple and accessible language so that the summary is easy to understand.',2000,'openai','gpt-4o','<i class=\"fa-solid fa-file-lines\"></i>','text'),(9,'مربی بدنسازی','دستیار مربی بدنسازی یک همراه هوشمند برای برنامه‌ریزی تمرینات، ارائه نکات ورزشی، و پاسخ به سوالات مرتبط با بدنسازی و تغذیه است. این دستیار می‌تواند به شما در تعیین برنامه‌های تمرینی مناسب سطح و هدف شما کمک کند، روش‌های صحیح انجام حرکات را توضیح دهد، و راهکارهایی برای حفظ انگیزه و پیشرفت ارائه دهد. مناسب ورزشکاران مبتدی تا حرفه‌ای که می‌خواهند با دانش و برنامه‌ریزی بهتر به اهداف بدنی خود برسند.','I want to improve my fitness with a workout plan focused on {subject}. My details are as follows:\r\nAge: {age}\r\nHeight: {height}\r\nWeight: {weight}\r\nFitness level: {fitness_level}\r\nGoal: {goal}\r\nPlease design a workout plan and provide tips on exercise and nutrition tailored to my needs.','You are a knowledgeable and supportive fitness coach assistant. Your role is to help users create effective workout plans, explain exercises with proper form, provide nutrition tips, and motivate them to reach their fitness goals. Communicate in a friendly and encouraging tone, tailoring advice to the user’s fitness level and objectives.\r\nAlways respond in Persian (Farsi).',3000,'deepseek','deepseek-chat','<i class=\"fa-solid fa-dumbbell\"></i>','text'),(15,'تولید تصویر','تولید تصویر','برای تولید تصویر ابتدا پارامترهای زیر را در نظر بگیر\r\n{style}\r\n{lighting}\r\n{environment}\r\n{mood}','',2000,'openai','gpt-4o','<i class=\"fa-solid fa-image\"></i>','image'),(16,'تولید صدا','این دستیار متن وارد شده را به‌صورت صدای طبیعی و روان تبدیل می‌کند.\r\nبرای مثال، می‌توانید متنی را وارد کرده و خروجی آن را به‌صورت فایل صوتی (فرمت MP3) دریافت و پخش کنید.','','',500,'openai','gpt-4o-mini-tts','<i class=\"fas fa-headphones-alt\"></i>','audio');
/*!40000 ALTER TABLE `ai_models` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `alembic_version`
--

DROP TABLE IF EXISTS `alembic_version`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `alembic_version` (
  `version_num` varchar(32) NOT NULL,
  PRIMARY KEY (`version_num`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `alembic_version`
--

LOCK TABLES `alembic_version` WRITE;
/*!40000 ALTER TABLE `alembic_version` DISABLE KEYS */;
INSERT INTO `alembic_version` VALUES ('280e1c38b440');
/*!40000 ALTER TABLE `alembic_version` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `assistants`
--

DROP TABLE IF EXISTS `assistants`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `assistants` (
  `id` int NOT NULL AUTO_INCREMENT,
  `title` varchar(255) NOT NULL,
  `description` text,
  `faiss_url` varchar(500) DEFAULT NULL,
  `pkl_url` varchar(500) DEFAULT NULL,
  `excel_url` varchar(500) DEFAULT NULL,
  `status` tinyint(1) DEFAULT NULL,
  `slug` varchar(36) NOT NULL,
  `domain` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `slug` (`slug`),
  KEY `ix_assistants_id` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=47 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `assistants`
--

LOCK TABLES `assistants` WRITE;
/*!40000 ALTER TABLE `assistants` DISABLE KEYS */;
INSERT INTO `assistants` VALUES (46,'دستیار هوشمند هلو','این دستیار به پرسش های مرتبط با نرم افزار هلو پاسخ می دهد','static/uploads/user_92ac38ff-eeeb-461d-b291-a69660b83c46/vectorstores/46/index.faiss','static/uploads/user_92ac38ff-eeeb-461d-b291-a69660b83c46/vectorstores/46/index.pkl','static/uploads/user_92ac38ff-eeeb-461d-b291-a69660b83c46/52c78ce0a2d56a09.xlsx',1,'0277c563-2c6d-40d1-a3a2-53f59568ee19','webcomdemo.ir');
/*!40000 ALTER TABLE `assistants` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `file_uploads`
--

DROP TABLE IF EXISTS `file_uploads`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `file_uploads` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` varchar(36) NOT NULL,
  `filename` varchar(255) NOT NULL,
  `filepath` varchar(512) NOT NULL,
  `content_type` varchar(100) DEFAULT NULL,
  `size` int NOT NULL,
  `uploaded_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  KEY `ix_file_uploads_id` (`id`),
  CONSTRAINT `file_uploads_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `file_uploads`
--

LOCK TABLES `file_uploads` WRITE;
/*!40000 ALTER TABLE `file_uploads` DISABLE KEYS */;
/*!40000 ALTER TABLE `file_uploads` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `otps`
--

DROP TABLE IF EXISTS `otps`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `otps` (
  `id` int NOT NULL AUTO_INCREMENT,
  `phone` varchar(20) NOT NULL,
  `otp_code` varchar(6) NOT NULL,
  `expire_at` datetime NOT NULL,
  `created_at` datetime DEFAULT NULL,
  `is_used` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `ix_otps_id` (`id`),
  KEY `ix_otps_phone` (`phone`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `otps`
--

LOCK TABLES `otps` WRITE;
/*!40000 ALTER TABLE `otps` DISABLE KEYS */;
/*!40000 ALTER TABLE `otps` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `permissions`
--

DROP TABLE IF EXISTS `permissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `permissions` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(256) DEFAULT NULL,
  `title` varchar(256) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `ix_permissions_name` (`name`),
  UNIQUE KEY `ix_permissions_title` (`title`),
  KEY `ix_permissions_id` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=25 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `permissions`
--

LOCK TABLES `permissions` WRITE;
/*!40000 ALTER TABLE `permissions` DISABLE KEYS */;
INSERT INTO `permissions` VALUES (1,'list_user','لیست کاربر'),(2,'create_user','ایجاد کاربر'),(3,'edit_user','ویرایش کاربر'),(4,'delete_user','حذف کاربر'),(5,'list_role','لیست نقش'),(6,'create_role','ایجاد نقش'),(7,'edit_role','ویرایش نقش'),(8,'delete_role','حذف نقش'),(9,'list_permission','لیست مجوز'),(10,'create_permission','ایجاد مجوز'),(11,'edit_permission','ویرایش مجوز'),(12,'delete_permission','حذف مجوز'),(13,'list_ai','لیست هوش مصنوعی'),(14,'create_ai','ایجاد هوش مصنوعی'),(15,'edit_ai','ویرایش هوش مصنوعی'),(16,'delete_ai','حذف هوش مصنوعی'),(17,'menu_user','منوی مدیریت کاربران'),(18,'menu_ai','منوی دستیارها'),(19,'archive_ai','بایگانی'),(20,'delete_archive','حذف بایگانی'),(21,'create_assistants','ایجاد دستیار اختصاصی'),(22,'edit_assistants','ویرایش دستیار اختصاصی'),(23,'list_assistants','لیست دستیارهای اختصاصی'),(24,'delete_assistants','حذف دستیار اختصاصی');
/*!40000 ALTER TABLE `permissions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `rate_limits`
--

DROP TABLE IF EXISTS `rate_limits`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `rate_limits` (
  `ip` varchar(45) NOT NULL,
  `request_count` int DEFAULT NULL,
  `last_request` datetime DEFAULT (now()),
  PRIMARY KEY (`ip`),
  KEY `ix_rate_limits_ip` (`ip`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `rate_limits`
--

LOCK TABLES `rate_limits` WRITE;
/*!40000 ALTER TABLE `rate_limits` DISABLE KEYS */;
INSERT INTO `rate_limits` VALUES ('127.0.0.1',1,'2025-07-21 10:33:27'),('2.187.99.27',1,'2025-07-23 15:05:30'),('2a02:4540:5001:4445:1:0:6568:ac30',1,'2025-07-22 22:52:40'),('5.217.33.200',1,'2025-07-24 11:13:35'),('89.198.226.196',1,'2025-07-21 20:36:07');
/*!40000 ALTER TABLE `rate_limits` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `refresh_tokens`
--

DROP TABLE IF EXISTS `refresh_tokens`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `refresh_tokens` (
  `id` int NOT NULL AUTO_INCREMENT,
  `token` varchar(512) NOT NULL,
  `user_id` varchar(36) NOT NULL,
  `is_active` tinyint(1) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `expires_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `ix_refresh_tokens_token` (`token`),
  KEY `user_id` (`user_id`),
  KEY `ix_refresh_tokens_id` (`id`),
  CONSTRAINT `refresh_tokens_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `refresh_tokens`
--

LOCK TABLES `refresh_tokens` WRITE;
/*!40000 ALTER TABLE `refresh_tokens` DISABLE KEYS */;
INSERT INTO `refresh_tokens` VALUES (21,'4060caa49be7a13c5048d7b65390e462ff5f53ceec898af4d14f02cc45b5a31e','92ac38ff-eeeb-461d-b291-a69660b83c46',1,'2025-07-24 11:13:36','2025-07-31 11:13:36');
/*!40000 ALTER TABLE `refresh_tokens` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `role_permissions`
--

DROP TABLE IF EXISTS `role_permissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `role_permissions` (
  `role_id` int DEFAULT NULL,
  `permission_id` int DEFAULT NULL,
  KEY `permission_id` (`permission_id`),
  KEY `role_id` (`role_id`),
  CONSTRAINT `role_permissions_ibfk_1` FOREIGN KEY (`permission_id`) REFERENCES `permissions` (`id`),
  CONSTRAINT `role_permissions_ibfk_2` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `role_permissions`
--

LOCK TABLES `role_permissions` WRITE;
/*!40000 ALTER TABLE `role_permissions` DISABLE KEYS */;
INSERT INTO `role_permissions` VALUES (1,1),(1,2),(1,3),(1,4),(1,5),(1,6),(1,7),(1,8),(1,9),(1,10),(1,11),(1,12),(1,13),(1,14),(1,15),(1,16),(1,17),(1,18),(1,19),(1,20),(1,24),(1,21),(1,23),(1,22);
/*!40000 ALTER TABLE `role_permissions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `roles`
--

DROP TABLE IF EXISTS `roles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `roles` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(256) DEFAULT NULL,
  `title` varchar(256) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `ix_roles_name` (`name`),
  UNIQUE KEY `ix_roles_title` (`title`),
  KEY `ix_roles_id` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `roles`
--

LOCK TABLES `roles` WRITE;
/*!40000 ALTER TABLE `roles` DISABLE KEYS */;
INSERT INTO `roles` VALUES (1,'Admin','مدیر'),(2,'User','کاربر');
/*!40000 ALTER TABLE `roles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tokens`
--

DROP TABLE IF EXISTS `tokens`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tokens` (
  `id` int NOT NULL AUTO_INCREMENT,
  `token` varchar(512) NOT NULL,
  `user_id` varchar(36) NOT NULL,
  `is_active` tinyint(1) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `token` (`token`),
  KEY `user_id` (`user_id`),
  KEY `ix_tokens_id` (`id`),
  CONSTRAINT `tokens_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=93 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tokens`
--

LOCK TABLES `tokens` WRITE;
/*!40000 ALTER TABLE `tokens` DISABLE KEYS */;
INSERT INTO `tokens` VALUES (92,'4313605060ed9bee0612b80d65519f1dee738c0aa08bd750a1f7301aa5095b78','92ac38ff-eeeb-461d-b291-a69660b83c46',1,'2025-07-24 13:24:24');
/*!40000 ALTER TABLE `tokens` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_roles`
--

DROP TABLE IF EXISTS `user_roles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_roles` (
  `user_id` varchar(36) NOT NULL,
  `role_id` int NOT NULL,
  PRIMARY KEY (`user_id`,`role_id`),
  KEY `role_id` (`role_id`),
  CONSTRAINT `user_roles_ibfk_1` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`),
  CONSTRAINT `user_roles_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_roles`
--

LOCK TABLES `user_roles` WRITE;
/*!40000 ALTER TABLE `user_roles` DISABLE KEYS */;
INSERT INTO `user_roles` VALUES ('92ac38ff-eeeb-461d-b291-a69660b83c46',1);
/*!40000 ALTER TABLE `user_roles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `id` varchar(36) NOT NULL,
  `email` varchar(255) DEFAULT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `password` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `ix_users_id` (`id`),
  UNIQUE KEY `ix_users_email` (`email`),
  UNIQUE KEY `ix_users_phone` (`phone`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES ('92ac38ff-eeeb-461d-b291-a69660b83c46','admin@gmail.com','','$2b$12$f5cbzLZQ33yYqowo2URA0uFD8jrZd0E6WeDvip3Z1tZbpc97HuO4i');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-07-24 17:18:38
