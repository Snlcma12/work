-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Хост: 127.0.0.1:3306
-- Время создания: Апр 22 2025 г., 22:27
-- Версия сервера: 8.0.30
-- Версия PHP: 8.1.9

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- База данных: `testing_system`
--

-- --------------------------------------------------------

--
-- Структура таблицы `options`
--

CREATE TABLE `options` (
  `option_id` int NOT NULL,
  `question_id` int DEFAULT NULL,
  `option_text` text NOT NULL,
  `is_correct` tinyint(1) DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Дамп данных таблицы `options`
--

INSERT INTO `options` (`option_id`, `question_id`, `option_text`, `is_correct`) VALUES
(18, 14, '4545', 1),
(19, 15, '222', 1),
(20, 16, '22', 1),
(21, 17, '343', 1),
(22, 18, '343', 1),
(23, 19, '3', 1),
(24, 20, '4е43', 1),
(25, 21, '2', 1),
(26, 22, '3', 1),
(27, 23, '3', 1),
(28, 24, '343', 1),
(29, 25, '2', 1),
(30, 26, '2', 1),
(31, 27, '45', 1),
(32, 28, '4543', 1),
(33, 29, '342', 1),
(34, 30, '342', 1),
(35, 31, '22', 1),
(36, 32, '2', 1),
(37, 33, '1', 1),
(38, 34, 'уц', 1),
(39, 35, '1', 1),
(40, 36, 'Слово', 1),
(41, 37, 'Слово', 1),
(42, 38, 'авау', 1);

-- --------------------------------------------------------

--
-- Структура таблицы `questions`
--

CREATE TABLE `questions` (
  `question_id` int NOT NULL,
  `test_id` int DEFAULT NULL,
  `question_text` text NOT NULL,
  `score` int NOT NULL DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Дамп данных таблицы `questions`
--

INSERT INTO `questions` (`question_id`, `test_id`, `question_text`, `score`) VALUES
(14, 14, '45е45', 1),
(15, 15, '2323', 1),
(16, 16, '232', 6),
(17, 17, '3434', 2),
(18, 18, '3453', 1),
(19, 19, '34343', 1),
(20, 19, '4е4е4', 1),
(21, 20, '23', 3),
(22, 20, '34324', 4),
(23, 21, '3424', 2),
(24, 21, '3432', 3),
(25, 22, '22', 2),
(26, 22, '232', 2),
(27, 23, '4353', 3),
(28, 23, '43534', 2),
(29, 24, '32423', 4),
(30, 24, '342', 2),
(31, 25, '2', 7),
(32, 25, '232', 2),
(33, 26, 'уцацыа', 4),
(34, 27, 'уац', 1),
(35, 28, '22', 1),
(36, 29, 'куенук5н5', 1),
(37, 30, 'куенук5н5', 1),
(38, 31, 'куенук5н5', 1);

-- --------------------------------------------------------

--
-- Структура таблицы `results`
--

CREATE TABLE `results` (
  `result_id` int NOT NULL,
  `user_id` int NOT NULL,
  `test_id` int NOT NULL,
  `score` int NOT NULL DEFAULT '0',
  `date` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `start_time` datetime DEFAULT CURRENT_TIMESTAMP,
  `end_time` datetime DEFAULT NULL,
  `time_spent` int GENERATED ALWAYS AS (timestampdiff(SECOND,`start_time`,`end_time`)) STORED
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Дамп данных таблицы `results`
--

INSERT INTO `results` (`result_id`, `user_id`, `test_id`, `score`, `date`, `start_time`, `end_time`) VALUES
(8, 7, 14, 1, '2025-04-20 08:07:18', '2025-04-22 16:58:08', NULL),
(9, 7, 15, 1, '2025-04-20 08:07:43', '2025-04-22 16:58:08', NULL),
(10, 7, 16, 6, '2025-04-20 08:17:00', '2025-04-22 16:58:08', NULL),
(11, 7, 17, 2, '2025-04-20 08:23:43', '2025-04-22 16:58:08', NULL),
(12, 7, 19, 2, '2025-04-20 08:28:09', '2025-04-22 16:58:08', NULL),
(13, 7, 20, 7, '2025-04-20 08:28:38', '2025-04-22 16:58:08', NULL),
(14, 7, 21, 5, '2025-04-20 08:29:09', '2025-04-22 16:58:08', NULL),
(15, 7, 24, 6, '2025-04-20 09:43:18', '2025-04-22 16:58:08', NULL),
(16, 7, 23, 5, '2025-04-20 09:43:29', '2025-04-22 16:58:08', NULL),
(17, 7, 22, 4, '2025-04-20 09:43:38', '2025-04-22 16:58:08', NULL),
(18, 7, 25, 9, '2025-04-20 09:44:15', '2025-04-22 16:58:08', NULL),
(19, 8, 27, 1, '2025-04-21 14:15:55', '2025-04-22 16:58:08', NULL),
(20, 16, 31, 1, '2025-04-22 19:21:08', '2025-04-22 22:21:08', '2025-04-22 22:21:11'),
(21, 16, 31, 0, '2025-04-22 19:21:26', '2025-04-22 22:21:26', NULL),
(22, 16, 30, 0, '2025-04-22 19:21:41', '2025-04-22 22:21:41', NULL);

-- --------------------------------------------------------

--
-- Структура таблицы `tests`
--

CREATE TABLE `tests` (
  `test_id` int NOT NULL,
  `title` varchar(255) NOT NULL,
  `description` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `group_name` varchar(50) DEFAULT NULL,
  `attempts_allowed` int DEFAULT NULL,
  `time_limit` int DEFAULT NULL COMMENT 'В минутах',
  `available_until` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Дамп данных таблицы `tests`
--

INSERT INTO `tests` (`test_id`, `title`, `description`, `created_at`, `group_name`, `attempts_allowed`, `time_limit`, `available_until`) VALUES
(14, '123', '43е4е', '2025-04-20 08:07:14', NULL, NULL, NULL, NULL),
(15, '123', '2342', '2025-04-20 08:07:39', NULL, NULL, NULL, NULL),
(16, '12', '3432', '2025-04-20 08:16:57', NULL, NULL, NULL, NULL),
(17, '3543', '343', '2025-04-20 08:23:39', NULL, NULL, NULL, NULL),
(18, '4325345', 'оатуыалту', '2025-04-20 08:24:35', NULL, NULL, NULL, NULL),
(19, '547645', '454353', '2025-04-20 08:27:59', NULL, NULL, NULL, NULL),
(20, '232', '232', '2025-04-20 08:28:34', NULL, NULL, NULL, NULL),
(21, '1323', '232', '2025-04-20 08:29:05', NULL, NULL, NULL, NULL),
(22, '12', '232', '2025-04-20 09:30:56', NULL, NULL, NULL, NULL),
(23, '45', '4534', '2025-04-20 09:31:22', NULL, NULL, NULL, NULL),
(24, '32434', '3432', '2025-04-20 09:31:44', NULL, NULL, NULL, NULL),
(25, 'ewr', '2321', '2025-04-20 09:44:11', NULL, NULL, NULL, NULL),
(26, 'Тест', 'уцак', '2025-04-21 13:49:23', 'Ивт-21', NULL, NULL, NULL),
(27, 'укпуц', 'уаыфуа', '2025-04-21 14:15:40', 'Ивт-21', NULL, NULL, NULL),
(28, '1', '1', '2025-04-21 14:19:47', '1', NULL, NULL, NULL),
(29, '234к54', '3цкц4ецуе', '2025-04-22 18:52:06', 'Ивт-21', 2, 0, '2025-04-05 21:51:00'),
(30, 'ц3ук', '', '2025-04-22 19:02:36', 'Ивт-21', 1, 0, NULL),
(31, 'уаццццццц', 'цавй', '2025-04-22 19:18:11', 'Ивт-21', 2, 59, '2025-04-23 22:18:00');

-- --------------------------------------------------------

--
-- Структура таблицы `users`
--

CREATE TABLE `users` (
  `user_id` int NOT NULL,
  `username` varchar(50) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `email` varchar(100) DEFAULT NULL,
  `role` enum('student','teacher') NOT NULL,
  `group_name` varchar(50) DEFAULT NULL,
  `department` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Дамп данных таблицы `users`
--

INSERT INTO `users` (`user_id`, `username`, `password_hash`, `email`, `role`, `group_name`, `department`) VALUES
(6, 'Daniil5', 'scrypt:32768:8:1$qZxH8gJCKiHQnlTp$74465c71b51a7f13d75664c382b98786c4d5523f11b0eaf9fa85247d7ee096730bdc894543122137216e4550318563bc0f3acc9bbdf568984de5def309d9b8b5', 'daniil_semenov572@mail.ru', 'student', NULL, NULL),
(7, 'Daniil6', 'scrypt:32768:8:1$eeg1rxUh19lQuD52$68973e86769d8fb75313f0c2929defc06f61a117387e42d73451e6d7c08295462f48d5a864b543909867ccfc22b740407a8ada2f22d7af44641b7af585ff89d3', 'euifhew@mail.ru', 'student', 'Ивт-21', NULL),
(8, 'Daniil1', 'scrypt:32768:8:1$JWWaVh6cANKA8JOd$2b77e7d39a7c18d84ee9b73a8d917f72a63023a8b234c9557ec6e822fb5bb1496d4a4d9937db66b46d743785226e51b4cb31247121cfc5953c31decd32fffd63', 'daniil_semenov562@mail.ru', 'teacher', NULL, 'Информационная безопасность'),
(14, 'Daniil69', 'scrypt:32768:8:1$oObiT8PLJzBPse79$62010e513246f6f6833903bef416b59a5758091e4a7f39bdf5adaf6ed367123a36a37f4cb552f261a7a605ace1071cc4db41d7c9df463912561b6464c1712319', 'daniil4920semenov@yandex.ru', 'student', 'Ивт-21', NULL),
(15, 'Semenov', 'scrypt:32768:8:1$yaoLTsxUYj8uQC4Q$fbed013f8eeb199fe451c94345192574d4394e7896292ba08e0221d57cd71aa88661472465357a73551a76cf1037c8bb3207b2d400e40d5e86c5f386aa190ed1', 'Sdanil562@gmail.com', 'student', 'Ивт-21', NULL),
(16, 'daniil_semenov562', 'scrypt:32768:8:1$756GVpuMi88yXaKD$4fafa15cabe402d2e5c8bdb1680f31c8c400d34eb6ed6566afef706d9b5913035ceef2c67406169b1ad69d87665b82bc826fe9bd257b2423cb0006fc3122edf7', 'dskmfkvlsm@mail.ru', 'teacher', NULL, 'Информационная безопсность');

--
-- Индексы сохранённых таблиц
--

--
-- Индексы таблицы `options`
--
ALTER TABLE `options`
  ADD PRIMARY KEY (`option_id`),
  ADD KEY `question_id` (`question_id`);

--
-- Индексы таблицы `questions`
--
ALTER TABLE `questions`
  ADD PRIMARY KEY (`question_id`),
  ADD KEY `test_id` (`test_id`);

--
-- Индексы таблицы `results`
--
ALTER TABLE `results`
  ADD PRIMARY KEY (`result_id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `test_id` (`test_id`);

--
-- Индексы таблицы `tests`
--
ALTER TABLE `tests`
  ADD PRIMARY KEY (`test_id`);

--
-- Индексы таблицы `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`user_id`),
  ADD UNIQUE KEY `username` (`username`),
  ADD UNIQUE KEY `email` (`email`);

--
-- AUTO_INCREMENT для сохранённых таблиц
--

--
-- AUTO_INCREMENT для таблицы `options`
--
ALTER TABLE `options`
  MODIFY `option_id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=43;

--
-- AUTO_INCREMENT для таблицы `questions`
--
ALTER TABLE `questions`
  MODIFY `question_id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=39;

--
-- AUTO_INCREMENT для таблицы `results`
--
ALTER TABLE `results`
  MODIFY `result_id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=23;

--
-- AUTO_INCREMENT для таблицы `tests`
--
ALTER TABLE `tests`
  MODIFY `test_id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=32;

--
-- AUTO_INCREMENT для таблицы `users`
--
ALTER TABLE `users`
  MODIFY `user_id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;

--
-- Ограничения внешнего ключа сохраненных таблиц
--

--
-- Ограничения внешнего ключа таблицы `options`
--
ALTER TABLE `options`
  ADD CONSTRAINT `options_ibfk_1` FOREIGN KEY (`question_id`) REFERENCES `questions` (`question_id`);

--
-- Ограничения внешнего ключа таблицы `questions`
--
ALTER TABLE `questions`
  ADD CONSTRAINT `questions_ibfk_1` FOREIGN KEY (`test_id`) REFERENCES `tests` (`test_id`);

--
-- Ограничения внешнего ключа таблицы `results`
--
ALTER TABLE `results`
  ADD CONSTRAINT `results_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`),
  ADD CONSTRAINT `results_ibfk_2` FOREIGN KEY (`test_id`) REFERENCES `tests` (`test_id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
