CREATE TABLE IF NOT EXISTS `kda_stats` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `citizenid` varchar(50) NOT NULL,
    `kills` int(11) DEFAULT 0,
    `deaths` int(11) DEFAULT 0,
    `kda_ratio` decimal(5,2) DEFAULT 0.00,
    `last_updated` timestamp DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    UNIQUE KEY `citizenid` (`citizenid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4; 