-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Хост: 127.0.0.1:3306
-- Время создания: Май 26 2025 г., 20:18
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
(68, 60, 'float', 1),
(69, 60, 'str', 0),
(70, 60, 'int', 0),
(71, 60, 'list', 0),
(72, 61, 'Быстрая сортировка (Quick Sort)', 0),
(73, 61, 'Сортировка слиянием (Merge Sort)', 0),
(74, 61, 'Сортировка пузырьком (Bubble Sort)', 1),
(75, 61, 'Пирамидальная сортировка (Heap Sort)', 0),
(76, 62, 'HTTP', 0),
(77, 62, ' FTP', 0),
(78, 62, 'HTTPS', 1),
(79, 62, 'TCP', 0),
(80, 63, 'Structured Question Language', 0),
(81, 63, 'Standard Query Logic', 0),
(82, 63, 'Structured Query Language', 1),
(83, 63, 'Simple Question Layer', 0),
(84, 64, '1010', 1),
(85, 64, '1110', 0),
(86, 64, '1001', 0),
(87, 64, '1100', 0);

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
(60, 44, 'Какой тип данных используется для хранения целых чисел в Python?', 1),
(61, 45, 'Какой алгоритм сортировки имеет временную сложность O(n²) в худшем случае?', 1),
(62, 46, 'Какой протокол обеспечивает безопасную передачу данных в интернете?', 1),
(63, 47, 'Что означает аббревиатура SQL?', 1),
(64, 48, 'Какое из перечисленных чисел в двоичной системе равно 10 в десятичной?', 1);

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
(36, 17, 44, 0, '2025-05-25 10:55:08', '2025-05-25 13:55:08', '2025-05-25 13:55:12'),
(37, 18, 44, 0, '2025-05-25 10:56:09', '2025-05-25 13:56:09', '2025-05-25 13:56:15'),
(38, 18, 45, 1, '2025-05-26 14:41:00', '2025-05-26 17:41:00', '2025-05-26 17:41:02'),
(39, 17, 45, 1, '2025-05-26 14:57:16', '2025-05-26 17:57:16', '2025-05-26 17:57:18'),
(40, 17, 46, 1, '2025-05-26 14:57:28', '2025-05-26 17:57:28', '2025-05-26 17:57:34'),
(41, 17, 47, 1, '2025-05-26 14:57:42', '2025-05-26 17:57:42', '2025-05-26 17:57:44'),
(42, 17, 48, 1, '2025-05-26 14:57:48', '2025-05-26 17:57:48', '2025-05-26 17:57:51');

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
  `available_until` datetime DEFAULT NULL,
  `created_by` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Дамп данных таблицы `tests`
--

INSERT INTO `tests` (`test_id`, `title`, `description`, `created_at`, `group_name`, `attempts_allowed`, `time_limit`, `available_until`, `created_by`) VALUES
(44, 'Типы данных', 'Нужно выбрать правильный ответ', '2025-05-25 10:54:57', 'Ивт-21', 1, 0, '2025-05-31 13:54:00', 18),
(45, 'Алгоритмы сортировки', '', '2025-05-26 14:40:56', 'Ивт-21', 0, 30, '2025-05-31 17:39:00', 18),
(46, 'Протоколы', '', '2025-05-26 14:43:21', 'Ивт-21', 0, 0, '2025-05-31 17:41:00', 18),
(47, 'Sql', '', '2025-05-26 14:45:00', 'Ивт-21', 0, 0, '2025-05-31 17:43:00', 18),
(48, 'Двоичная система', '', '2025-05-26 14:48:48', 'Ивт-21', 0, 0, '2025-05-31 17:47:00', 18);

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
(17, 'Daniil', 'scrypt:32768:8:1$gSwcC3QPeOk9G2IN$912c33c5e1af83ab56d6b031b10c3ba15a7127a930ef8feab19f6d76c7695937b1093bba0815d82e8240a3252795fe392260f364a51216a2e217aff6cf6f9dab', 'Sdanil562@gmail.com', 'student', 'Ивт-21', NULL),
(18, 'Ivan', 'scrypt:32768:8:1$oBEizGuwM7YgppoT$77351bf84d28b0b3e7ba26e4fe4b0961f68767bc310602dd8968e12a79ef5707a24620b3579fa038d33d5f8820f0854601e9202ae3fb7b7f4937238e8dbe7734', 'Ivan@mail.ru', 'teacher', NULL, 'Программирование'),
(19, 'petrov', 'scrypt:32768:8:1$5f4dcc3b5aa765d6$c5a5ec3e21a2b8cf6d1b2d7df80b318334a8e4a0f0c5a78d1d3e6c1e3f8d7a6d', 'petrov@mail.ru', 'student', 'Ивт-21', NULL),
(20, 'maria_ivanova', 'scrypt:32768:8:1$6a7s8d2f3g4h5j6k$9f86d081884c7d659a2feaa0c55ad015a3bf4f1b2b0b832cd15d6c15b0f00a08', 'maria@university.ru', 'teacher', NULL, 'Математика'),
(21, 'olgasmirn', 'scrypt:32768:8:1$q1w2e3r4t5y6u7i$d8e9f0a1b2c3d4e5f6a7b8c9d0e1f2a3b4c5d6e7f8a9b0', 'olga@yandex.ru', 'student', 'Ивт-22', NULL),
(22, 'alex_fiz', 'scrypt:32768:8:1$zxcvasdfqwer1234$1a2b3c4d5e6f7g8h9i0j1k2l3m4n5o6p7q8r9s0t', 'alex@physics.ru', 'teacher', NULL, 'Физика');

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
  ADD PRIMARY KEY (`test_id`),
  ADD KEY `created_by` (`created_by`);

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
  MODIFY `option_id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=88;

--
-- AUTO_INCREMENT для таблицы `questions`
--
ALTER TABLE `questions`
  MODIFY `question_id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=65;

--
-- AUTO_INCREMENT для таблицы `results`
--
ALTER TABLE `results`
  MODIFY `result_id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=43;

--
-- AUTO_INCREMENT для таблицы `tests`
--
ALTER TABLE `tests`
  MODIFY `test_id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=49;

--
-- AUTO_INCREMENT для таблицы `users`
--
ALTER TABLE `users`
  MODIFY `user_id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=23;

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

--
-- Ограничения внешнего ключа таблицы `tests`
--
ALTER TABLE `tests`
  ADD CONSTRAINT `tests_ibfk_1` FOREIGN KEY (`created_by`) REFERENCES `users` (`user_id`),
  ADD CONSTRAINT `tests_ibfk_2` FOREIGN KEY (`created_by`) REFERENCES `users` (`user_id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
