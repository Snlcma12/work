-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Хост: 127.0.0.1:3306
-- Время создания: Апр 13 2025 г., 22:36
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
(1, 1, 'цк', 0),
(2, 2, '4t4w', 0),
(3, 3, '43rt43r', 0),
(4, 4, '2e', 0),
(5, 5, '3кц', 0),
(6, 6, '3у32у', 0),
(7, 7, '3423', 1),
(8, 8, 'Да', 1),
(9, 8, 'Нет', 0),
(10, 9, '2', 1),
(11, 9, '6', 0),
(12, 9, '3', 0),
(13, 9, '4', 0),
(14, 10, '34', 1),
(15, 11, '2', 1),
(16, 12, '232', 1),
(17, 13, '2', 1);

-- --------------------------------------------------------

--
-- Структура таблицы `questions`
--

CREATE TABLE `questions` (
  `question_id` int NOT NULL,
  `test_id` int DEFAULT NULL,
  `question_text` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Дамп данных таблицы `questions`
--

INSERT INTO `questions` (`question_id`, `test_id`, `question_text`) VALUES
(1, 1, 'цк'),
(2, 2, '4t4'),
(3, 3, '435r34'),
(4, 4, '2e'),
(5, 5, '3ку'),
(6, 6, '23у'),
(7, 7, '32432'),
(8, 8, 'Арбуз - это ягода?'),
(9, 9, '23'),
(10, 10, '343'),
(11, 11, '23421'),
(12, 12, '13'),
(13, 13, '2');

-- --------------------------------------------------------

--
-- Структура таблицы `results`
--

CREATE TABLE `results` (
  `result_id` int NOT NULL,
  `user_id` int NOT NULL,
  `test_id` int NOT NULL,
  `score` int NOT NULL,
  `date` timestamp NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `tests`
--

CREATE TABLE `tests` (
  `test_id` int NOT NULL,
  `title` varchar(255) NOT NULL,
  `description` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Дамп данных таблицы `tests`
--

INSERT INTO `tests` (`test_id`, `title`, `description`, `created_at`) VALUES
(1, '123', '3кц', '2025-04-12 06:38:36'),
(2, '435r', '43tr4', '2025-04-12 06:42:14'),
(3, '3r43', '435r43', '2025-04-12 06:50:30'),
(4, '12', '2e', '2025-04-12 07:00:30'),
(5, '23у', 'ц3к', '2025-04-12 07:08:56'),
(6, '32у', '32у', '2025-04-12 07:12:34'),
(7, '2424', '3432', '2025-04-12 07:17:13'),
(8, 'Лучшее животное', 'Ответь на вопрос', '2025-04-12 08:48:59'),
(9, '234e23', 'Lkz ', '2025-04-13 11:58:29'),
(10, '232', '23234', '2025-04-13 12:43:53'),
(11, '2432', '34324', '2025-04-13 13:01:26'),
(12, '1212', '3234', '2025-04-13 18:55:03'),
(13, 'ц34у3', '3242', '2025-04-13 19:32:00');

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
(1, '2323', 'scrypt:32768:8:1$TdpKx3cvu6te9YWz$62cfb3317604270eeb5cb58ef20006e34d15c1e43c8e52eb354902c3022324d9376591b2e852d8372b2949f2650447f0bc133ef0238f2d2f10c8c8b59c676448', 'daniil_semenov562@mail.ru', 'student', 'Ивт-21', NULL),
(2, 'Daniil', 'scrypt:32768:8:1$Q6WsHGfpN2aeo3BM$552c55e601f78e5fa5009af325ea3098dd89c3337859b98be06c1132e26ac7523fe4c3ac9ecde5e8e6c26ce7d03276c363861b1c52666342b4a9f56a057785d6', 'daniil_semenov562@mail.ru', 'student', 'Ивт-21', NULL),
(3, 'Daniil1', 'scrypt:32768:8:1$pAIe4Kth5vsCdCRa$f504d923edc427b963fc844da64a4a7c1e18e1d0d5ee6a477ed6580db1e198d21f93e7d3d372370660e44a436b830440921d2d4093192cd4808faa78dc2f69d5', 'Sdanil562@outlook.com', 'teacher', NULL, 'Информационная безопасность'),
(4, 'Daniil3', 'scrypt:32768:8:1$37DUFPWUmzdu6NTP$3e3180e6add42e52916c550bb7d0547b51b2d46a25dba9075c618d1b59a4f23d847ff552b77f6e2548488d42e6b55cd75b92d1f79b713c60214f0e463e53898a', 'daniil_semenov563@mail.ru', 'teacher', NULL, 'Информационная безопасность');

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
  ADD UNIQUE KEY `username` (`username`);

--
-- AUTO_INCREMENT для сохранённых таблиц
--

--
-- AUTO_INCREMENT для таблицы `options`
--
ALTER TABLE `options`
  MODIFY `option_id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=18;

--
-- AUTO_INCREMENT для таблицы `questions`
--
ALTER TABLE `questions`
  MODIFY `question_id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT для таблицы `results`
--
ALTER TABLE `results`
  MODIFY `result_id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT для таблицы `tests`
--
ALTER TABLE `tests`
  MODIFY `test_id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT для таблицы `users`
--
ALTER TABLE `users`
  MODIFY `user_id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

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
