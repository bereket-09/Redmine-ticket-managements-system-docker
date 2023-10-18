-- Create the redmine database
CREATE DATABASE redmine CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;

-- Create the redmine user and grant access
CREATE USER 'redmine'@'%' IDENTIFIED BY 'your_password';
GRANT ALL PRIVILEGES ON redmine.* TO 'redmine'@'%';

-- Switch to the redmine database
USE redmine;

-- Create the necessary tables for Redmine
CREATE TABLE `issue_statuses` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(30) DEFAULT NULL,
  `is_closed` tinyint(1) DEFAULT '0',
  `position` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

"CREATE TABLE `project_statuses` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(30) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Add default issue and project statuses
INSERT INTO `issue_statuses` (`name`, `is_closed`, `position`) VALUES ('New', '0', '1'), ('In Progress', '0', '2'), ('Resolved', '1', '3'), ('Feedback', '0', '4'), ('Closed', '1', '5');
INSERT INTO `project_statuses` (`name`) VALUES ('Active'), ('On Hold'), ('Archived');

-- Create custom fields for issues
CREATE TABLE `custom_fields` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type` varchar(30) DEFAULT NULL,
  `name` varchar(30) DEFAULT NULL,
  `field_format` varchar(30) DEFAULT NULL,
  `possible_values` text DEFAULT NULL,
  `regexp` text DEFAULT NULL,
  `min_length` int(11) DEFAULT NULL,
  `max_length` int(11) DEFAULT NULL,
  `is_required` tinyint(1) DEFAULT NULL,
  `is_filter` tinyint(1) DEFAULT NULL,
  `searchable` tinyint(1) DEFAULT NULL,
  `multiple` tinyint(1) DEFAULT NULL,
  `default_value` varchar(30) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO `custom_fields` (`type`, `name`, `field_format`, `possible_values`, `is_filter`, `searchable`, `multiple`) VALUES 
('IssueCustomField', 'Urgency', 'list', '3-Urgent\n2-High\n1-Medium\n0-Low', '1', '1', '0'),
('IssueCustomField', 'Impact', 'list', '3-Critical\n2-High\n1-Medium\n0-Low', '1', '1', '0'),
('IssueCustomField', 'Priority', 'list', '3-High\n2-Medium\n1-Low', '1', '1', '0'),
('IssueCustomField', 'Risk', 'list', '3-High\n2-Medium\n1-Low\n0-None', '1', '1', '0'),
('IssueCustomField', 'Business Value', 'float', NULL, '0', '0', '0');

-- Create the default roles
INSERT INTO `roles` (`name`, `position`, `assignable`, `permissions`) VALUES 
('Anonymous', '1', '0', '{"issues":{"view_issues":"1","add_issues":"0","edit_issues":"0","delete_issues":"0","manage_issue_relations":"0","tag_issues":"0","move_issues":"0"},"news":{"view_news":"1"},"documents":{"view_documents":"1"},"wiki":{"view_wiki_pages":"1"},"messages":{"view_messages":"1"}}'),
('Non-Member', '2', '0', '{"issues":{"view_issues":"1"},"news":{"view_news":"1"},"documents":{"view_documents":"1"},"wiki":{"view_wiki_pages":"1"},"messages":{"view_messages":"1"}}'),
('Project Viewer', '3', '1', '{"issues":{"view_issues":"1"},"news":{"view_news":"1"},"documents":{"view_documents":"1"},"wiki":{"view_wiki_pages":"1"},"messages":{"view_messages":"1"}}'),
('Project Reporter', '4', '1', '{"issues":{"view_issues":"1","add_issues":"1","tag_issues":"1","move_issues":"1"},"news":{"view_news":"1","comment_news":"1"},"documents":{"view_documents":"1"},"wiki":{"view_wiki_pages":"1","comment_wiki_pages":"1"},"messages":{"view_messages":"1"}}'),
('Project Developer', '5', '1', '{"issues":{"view_issues":"1","add_issues":"1","edit_issues":"1","tag_issues":"1","move_issues":"1"},"news":{"view_news":"1","comment_news":"1"},"documents":{"view_documents":"1"},"wiki":{"view_wiki_pages":"1","export_wiki_pages":"1","comment_wiki_pages":"1"},"messages":{"manage_messages":"1","view_messages":"1"}}'),
('Project Manager', '6', '1', '{"issues":{"view_issues":"1","add_issues":"1","edit_issues":"1","delete_issues":"1","manage_issue_relations":"1","tag_issues":"1","move_issues":"1"},"time_entries":{"log_time":"1","view_time_entries":"1"},"news":{"manage_news":"1","view_news":"1","comment_news":"1"},"documents":{"manage_documents":"1","view_documents":"1"},"files":{"manage_files":"1","view_files":"1"},"wiki":{"manage_wiki":"1","view_wiki_pages":"1","export_wiki_pages":"1","comment_wiki_pages":"1"},"messages":{"manage_messages":"1","view_messages":"1"}}');

-- Create default permission entries for the project
INSERT INTO `permissions` (`role_id`, `permissions`, `project_id`) VALUES 
('1', '{"issues":{"view_issues":"1"}}', NULL),
('2', '{"issues":{"view_issues":"1","add_issues":"1","edit_issues":"1","tag_issues":"1","move_issues":"1"}}', NULL),
('3', '{"issues":{"view_issues":"1"}}', NULL),
('4', '{"issues":{"view_issues":"1","add_issues":"1","tag_issues":"1","move_issues":"1"}}', NULL),
('5', '{"issues":{"view_issues":"1","add_issues":"1","edit_issues":"1","tag_issues":"1","move_issues":"1"}}', NULL),
('6', '{"issues":{"view_issues":"1","add_issues":"1","edit_issues":"1","delete_issues":"1","manage_issue_relations":"1","tag_issues":"1","move_issues":"1"},"time_entries":{"log_time":"1","view_time_entries":"1"},"news":{"manage_news":"1","view_news":"1","comment_news":"1"},"documents":{"manage_documents":"1","view_documents":"1"},"files":{"manage_files":"1","view_files":"1"},"wiki":{"manage_wiki":"1","view_wiki_pages":"1","export_wiki_pages":"1","comment_wiki_pages":"1"},"messages":{"manage_messages":"1","view_messages":"1"}}', NULL);

-- Create default trackers
INSERT INTO `trackers` (`name`, `is_in_chlog`) VALUES ('Bug', '1'), ('Feature', '1'), ('Support', '1');

-- Create custom fields for projects
INSERT INTO `custom_fields` (`type`, `name`, `field_format`, `possible_values`, `is_filter`, `searchable`, `multiple`) VALUES 
('ProjectCustomField', 'Ideal Hours', 'float', NULL, '0', '0', '0'),
('ProjectCustomField', 'Estimated Start Date', 'date', NULL, '0', '0', '0'),
('ProjectCustomField', 'Estimated End Date', 'date', NULL, '0', '0', '0'),
('ProjectCustomField', 'Actual Start Date', 'date', NULL, '0', '0', '0'),
('ProjectCustomField', 'Actual End Date', 'date', NULL, '0', '0', '0'),
('ProjectCustomField', 'Project Status', 'list', '1-Active\n2-On Hold\n3-Closed\n4-Archived', '1', '1', '0');

-- Add default modules
INSERT INTO `enabled_modules` (`name`) VALUES ('issue_tracking'), ('time_tracking'), ('news'), ('documents'), ('files'), ('wiki'), ('repository'), ('boards'), ('calendar');

-- Set the default theme
INSERT INTO `settings` (`name`, `value`, `updated_on`) VALUES ('ui_theme', 'classic', NOW());
