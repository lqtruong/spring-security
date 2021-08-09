drop table if exists `site_role_permission`;
drop table if exists `site_permission_function`;
drop table if exists `site_function`;
drop table if exists `site_permission`;
drop table if exists `site_role`;
drop table if exists `site_user`;

create table if not exists `site_user`
(
    `id` bigint(20) auto_increment primary key,
	`tenant_id` varchar(10) not null default '' comment 'Site code',
    `email` varchar(256) not null comment 'User email',
    `created_by` varchar(256) not null default '' comment 'Record creation person',
    `modified_by` varchar(256) not null default '' comment 'Record modification person',
    `created_at` datetime not null default current_timestamp,
    `modified_at` datetime not null default current_timestamp
) comment 'site_user';

create index `idx_user_tenant_id` on `site_user` (`tenant_id`);
create index `idx_email` on `site_user` (`email`);

create table if not exists `site_role`
(
    `id` bigint(11) auto_increment primary key,
	`tenant_id` varchar(10) not null default '' comment 'Site code',
    `role` varchar(256) not null comment 'User role name. e.g super admin, tr admin, tr operator, tr normal_user',
    `role_desc` varchar(2048) default '' comment 'User role description',
    `created_by` varchar(256) not null default '' comment 'Record creation person',
    `modified_by` varchar(256) not null default '' comment 'Record modification person',
    `created_at` datetime not null default current_timestamp,
    `modified_at` datetime not null default current_timestamp
) comment 'site_role';

create index `idx_role_tenant_id` on `site_role` (`tenant_id`);
create index `idx_role` on `site_role` (`role`);

create table if not exists `site_permission`
(
    `id` bigint(11) auto_increment primary key,
	`tenant_id` varchar(10) not null default '' comment 'Site code',
    `perm_name` varchar(256) not null comment 'this is the group of functions, e.g features management,messages management,users management,template management,user group management,approval center',
    `perm_desc` varchar(2048) default '' comment 'permission description',
    `created_by` varchar(256) not null default '' comment 'Record creation person',
    `modified_by` varchar(256) not null default '' comment 'Record modification person',
    `created_at` datetime not null default current_timestamp,
    `modified_at` datetime not null default current_timestamp
) comment 'site_permission';

create index `idx_perm_tenant_id` on `site_permission` (`tenant_id`);
create index `idx_perm_name` on `site_permission` (`perm_name`);

create table if not exists `site_function`
(
    `id` bigint(11) auto_increment primary key,
	`tenant_id` varchar(10) not null default '' comment 'Site code',
    `func_name` varchar(256) not null comment 'this is the api level with specific action, e,g delete, edit, create...',
    `func_desc` varchar(2048) default '' comment 'url function description',
    `func_url` varchar(256) not null comment 'e.g. /message/create, /message/delete,...',
    `func_verb` varchar(20) not null comment 'the method verb in case the same url',
    `created_by` varchar(256) not null default '' comment 'Record creation person',
    `modified_by` varchar(256) not null default '' comment 'Record modification person',
    `created_at` datetime not null default current_timestamp,
    `modified_at` datetime not null default current_timestamp
) comment 'site_function';

create index `idx_func_tenant_id` on `site_function` (`tenant_id`);
create index `idx_func_name` on `site_function` (`func_name`);
alter table `site_function` add constraint `uc_func_url` unique (`func_url`,`tenant_id`,`func_verb`);

create table if not exists `site_permission_function`
(
    `id` bigint(11) auto_increment primary key,
	`tenant_id` varchar(10) not null default '' comment 'Site code',
	`perm_id` bigint(11) not null comment 'permission id, referenced to site_permission.id',
    `func_id` bigint(11) not null comment 'function id, referenced to site_function.id',
    `created_by` varchar(256) not null default '' comment 'Record creation person',
    `modified_by` varchar(256) not null default '' comment 'Record modification person',
    `created_at` datetime not null default current_timestamp,
    `modified_at` datetime not null default current_timestamp
) comment 'site_permission_function';

create index `idx_perm_func_tenant_id` on `site_permission_function` (`tenant_id`);
alter table `site_permission_function` add constraint `uc_perm_func` unique (`tenant_id`,`perm_id`,`func_id`);
alter table `site_permission_function` add foreign key (`perm_id`) references `site_permission` (`id`);
alter table `site_permission_function` add foreign key (`func_id`) references `site_function` (`id`);

create table if not exists `site_role_permission`
(
    `id` bigint(11) auto_increment primary key,
	`tenant_id` varchar(10) not null default '' comment 'Site code',
	`role` bigint(11) not null comment 'User role id, referenced to site_role.id',
    `perm_id` bigint(11) not null comment 'permission id, referenced to site_permission.id',
    `created_by` varchar(256) not null default '' comment 'Record creation person',
    `modified_by` varchar(256) not null default '' comment 'Record modification person',
    `created_at` datetime not null default current_timestamp,
    `modified_at` datetime not null default current_timestamp
) comment 'site_role_permission';

create index `idx_role_perm_tenant_id` on `site_role_permission` (`tenant_id`);
alter table `site_role_permission` add constraint `uc_role_perm` unique (`tenant_id`,`role`,`perm_id`);
alter table `site_role_permission` add foreign key (`role`) references `site_role` (`id`);
alter table `site_role_permission` add foreign key (`perm_id`) references `site_permission` (`id`);

#### Turkey example
insert into `site_user`(
    `id`,
    `tenant_id`,
    `email`,
    `created_by`,
    `modified_by`,
    `created_at`,
    `modified_at`
) values
(1, '', 'a@mail.com','m@mail.com','m@mail.com',sysdate(),sysdate()),
(2, 'vn', 'b@mail.com','m@mail.com','m@mail.com',sysdate(),sysdate()),
(3, 'vn', 'c@mail.com','m@mail.com','m@mail.com',sysdate(),sysdate()),
(4, 'aus', 'd@mail.com','m@mail.com','m@mail.com',sysdate(),sysdate()),
(5, 'aus', 'e@mail.com','m@mail.com','m@mail.com',sysdate(),sysdate())
;

insert into `site_role`(
    `id`,
    `tenant_id`,
    `role`,
    `role_desc`,
    `created_by`,
    `modified_by`,
    `created_at`,
    `modified_at`
) values
(1, '', 'Super Admin','Super Admin role has no tenant identified.','m@mail.com','m@mail.com',sysdate(),sysdate()),
(2, 'tr', 'TR Admin','TR Admin role must have tenant identified.','m@mail.com','m@mail.com',sysdate(),sysdate()),
(3, 'tr', 'TR Operator','TR Operator role must have tenant identified.','m@mail.com','m@mail.com',sysdate(),sysdate()),
(4, 'ind', 'TR Admin','TR Admin role must have tenant identified.','m@mail.com','m@mail.com',sysdate(),sysdate()),
(5, 'ind', 'TR Operator','TR Operator role must have tenant identified.','m@mail.com','m@mail.com',sysdate(),sysdate())
;

insert into `site_permission`(
    `id`,
    `tenant_id`,
    `perm_name`,
    `perm_desc`,
    `created_by`,
    `modified_by`,
    `created_at`,
    `modified_at`
) values
(1, '', 'Authority','Authority feature','m@mail.com','m@mail.com',sysdate(),sysdate()),
(2, '', 'UserGroupManagement','User Group Management','m@mail.com','m@mail.com',sysdate(),sysdate()),
(3, '', 'MessageManagement','Send Message Management','m@mail.com','m@mail.com',sysdate(),sysdate()),
(4, '', 'TemplateManagement','Template Management','m@mail.com','m@mail.com',sysdate(),sysdate()),
(5, '', 'EmailCollection','Email Collection Builder','m@mail.com','m@mail.com',sysdate(),sysdate()),
(6, '', 'EmailModule','Email Module Builder','m@mail.com','m@mail.com',sysdate(),sysdate()),
(7, '', 'EmailTemplate','Email Template Builder','m@mail.com','m@mail.com',sysdate(),sysdate()),
(8, '', 'Approval enter','Approval Center','m@mail.com','m@mail.com',sysdate(),sysdate()),
(9, '', 'UserManagement','User Management','m@mail.com','m@mail.com',sysdate(),sysdate()),
(10, '', 'SiteManagement','Site Management','m@mail.com','m@mail.com',sysdate(),sysdate()),
(11, '', 'SystemSettings','System Settings','m@mail.com','m@mail.com',sysdate(),sysdate()),
(12, '', 'FeatureManagement','Feature Management','m@mail.com','m@mail.com',sysdate(),sysdate()),
(13, '', 'DataDashboard','Data Dashboard','m@mail.com','m@mail.com',sysdate(),sysdate()),
(14, '', 'Datawind','Datawind Integration','m@mail.com','m@mail.com',sysdate(),sysdate()),
(15, '', 'BusinessConstraint','Business Constraint','m@mail.com','m@mail.com',sysdate(),sysdate()),
(16, '', 'UserTask','User Task Management','m@mail.com','m@mail.com',sysdate(),sysdate()),
(17, '', 'Task','Task Management','m@mail.com','m@mail.com',sysdate(),sysdate()),
# Turkey (TR) feature permission
(18, 'tr', 'Authority','Authority feature','m@mail.com','m@mail.com',sysdate(),sysdate()),
(19, 'tr', 'UserGroupManagement','User Group Management','m@mail.com','m@mail.com',sysdate(),sysdate()),
(20, 'tr', 'MessageManagement','Send Message Management','m@mail.com','m@mail.com',sysdate(),sysdate()),
(21, 'tr', 'TemplateManagement','Template Management','m@mail.com','m@mail.com',sysdate(),sysdate()),
(22, 'tr', 'EmailCollection','Email Collection Builder','m@mail.com','m@mail.com',sysdate(),sysdate()),
(23, 'tr', 'EmailModule','Email Module Builder','m@mail.com','m@mail.com',sysdate(),sysdate()),
(24, 'tr', 'EmailTemplate','Email Template Builder','m@mail.com','m@mail.com',sysdate(),sysdate()),
(25, 'tr', 'Approval enter','Approval Center','m@mail.com','m@mail.com',sysdate(),sysdate()),
(26, 'tr', 'UserManagement','User Management','m@mail.com','m@mail.com',sysdate(),sysdate()),
#(27, 'tr', 'SiteManagement','Site Management','m@mail.com','m@mail.com',sysdate(),sysdate()),
(28, 'tr', 'SystemSettings','System Settings','m@mail.com','m@mail.com',sysdate(),sysdate()),
# Indonesia (IND) feature permissions
(29, 'ind', 'Authority','Authority feature','m@mail.com','m@mail.com',sysdate(),sysdate()),
(30, 'ind', 'UserGroupManagement','User Group Management','m@mail.com','m@mail.com',sysdate(),sysdate()),
(31, 'ind', 'UserManagement','User Management','m@mail.com','m@mail.com',sysdate(),sysdate()),
(32, 'ind', 'SiteManagement','Site Management','m@mail.com','m@mail.com',sysdate(),sysdate())
;

insert into `site_function`(
    `id`,
    `tenant_id`,
    `func_name`,
    `func_desc`,
    `func_verb`,
    `func_url`,
    `created_by`,
    `modified_by`,
    `created_at`,
    `modified_at`
) values
# Super Admin functions
# Authority function
(1, '', 'create','Authority create','POST','/authority/create','m@mail.com','m@mail.com',sysdate(),sysdate()),
(2, '', 'update','Authority update','POST','/authority/update','m@mail.com','m@mail.com',sysdate(),sysdate()),
(3, '', 'search','Authority search','POST','/authority/search','m@mail.com','m@mail.com',sysdate(),sysdate()),
(4, '', 'get','Authority get','GET','/authority/get','m@mail.com','m@mail.com',sysdate(),sysdate()),
(5, '', 'delete','Authority delete','DELETE','/authority/delete','m@mail.com','m@mail.com',sysdate(),sysdate()),
# User Group function
(6, '', 'search','User Group search','POST','/customer-group/list','m@mail.com','m@mail.com',sysdate(),sysdate()),
(7, '', 'get','User Group get','GET','/customer-group/get','m@mail.com','m@mail.com',sysdate(),sysdate()),
(8, '', 'add','User Group add','POST','/customer-group/add','m@mail.com','m@mail.com',sysdate(),sysdate()),
(9, '', 'modify','User Group modify','POST','/customer-group/modify','m@mail.com','m@mail.com',sysdate(),sysdate()),
(10, '', 'delete','User Group delete','DELETE','/customer-group/delete','m@mail.com','m@mail.com',sysdate(),sysdate()),
(11, '', 'count','User Group count','POST','/customer-group/count','m@mail.com','m@mail.com',sysdate(),sysdate()),
(12, '', 'upload','User Group upload','POST','/customer-group/upload','m@mail.com','m@mail.com',sysdate(),sysdate()),
(13, '', 'tree','User Group download tree','GET','/customer-group/download/tree','m@mail.com','m@mail.com',sysdate(),sysdate()),
(14, '', 'create','User Group download create','POST','/customer-group/download/create','m@mail.com','m@mail.com',sysdate(),sysdate()),
(15, '', 'get','User Group download get','GET','/customer-group/download/get','m@mail.com','m@mail.com',sysdate(),sysdate()),
(16, '', 'search','User Group download search','POST','/customer-group/download/list','m@mail.com','m@mail.com',sysdate(),sysdate()),
(17, '', 'apply','User Group download apply','POST','/customer-group/download/apply','m@mail.com','m@mail.com',sysdate(),sysdate()),
(18, '', 'download','User Group download','POST','/customer-group/download','m@mail.com','m@mail.com',sysdate(),sysdate()),
# Push Message function
(19, '', 'push','Push Message','POST','/push','m@mail.com','m@mail.com',sysdate(),sysdate()),
(20, '', 'try','Push Message try','POST','/push/try','m@mail.com','m@mail.com',sysdate(),sysdate()),
(21, '', 'search','Push Message search','POST','/push/search','m@mail.com','m@mail.com',sysdate(),sysdate()),
(22, '', 'count','Push Message count','POST','/push/count','m@mail.com','m@mail.com',sysdate(),sysdate()),
(23, '', 'search','Push Audit Message search','POST','/push/audit/search','m@mail.com','m@mail.com',sysdate(),sysdate()),
(24, '', 'audits','Push Audits Message','POST','/push/audits','m@mail.com','m@mail.com',sysdate(),sysdate()),
(25, '', 'audit','Push Audit Message','POST','/push/audit','m@mail.com','m@mail.com',sysdate(),sysdate()),
(26, '', 'get','Push Audit Message get','GET','/push/audit/get','m@mail.com','m@mail.com',sysdate(),sysdate()),
(27, '', 'get-flows','Push Audit Message get-flows','GET','/push/audit/get-flows','m@mail.com','m@mail.com',sysdate(),sysdate()),
# Push Coupon function
(28, '', 'send','Push Coupon send','POST','/push/coupon/send','m@mail.com','m@mail.com',sysdate(),sysdate()),
(29, '', 'search','Push Coupon search','POST','/push/coupon/search','m@mail.com','m@mail.com',sysdate(),sysdate()),
# Template Management function
(30, '', 'create','Message Template create','POST','/message/template/create','m@mail.com','m@mail.com',sysdate(),sysdate()),
(31, '', 'update','Message Template update','POST','/message/template/update','m@mail.com','m@mail.com',sysdate(),sysdate()),
(32, '', 'search','Message Template search','POST','/message/template/search','m@mail.com','m@mail.com',sysdate(),sysdate()),
(33, '', 'all','Message Template all','GET','/message/template/all','m@mail.com','m@mail.com',sysdate(),sysdate()),
(34, '', 'get','Message Template get','GET','/message/template/get','m@mail.com','m@mail.com',sysdate(),sysdate()),
(35, '', 'delete','Message Template delete','DELETE','/message/template/delete','m@mail.com','m@mail.com',sysdate(),sysdate()),
(36, '', 'upload','Message Template upload','POST','/message/image/upload','m@mail.com','m@mail.com',sysdate(),sysdate()),
(37, '', 'email upload','Message Template email upload','POST','/message/email/upload','m@mail.com','m@mail.com',sysdate(),sysdate()),
(38, '', 'email status','Message Template email status','GET','/message/email/status','m@mail.com','m@mail.com',sysdate(),sysdate()),
(39, '', 't','Message Template t','GET','/message/template/t','m@mail.com','m@mail.com',sysdate(),sysdate()),
(40, '', 'run','Message Template run','GET','/message/template/run','m@mail.com','m@mail.com',sysdate(),sysdate()),
# Email Collection functions
(41, '', 'create','Email Collection create','POST','/builder/collection/create','m@mail.com','m@mail.com',sysdate(),sysdate()),
(42, '', 'update','Email Collection update','POST','/builder/collection/update','m@mail.com','m@mail.com',sysdate(),sysdate()),
(43, '', 'get','Email Collection get','GET','/builder/collection/get','m@mail.com','m@mail.com',sysdate(),sysdate()),
(44, '', 'search','Email Collection search','GET','/builder/collection/list','m@mail.com','m@mail.com',sysdate(),sysdate()),
(45, '', 'delete','Email Collection delete','DELETE','/builder/collection/delete','m@mail.com','m@mail.com',sysdate(),sysdate()),
# Email Module functions
(46, '', 'create','Email Module create','POST','/builder/module/create','m@mail.com','m@mail.com',sysdate(),sysdate()),
(47, '', 'update','Email Module update','POST','/builder/module/update','m@mail.com','m@mail.com',sysdate(),sysdate()),
(48, '', 'search','Email Module search','POST','/builder/module/search','m@mail.com','m@mail.com',sysdate(),sysdate()),
(49, '', 'get','Email Module get','GET','/builder/module/get','m@mail.com','m@mail.com',sysdate(),sysdate()),
(50, '', 'delete','Email Module delete','DELETE','/builder/module/delete','m@mail.com','m@mail.com',sysdate(),sysdate()),
(51, '', 'search','Email Module search','GET','/builder/module/category/list','m@mail.com','m@mail.com',sysdate(),sysdate()),
# Email Template functions
(52, '', 'create','Email Template create','POST','/builder/template/create','m@mail.com','m@mail.com',sysdate(),sysdate()),
(53, '', 'update','Email Template update','POST','/builder/template/update','m@mail.com','m@mail.com',sysdate(),sysdate()),
(54, '', 'search','Email Template search','POST','/builder/template/search','m@mail.com','m@mail.com',sysdate(),sysdate()),
(55, '', 'get','Email Template get','GET','/builder/template/get','m@mail.com','m@mail.com',sysdate(),sysdate()),
(56, '', 'delete','Email Template delete','DELETE','/builder/template/delete','m@mail.com','m@mail.com',sysdate(),sysdate()),
(57, '', 'support-languages','Email Template support-languages','GET','/builder/template/support-languages','m@mail.com','m@mail.com',sysdate(),sysdate()),
(58, '', 'support-regions','Email Template support-regions','GET','/builder/template/support-regions','m@mail.com','m@mail.com',sysdate(),sysdate()),
(59, '', 'language-codes-mapping','Email Template language-codes-mapping','GET','/builder/tempalte/language-codes-mapping','m@mail.com','m@mail.com',sysdate(),sysdate()),
# Approval Center functions

# User Management
(60, '', 'search','User Management search','GET','/user/search','m@mail.com','m@mail.com',sysdate(),sysdate()),
(61, '', 'create','User Management create','POST','/user/create','m@mail.com','m@mail.com',sysdate(),sysdate()),
(62, '', 'update','User Management update','POST','/user/update','m@mail.com','m@mail.com',sysdate(),sysdate()),
(63, '', 'delete','User Management delete','DELETE','/user/delete','m@mail.com','m@mail.com',sysdate(),sysdate()),

# Site Management
(64, '', 'search','Site Management search','GET','/site/search','m@mail.com','m@mail.com',sysdate(),sysdate()),
(65, '', 'create','Site Management create','POST','/site/create','m@mail.com','m@mail.com',sysdate(),sysdate()),
(66, '', 'update','Site Management update','POST','/site/update','m@mail.com','m@mail.com',sysdate(),sysdate()),

# System Settings
(67, '', 'search','System Settings search','GET','/site-setting/search','m@mail.com','m@mail.com',sysdate(),sysdate()),
(68, '', 'create','System Settings create','POST','/site-setting/create','m@mail.com','m@mail.com',sysdate(),sysdate()),
(69, '', 'update','System Settings update','POST','/site-setting/update','m@mail.com','m@mail.com',sysdate(),sysdate()),
(70, '', 'delete','System Settings delete','DELETE','/site-setting/delete','m@mail.com','m@mail.com',sysdate(),sysdate()),
# End Super Admin functions

# Turkey functions
# Authority function
(71, 'tr', 'create','Authority create','POST','/authority/create','m@mail.com','m@mail.com',sysdate(),sysdate()),
(72, 'tr', 'update','Authority update','POST','/authority/update','m@mail.com','m@mail.com',sysdate(),sysdate()),
(73, 'tr', 'search','Authority search','POST','/authority/search','m@mail.com','m@mail.com',sysdate(),sysdate()),
(74, 'tr', 'get','Authority get','GET','/authority/get','m@mail.com','m@mail.com',sysdate(),sysdate()),
(75, 'tr', 'delete','Authority delete','DELETE','/authority/delete','m@mail.com','m@mail.com',sysdate(),sysdate()),
# User Group function
(76, 'tr', 'search','User Group search','POST','/customer-group/list','m@mail.com','m@mail.com',sysdate(),sysdate()),
(77, 'tr', 'get','User Group get','GET','/customer-group/get','m@mail.com','m@mail.com',sysdate(),sysdate()),
(78, 'tr', 'add','User Group add','POST','/customer-group/add','m@mail.com','m@mail.com',sysdate(),sysdate()),
(79, 'tr', 'modify','User Group modify','POST','/customer-group/modify','m@mail.com','m@mail.com',sysdate(),sysdate()),
(80, 'tr', 'delete','User Group delete','DELETE','/customer-group/delete','m@mail.com','m@mail.com',sysdate(),sysdate()),
(81, 'tr', 'count','User Group count','POST','/customer-group/count','m@mail.com','m@mail.com',sysdate(),sysdate()),
(82, 'tr', 'upload','User Group upload','POST','/customer-group/upload','m@mail.com','m@mail.com',sysdate(),sysdate()),
(83, 'tr', 'tree','User Group download tree','GET','/customer-group/download/tree','m@mail.com','m@mail.com',sysdate(),sysdate()),
(84, 'tr', 'create','User Group download create','POST','/customer-group/download/create','m@mail.com','m@mail.com',sysdate(),sysdate()),
(85, 'tr', 'get','User Group download get','GET','/customer-group/download/get','m@mail.com','m@mail.com',sysdate(),sysdate()),
(86, 'tr', 'search','User Group download search','POST','/customer-group/download/list','m@mail.com','m@mail.com',sysdate(),sysdate()),
(87, 'tr', 'apply','User Group download apply','POST','/customer-group/download/apply','m@mail.com','m@mail.com',sysdate(),sysdate()),
(88, 'tr', 'download','User Group download','POST','/customer-group/download','m@mail.com','m@mail.com',sysdate(),sysdate()),
# Push Message function
(89, 'tr', 'push','Push Message','POST','/push','m@mail.com','m@mail.com',sysdate(),sysdate()),
(90, 'tr', 'try','Push Message try','POST','/push/try','m@mail.com','m@mail.com',sysdate(),sysdate()),
(91, 'tr', 'search','Push Message search','POST','/push/search','m@mail.com','m@mail.com',sysdate(),sysdate()),
(92, 'tr', 'count','Push Message count','POST','/push/count','m@mail.com','m@mail.com',sysdate(),sysdate()),
(93, 'tr', 'search','Push Audit Message search','POST','/push/audit/search','m@mail.com','m@mail.com',sysdate(),sysdate()),
(94, 'tr', 'audits','Push Audits Message','POST','/push/audits','m@mail.com','m@mail.com',sysdate(),sysdate()),
(95, 'tr', 'audit','Push Audit Message','POST','/push/audit','m@mail.com','m@mail.com',sysdate(),sysdate()),
(96, 'tr', 'get','Push Audit Message get','GET','/push/audit/get','m@mail.com','m@mail.com',sysdate(),sysdate()),
(97, 'tr', 'get-flows','Push Audit Message get-flows','GET','/push/audit/get-flows','m@mail.com','m@mail.com',sysdate(),sysdate()),
# Push Coupon function
(98, 'tr', 'send','Push Coupon send','POST','/push/coupon/send','m@mail.com','m@mail.com',sysdate(),sysdate()),
(99, 'tr', 'search','Push Coupon search','POST','/push/coupon/search','m@mail.com','m@mail.com',sysdate(),sysdate()),
# Template Management function
(100, 'tr', 'create','Message Template create','POST','/message/template/create','m@mail.com','m@mail.com',sysdate(),sysdate()),
(101, 'tr', 'update','Message Template update','POST','/message/template/update','m@mail.com','m@mail.com',sysdate(),sysdate()),
(102, 'tr', 'search','Message Template search','POST','/message/template/search','m@mail.com','m@mail.com',sysdate(),sysdate()),
(103, 'tr', 'all','Message Template all','GET','/message/template/all','m@mail.com','m@mail.com',sysdate(),sysdate()),
(104, 'tr', 'get','Message Template get','GET','/message/template/get','m@mail.com','m@mail.com',sysdate(),sysdate()),
(105, 'tr', 'delete','Message Template delete','DELETE','/message/template/delete','m@mail.com','m@mail.com',sysdate(),sysdate()),
(106, 'tr', 'upload','Message Template upload','POST','/message/image/upload','m@mail.com','m@mail.com',sysdate(),sysdate()),
(107, 'tr', 'email upload','Message Template email upload','POST','/message/email/upload','m@mail.com','m@mail.com',sysdate(),sysdate()),
(108, 'tr', 'email status','Message Template email status','GET','/message/email/status','m@mail.com','m@mail.com',sysdate(),sysdate()),
(109, 'tr', 't','Message Template t','GET','/message/template/t','m@mail.com','m@mail.com',sysdate(),sysdate()),
(110, 'tr', 'run','Message Template run','GET','/message/template/run','m@mail.com','m@mail.com',sysdate(),sysdate()),
# Email Collection functions
(111, 'tr', 'create','Email Collection create','POST','/builder/collection/create','m@mail.com','m@mail.com',sysdate(),sysdate()),
(112, 'tr', 'update','Email Collection update','POST','/builder/collection/update','m@mail.com','m@mail.com',sysdate(),sysdate()),
(113, 'tr', 'get','Email Collection get','GET','/builder/collection/get','m@mail.com','m@mail.com',sysdate(),sysdate()),
(114, 'tr', 'search','Email Collection search','GET','/builder/collection/list','m@mail.com','m@mail.com',sysdate(),sysdate()),
(115, 'tr', 'delete','Email Collection delete','DELETE','/builder/collection/delete','m@mail.com','m@mail.com',sysdate(),sysdate()),
# Email Module functions
(116, 'tr', 'create','Email Module create','POST','/builder/module/create','m@mail.com','m@mail.com',sysdate(),sysdate()),
(117, 'tr', 'update','Email Module update','POST','/builder/module/update','m@mail.com','m@mail.com',sysdate(),sysdate()),
(118, 'tr', 'search','Email Module search','POST','/builder/module/search','m@mail.com','m@mail.com',sysdate(),sysdate()),
(119, 'tr', 'get','Email Module get','GET','/builder/module/get','m@mail.com','m@mail.com',sysdate(),sysdate()),
(120, 'tr', 'delete','Email Module delete','DELETE','/builder/module/delete','m@mail.com','m@mail.com',sysdate(),sysdate()),
(121, 'tr', 'search','Email Module search','GET','/builder/module/category/list','m@mail.com','m@mail.com',sysdate(),sysdate()),
# Email Template functions
(122, 'tr', 'create','Email Template create','POST','/builder/template/create','m@mail.com','m@mail.com',sysdate(),sysdate()),
(123, 'tr', 'update','Email Template update','POST','/builder/template/update','m@mail.com','m@mail.com',sysdate(),sysdate()),
(124, 'tr', 'search','Email Template search','POST','/builder/template/search','m@mail.com','m@mail.com',sysdate(),sysdate()),
(125, 'tr', 'get','Email Template get','GET','/builder/template/get','m@mail.com','m@mail.com',sysdate(),sysdate()),
(126, 'tr', 'delete','Email Template delete','DELETE','/builder/template/delete','m@mail.com','m@mail.com',sysdate(),sysdate()),
(127, 'tr', 'support-languages','Email Template support-languages','GET','/builder/template/support-languages','m@mail.com','m@mail.com',sysdate(),sysdate()),
(128, 'tr', 'support-regions','Email Template support-regions','GET','/builder/template/support-regions','m@mail.com','m@mail.com',sysdate(),sysdate()),
(129, 'tr', 'language-codes-mapping','Email Template language-codes-mapping','GET','/builder/tempalte/language-codes-mapping','m@mail.com','m@mail.com',sysdate(),sysdate()),
# Approval Center functions

# User Management
(130, 'tr', 'search','User Management search','GET','/user/search','m@mail.com','m@mail.com',sysdate(),sysdate()),
(131, 'tr', 'create','User Management create','POST','/user/create','m@mail.com','m@mail.com',sysdate(),sysdate()),
(132, 'tr', 'update','User Management update','POST','/user/update','m@mail.com','m@mail.com',sysdate(),sysdate()),
(133, 'tr', 'delete','User Management delete','DELETE','/user/delete','m@mail.com','m@mail.com',sysdate(),sysdate()),

# Site Management
(134, 'tr', 'search','Site Management search','GET','/site/search','m@mail.com','m@mail.com',sysdate(),sysdate()),
(135, 'tr', 'create','Site Management create','POST','/site/create','m@mail.com','m@mail.com',sysdate(),sysdate()),
(136, 'tr', 'update','Site Management update','POST','/site/update','m@mail.com','m@mail.com',sysdate(),sysdate()),

# System Settings
(137, 'tr', 'search','System Settings search','GET','/site-setting/search','m@mail.com','m@mail.com',sysdate(),sysdate()),
(138, 'tr', 'create','System Settings create','POST','/site-setting/create','m@mail.com','m@mail.com',sysdate(),sysdate()),
(139, 'tr', 'update','System Settings update','POST','/site-setting/update','m@mail.com','m@mail.com',sysdate(),sysdate()),
(140, 'tr', 'delete','System Settings delete','DELETE','/site-setting/delete','m@mail.com','m@mail.com',sysdate(),sysdate()),
# End Turkey functions


# Indonesia functions
# Authority function
(141, 'ind', 'create','Authority create','POST','/authority/create','m@mail.com','m@mail.com',sysdate(),sysdate()),
(142, 'ind', 'update','Authority update','POST','/authority/update','m@mail.com','m@mail.com',sysdate(),sysdate()),
(143, 'ind', 'search','Authority search','POST','/authority/search','m@mail.com','m@mail.com',sysdate(),sysdate()),
(144, 'ind', 'get','Authority get','GET','/authority/get','m@mail.com','m@mail.com',sysdate(),sysdate()),
(145, 'ind', 'delete','Authority delete','DELETE','/authority/delete','m@mail.com','m@mail.com',sysdate(),sysdate()),
# User Group function
(146, 'ind', 'search','User Group search','POST','/customer-group/list','m@mail.com','m@mail.com',sysdate(),sysdate()),
(147, 'ind', 'get','User Group get','GET','/customer-group/get','m@mail.com','m@mail.com',sysdate(),sysdate()),
(148, 'ind', 'add','User Group add','POST','/customer-group/add','m@mail.com','m@mail.com',sysdate(),sysdate()),
(149, 'ind', 'modify','User Group modify','POST','/customer-group/modify','m@mail.com','m@mail.com',sysdate(),sysdate()),
(150, 'ind', 'delete','User Group delete','DELETE','/customer-group/delete','m@mail.com','m@mail.com',sysdate(),sysdate()),
(151, 'ind', 'count','User Group count','POST','/customer-group/count','m@mail.com','m@mail.com',sysdate(),sysdate()),
(152, 'ind', 'upload','User Group upload','POST','/customer-group/upload','m@mail.com','m@mail.com',sysdate(),sysdate()),
(153, 'ind', 'tree','User Group download tree','GET','/customer-group/download/tree','m@mail.com','m@mail.com',sysdate(),sysdate()),
(154, 'ind', 'create','User Group download create','POST','/customer-group/download/create','m@mail.com','m@mail.com',sysdate(),sysdate()),
(155, 'ind', 'get','User Group download get','GET','/customer-group/download/get','m@mail.com','m@mail.com',sysdate(),sysdate()),
(156, 'ind', 'search','User Group download search','POST','/customer-group/download/list','m@mail.com','m@mail.com',sysdate(),sysdate()),
(157, 'ind', 'apply','User Group download apply','POST','/customer-group/download/apply','m@mail.com','m@mail.com',sysdate(),sysdate()),
(158, 'ind', 'download','User Group download','POST','/customer-group/download','m@mail.com','m@mail.com',sysdate(),sysdate()),
# Push Message function
(159, 'ind', 'push','Push Message','POST','/push','m@mail.com','m@mail.com',sysdate(),sysdate()),
(160, 'ind', 'try','Push Message try','POST','/push/try','m@mail.com','m@mail.com',sysdate(),sysdate()),
(161, 'ind', 'search','Push Message search','POST','/push/search','m@mail.com','m@mail.com',sysdate(),sysdate()),
(162, 'ind', 'count','Push Message count','POST','/push/count','m@mail.com','m@mail.com',sysdate(),sysdate()),
(163, 'ind', 'search','Push Audit Message search','POST','/push/audit/search','m@mail.com','m@mail.com',sysdate(),sysdate()),
(164, 'ind', 'audits','Push Audits Message','POST','/push/audits','m@mail.com','m@mail.com',sysdate(),sysdate()),
(165, 'ind', 'audit','Push Audit Message','POST','/push/audit','m@mail.com','m@mail.com',sysdate(),sysdate()),
(166, 'ind', 'get','Push Audit Message get','GET','/push/audit/get','m@mail.com','m@mail.com',sysdate(),sysdate()),
(167, 'ind', 'get-flows','Push Audit Message get-flows','GET','/push/audit/get-flows','m@mail.com','m@mail.com',sysdate(),sysdate()),
# Push Coupon function
(168, 'ind', 'send','Push Coupon send','POST','/push/coupon/send','m@mail.com','m@mail.com',sysdate(),sysdate()),
(169, 'ind', 'search','Push Coupon search','POST','/push/coupon/search','m@mail.com','m@mail.com',sysdate(),sysdate()),
# Template Management function
(170, 'ind', 'create','Message Template create','POST','/message/template/create','m@mail.com','m@mail.com',sysdate(),sysdate()),
(171, 'ind', 'update','Message Template update','POST','/message/template/update','m@mail.com','m@mail.com',sysdate(),sysdate()),
(172, 'ind', 'search','Message Template search','POST','/message/template/search','m@mail.com','m@mail.com',sysdate(),sysdate()),
(173, 'ind', 'all','Message Template all','GET','/message/template/all','m@mail.com','m@mail.com',sysdate(),sysdate()),
(174, 'ind', 'get','Message Template get','GET','/message/template/get','m@mail.com','m@mail.com',sysdate(),sysdate()),
(175, 'ind', 'delete','Message Template delete','DELETE','/message/template/delete','m@mail.com','m@mail.com',sysdate(),sysdate()),
(176, 'ind', 'upload','Message Template upload','POST','/message/image/upload','m@mail.com','m@mail.com',sysdate(),sysdate()),
(177, 'ind', 'email upload','Message Template email upload','POST','/message/email/upload','m@mail.com','m@mail.com',sysdate(),sysdate()),
(178, 'ind', 'email status','Message Template email status','GET','/message/email/status','m@mail.com','m@mail.com',sysdate(),sysdate()),
(179, 'ind', 't','Message Template t','GET','/message/template/t','m@mail.com','m@mail.com',sysdate(),sysdate()),
(180, 'ind', 'run','Message Template run','GET','/message/template/run','m@mail.com','m@mail.com',sysdate(),sysdate()),
# Email Collection functions
(181, 'ind', 'create','Email Collection create','POST','/builder/collection/create','m@mail.com','m@mail.com',sysdate(),sysdate()),
(182, 'ind', 'update','Email Collection update','POST','/builder/collection/update','m@mail.com','m@mail.com',sysdate(),sysdate()),
(183, 'ind', 'get','Email Collection get','GET','/builder/collection/get','m@mail.com','m@mail.com',sysdate(),sysdate()),
(184, 'ind', 'search','Email Collection search','GET','/builder/collection/list','m@mail.com','m@mail.com',sysdate(),sysdate()),
(185, 'ind', 'delete','Email Collection delete','DELETE','/builder/collection/delete','m@mail.com','m@mail.com',sysdate(),sysdate()),
# Email Module functions
(186, 'ind', 'create','Email Module create','POST','/builder/module/create','m@mail.com','m@mail.com',sysdate(),sysdate()),
(187, 'ind', 'update','Email Module update','POST','/builder/module/update','m@mail.com','m@mail.com',sysdate(),sysdate()),
(188, 'ind', 'search','Email Module search','POST','/builder/module/search','m@mail.com','m@mail.com',sysdate(),sysdate()),
(189, 'ind', 'get','Email Module get','GET','/builder/module/get','m@mail.com','m@mail.com',sysdate(),sysdate()),
(190, 'ind', 'delete','Email Module delete','DELETE','/builder/module/delete','m@mail.com','m@mail.com',sysdate(),sysdate()),
(191, 'ind', 'search','Email Module search','GET','/builder/module/category/list','m@mail.com','m@mail.com',sysdate(),sysdate()),
# Email Template functions
(192, 'ind', 'create','Email Template create','POST','/builder/template/create','m@mail.com','m@mail.com',sysdate(),sysdate()),
(193, 'ind', 'update','Email Template update','POST','/builder/template/update','m@mail.com','m@mail.com',sysdate(),sysdate()),
(194, 'ind', 'search','Email Template search','POST','/builder/template/search','m@mail.com','m@mail.com',sysdate(),sysdate()),
(195, 'ind', 'get','Email Template get','GET','/builder/template/get','m@mail.com','m@mail.com',sysdate(),sysdate()),
(196, 'ind', 'delete','Email Template delete','DELETE','/builder/template/delete','m@mail.com','m@mail.com',sysdate(),sysdate()),
(197, 'ind', 'support-languages','Email Template support-languages','GET','/builder/template/support-languages','m@mail.com','m@mail.com',sysdate(),sysdate()),
(198, 'ind', 'support-regions','Email Template support-regions','GET','/builder/template/support-regions','m@mail.com','m@mail.com',sysdate(),sysdate()),
(199, 'ind', 'language-codes-mapping','Email Template language-codes-mapping','GET','/builder/tempalte/language-codes-mapping','m@mail.com','m@mail.com',sysdate(),sysdate()),
# Approval Center functions

# User Management
(200, 'ind', 'search','User Management search','GET','/user/search','m@mail.com','m@mail.com',sysdate(),sysdate()),
(201, 'ind', 'create','User Management create','POST','/user/create','m@mail.com','m@mail.com',sysdate(),sysdate()),
(202, 'ind', 'update','User Management update','POST','/user/update','m@mail.com','m@mail.com',sysdate(),sysdate()),
(203, 'ind', 'delete','User Management delete','DELETE','/user/delete','m@mail.com','m@mail.com',sysdate(),sysdate()),

# Site Management
(204, 'ind', 'search','Site Management search','GET','/site/search','m@mail.com','m@mail.com',sysdate(),sysdate()),
(205, 'ind', 'create','Site Management create','POST','/site/create','m@mail.com','m@mail.com',sysdate(),sysdate()),
(206, 'ind', 'update','Site Management update','POST','/site/update','m@mail.com','m@mail.com',sysdate(),sysdate()),

# System Settings
(207, 'ind', 'search','System Settings search','GET','/site-setting/search','m@mail.com','m@mail.com',sysdate(),sysdate()),
(208, 'ind', 'create','System Settings create','POST','/site-setting/create','m@mail.com','m@mail.com',sysdate(),sysdate()),
(209, 'ind', 'update','System Settings update','POST','/site-setting/update','m@mail.com','m@mail.com',sysdate(),sysdate()),
(210, 'ind', 'delete','System Settings delete','DELETE','/site-setting/delete','m@mail.com','m@mail.com',sysdate(),sysdate())
# End Indonesia functions

;

insert into `site_permission_function`(
    `id`,
    `tenant_id`,
    `perm_id`,
    `func_id`,
    `created_by`,
    `modified_by`,
    `created_at`,
    `modified_at`
) values
# Super Admin permission function
# Authority permission function
(1,'',1,1,'m@mail.com','m@mail.com',sysdate(),sysdate()),
(2,'',1,2,'m@mail.com','m@mail.com',sysdate(),sysdate()),
(3,'',1,3,'m@mail.com','m@mail.com',sysdate(),sysdate()),
(4,'',1,4,'m@mail.com','m@mail.com',sysdate(),sysdate()),
(5,'',1,5,'m@mail.com','m@mail.com',sysdate(),sysdate()),
# User Group permission function
(6,'',2,6,'m@mail.com','m@mail.com',sysdate(),sysdate()),
(7,'',2,7,'m@mail.com','m@mail.com',sysdate(),sysdate()),
(8,'',2,8,'m@mail.com','m@mail.com',sysdate(),sysdate()),
(9,'',2,9,'m@mail.com','m@mail.com',sysdate(),sysdate()),
(10,'',2,10,'m@mail.com','m@mail.com',sysdate(),sysdate()),
(11,'',2,11,'m@mail.com','m@mail.com',sysdate(),sysdate()),
(12,'',2,12,'m@mail.com','m@mail.com',sysdate(),sysdate()),
(13,'',2,13,'m@mail.com','m@mail.com',sysdate(),sysdate()),
(14,'',2,14,'m@mail.com','m@mail.com',sysdate(),sysdate()),
(15,'',2,15,'m@mail.com','m@mail.com',sysdate(),sysdate()),
(16,'',2,16,'m@mail.com','m@mail.com',sysdate(),sysdate()),
(17,'',2,17,'m@mail.com','m@mail.com',sysdate(),sysdate()),
(18,'',2,18,'m@mail.com','m@mail.com',sysdate(),sysdate()),

# Push Message permission function
(19,'',3,19,'m@mail.com','m@mail.com',sysdate(),sysdate()),
(20,'',3,20,'m@mail.com','m@mail.com',sysdate(),sysdate()),
(21,'',3,21,'m@mail.com','m@mail.com',sysdate(),sysdate()),
(22,'',3,22,'m@mail.com','m@mail.com',sysdate(),sysdate()),
(23,'',3,23,'m@mail.com','m@mail.com',sysdate(),sysdate()),
(24,'',3,24,'m@mail.com','m@mail.com',sysdate(),sysdate()),
(25,'',3,25,'m@mail.com','m@mail.com',sysdate(),sysdate()),
(26,'',3,26,'m@mail.com','m@mail.com',sysdate(),sysdate()),
(27,'',3,27,'m@mail.com','m@mail.com',sysdate(),sysdate()),
# Push Coupon permission function
(28,'',3,28,'m@mail.com','m@mail.com',sysdate(),sysdate()),
(29,'',3,29,'m@mail.com','m@mail.com',sysdate(),sysdate()),

# Template Management permission function
(30,'',4,30,'m@mail.com','m@mail.com',sysdate(),sysdate()),
(31,'',4,31,'m@mail.com','m@mail.com',sysdate(),sysdate()),
(32,'',4,32,'m@mail.com','m@mail.com',sysdate(),sysdate()),
(33,'',4,33,'m@mail.com','m@mail.com',sysdate(),sysdate()),
(34,'',4,34,'m@mail.com','m@mail.com',sysdate(),sysdate()),
(35,'',4,35,'m@mail.com','m@mail.com',sysdate(),sysdate()),
(36,'',4,36,'m@mail.com','m@mail.com',sysdate(),sysdate()),
(37,'',4,37,'m@mail.com','m@mail.com',sysdate(),sysdate()),
(38,'',4,38,'m@mail.com','m@mail.com',sysdate(),sysdate()),
(39,'',4,39,'m@mail.com','m@mail.com',sysdate(),sysdate()),
(40,'',4,40,'m@mail.com','m@mail.com',sysdate(),sysdate()),

# Email Collection permission functions
(41,'',5,41,'m@mail.com','m@mail.com',sysdate(),sysdate()),
(42,'',5,42,'m@mail.com','m@mail.com',sysdate(),sysdate()),
(43,'',5,43,'m@mail.com','m@mail.com',sysdate(),sysdate()),
(44,'',5,44,'m@mail.com','m@mail.com',sysdate(),sysdate()),
(45,'',5,45,'m@mail.com','m@mail.com',sysdate(),sysdate()),

# Email Module functions
(46,'',6,46,'m@mail.com','m@mail.com',sysdate(),sysdate()),
(47,'',6,47,'m@mail.com','m@mail.com',sysdate(),sysdate()),
(48,'',6,48,'m@mail.com','m@mail.com',sysdate(),sysdate()),
(49,'',6,49,'m@mail.com','m@mail.com',sysdate(),sysdate()),
(50,'',6,50,'m@mail.com','m@mail.com',sysdate(),sysdate()),
(51,'',6,51,'m@mail.com','m@mail.com',sysdate(),sysdate()),

# Email Template functions
(52,'',7,52,'m@mail.com','m@mail.com',sysdate(),sysdate()),
(53,'',7,53,'m@mail.com','m@mail.com',sysdate(),sysdate()),
(54,'',7,54,'m@mail.com','m@mail.com',sysdate(),sysdate()),
(55,'',7,55,'m@mail.com','m@mail.com',sysdate(),sysdate()),
(56,'',7,56,'m@mail.com','m@mail.com',sysdate(),sysdate()),
(57,'',7,57,'m@mail.com','m@mail.com',sysdate(),sysdate()),
(58,'',7,58,'m@mail.com','m@mail.com',sysdate(),sysdate()),
(59,'',7,59,'m@mail.com','m@mail.com',sysdate(),sysdate()),

# Approval Center functions

# User Management
(60,'',9,60,'m@mail.com','m@mail.com',sysdate(),sysdate()),
(61,'',9,61,'m@mail.com','m@mail.com',sysdate(),sysdate()),
(62,'',9,62,'m@mail.com','m@mail.com',sysdate(),sysdate()),
(63,'',9,63,'m@mail.com','m@mail.com',sysdate(),sysdate()),

# Site Management
(64,'',10,64,'m@mail.com','m@mail.com',sysdate(),sysdate()),
(65,'',10,65,'m@mail.com','m@mail.com',sysdate(),sysdate()),
(66,'',10,66,'m@mail.com','m@mail.com',sysdate(),sysdate()),

# System Settings
(67,'',11,67,'m@mail.com','m@mail.com',sysdate(),sysdate()),
(68,'',11,68,'m@mail.com','m@mail.com',sysdate(),sysdate()),
(69,'',11,69,'m@mail.com','m@mail.com',sysdate(),sysdate()),
(70,'',11,70,'m@mail.com','m@mail.com',sysdate(),sysdate()),

#--FeatureManagement
#--(5,'',12,5,'m@mail.com','m@mail.com',sysdate(),sysdate()),
#--DataDashboard
#--(5,'',13,5,'m@mail.com','m@mail.com',sysdate(),sysdate()),
#--Datawind
#--(5,'',14,5,'m@mail.com','m@mail.com',sysdate(),sysdate()),
#--BusinessConstraint
#--(5,'',15,5,'m@mail.com','m@mail.com',sysdate(),sysdate()),
#--UserTask
#--(5,'',16,5,'m@mail.com','m@mail.com',sysdate(),sysdate()),
#--Task
#--(5,'',17,5,'m@mail.com','m@mail.com',sysdate(),sysdate()),

#--End Super Admin permissions

#--# Turkey (TR) feature permission
#--# Turkey (TR) Authority permission function
(71,'tr',18,71,'m@mail.com','m@mail.com',sysdate(),sysdate()),
(72,'tr',18,72,'m@mail.com','m@mail.com',sysdate(),sysdate()),
(73,'tr',18,73,'m@mail.com','m@mail.com',sysdate(),sysdate()),
(74,'tr',18,74,'m@mail.com','m@mail.com',sysdate(),sysdate()),
(75,'tr',18,75,'m@mail.com','m@mail.com',sysdate(),sysdate()),
#--# Turkey (TR) User Group permission function
(76,'tr',19,76,'m@mail.com','m@mail.com',sysdate(),sysdate()),
(77,'tr',19,77,'m@mail.com','m@mail.com',sysdate(),sysdate()),
(78,'tr',19,78,'m@mail.com','m@mail.com',sysdate(),sysdate()),
(79,'tr',19,79,'m@mail.com','m@mail.com',sysdate(),sysdate()),
(80,'tr',19,80,'m@mail.com','m@mail.com',sysdate(),sysdate()),
(81,'tr',19,81,'m@mail.com','m@mail.com',sysdate(),sysdate()),
(82,'tr',19,82,'m@mail.com','m@mail.com',sysdate(),sysdate()),
(83,'tr',19,83,'m@mail.com','m@mail.com',sysdate(),sysdate()),
(84,'tr',19,84,'m@mail.com','m@mail.com',sysdate(),sysdate()),
(85,'tr',19,85,'m@mail.com','m@mail.com',sysdate(),sysdate()),
(86,'tr',19,86,'m@mail.com','m@mail.com',sysdate(),sysdate()),
(87,'tr',19,87,'m@mail.com','m@mail.com',sysdate(),sysdate()),
(88,'tr',19,88,'m@mail.com','m@mail.com',sysdate(),sysdate()),

#--# Turkey (TR) Push Message permission function
(89,'tr',20,89,'m@mail.com','m@mail.com',sysdate(),sysdate()),
(90,'tr',20,90,'m@mail.com','m@mail.com',sysdate(),sysdate()),
(91,'tr',20,91,'m@mail.com','m@mail.com',sysdate(),sysdate()),
(92,'tr',20,92,'m@mail.com','m@mail.com',sysdate(),sysdate()),
(93,'tr',20,93,'m@mail.com','m@mail.com',sysdate(),sysdate()),
(94,'tr',20,94,'m@mail.com','m@mail.com',sysdate(),sysdate()),
(95,'tr',20,95,'m@mail.com','m@mail.com',sysdate(),sysdate()),
(96,'tr',20,96,'m@mail.com','m@mail.com',sysdate(),sysdate()),
(97,'tr',20,97,'m@mail.com','m@mail.com',sysdate(),sysdate()),
#--# Turkey (TR) Push Coupon permission function
(98,'tr',20,98,'m@mail.com','m@mail.com',sysdate(),sysdate()),
(99,'tr',20,99,'m@mail.com','m@mail.com',sysdate(),sysdate()),

#--# Turkey (TR) Template Management permission function
(100,'tr',21,100,'m@mail.com','m@mail.com',sysdate(),sysdate()),
(101,'tr',21,101,'m@mail.com','m@mail.com',sysdate(),sysdate()),
(102,'tr',21,102,'m@mail.com','m@mail.com',sysdate(),sysdate()),
(103,'tr',21,103,'m@mail.com','m@mail.com',sysdate(),sysdate()),
(104,'tr',21,104,'m@mail.com','m@mail.com',sysdate(),sysdate()),
(105,'tr',21,105,'m@mail.com','m@mail.com',sysdate(),sysdate()),
(106,'tr',21,106,'m@mail.com','m@mail.com',sysdate(),sysdate()),
(107,'tr',21,107,'m@mail.com','m@mail.com',sysdate(),sysdate()),
(108,'tr',21,108,'m@mail.com','m@mail.com',sysdate(),sysdate()),
(109,'tr',21,109,'m@mail.com','m@mail.com',sysdate(),sysdate()),
(110,'tr',21,110,'m@mail.com','m@mail.com',sysdate(),sysdate()),

#--# Turkey (TR) Email Collection permission functions
(111,'tr',22,111,'m@mail.com','m@mail.com',sysdate(),sysdate()),
(112,'tr',22,112,'m@mail.com','m@mail.com',sysdate(),sysdate()),
(113,'tr',22,113,'m@mail.com','m@mail.com',sysdate(),sysdate()),
(114,'tr',22,114,'m@mail.com','m@mail.com',sysdate(),sysdate()),
(115,'tr',22,115,'m@mail.com','m@mail.com',sysdate(),sysdate()),

#--# Turkey (TR) Email Module functions
(116,'tr',23,116,'m@mail.com','m@mail.com',sysdate(),sysdate()),
(117,'tr',23,117,'m@mail.com','m@mail.com',sysdate(),sysdate()),
(118,'tr',23,118,'m@mail.com','m@mail.com',sysdate(),sysdate()),
(119,'tr',23,119,'m@mail.com','m@mail.com',sysdate(),sysdate()),
(120,'tr',23,120,'m@mail.com','m@mail.com',sysdate(),sysdate()),
(121,'tr',23,121,'m@mail.com','m@mail.com',sysdate(),sysdate()),

#--# Turkey (TR) Email Template functions
(122,'tr',24,122,'m@mail.com','m@mail.com',sysdate(),sysdate()),
(123,'tr',24,123,'m@mail.com','m@mail.com',sysdate(),sysdate()),
(124,'tr',24,124,'m@mail.com','m@mail.com',sysdate(),sysdate()),
(125,'tr',24,125,'m@mail.com','m@mail.com',sysdate(),sysdate()),
(126,'tr',24,126,'m@mail.com','m@mail.com',sysdate(),sysdate()),
(127,'tr',24,127,'m@mail.com','m@mail.com',sysdate(),sysdate()),
(128,'tr',24,128,'m@mail.com','m@mail.com',sysdate(),sysdate()),
(129,'tr',24,129,'m@mail.com','m@mail.com',sysdate(),sysdate()),

#--# Turkey (TR) Approval Center functions

#--# Turkey (TR) User Management
(130,'tr',26,130,'m@mail.com','m@mail.com',sysdate(),sysdate()),
(131,'tr',26,131,'m@mail.com','m@mail.com',sysdate(),sysdate()),
(132,'tr',26,132,'m@mail.com','m@mail.com',sysdate(),sysdate()),
(133,'tr',26,133,'m@mail.com','m@mail.com',sysdate(),sysdate()),

#-- Site Management (# Turkey (TR) has no permission on this feature)
#--(134,'tr',27,64,'m@mail.com','m@mail.com',sysdate(),sysdate()),
#--(135,'tr',27,65,'m@mail.com','m@mail.com',sysdate(),sysdate()),
#--(136,'tr',27,66,'m@mail.com','m@mail.com',sysdate(),sysdate()),

#--# Turkey (TR) System Settings
(137,'tr',28,137,'m@mail.com','m@mail.com',sysdate(),sysdate()),
(138,'tr',28,138,'m@mail.com','m@mail.com',sysdate(),sysdate()),
(139,'tr',28,139,'m@mail.com','m@mail.com',sysdate(),sysdate()),
(140,'tr',28,140,'m@mail.com','m@mail.com',sysdate(),sysdate()),

#--End Turkey (TR) permission functions

#--# Indonesia feature permission
#--# Indonesia (IND) Authority permission function
(141,'ind',29,141,'m@mail.com','m@mail.com',sysdate(),sysdate()),
(142,'ind',29,142,'m@mail.com','m@mail.com',sysdate(),sysdate()),
(143,'ind',29,143,'m@mail.com','m@mail.com',sysdate(),sysdate()),
(144,'ind',29,144,'m@mail.com','m@mail.com',sysdate(),sysdate()),
(145,'ind',29,145,'m@mail.com','m@mail.com',sysdate(),sysdate()),
#--# Indonesia (IND) User Group permission function
(146,'ind',30,146,'m@mail.com','m@mail.com',sysdate(),sysdate()),
(147,'ind',30,147,'m@mail.com','m@mail.com',sysdate(),sysdate()),
(148,'ind',30,148,'m@mail.com','m@mail.com',sysdate(),sysdate()),
(149,'ind',30,149,'m@mail.com','m@mail.com',sysdate(),sysdate()),
(150,'ind',30,150,'m@mail.com','m@mail.com',sysdate(),sysdate()),
(151,'ind',30,151,'m@mail.com','m@mail.com',sysdate(),sysdate()),
(152,'ind',30,152,'m@mail.com','m@mail.com',sysdate(),sysdate()),
(153,'ind',30,153,'m@mail.com','m@mail.com',sysdate(),sysdate()),
(154,'ind',30,154,'m@mail.com','m@mail.com',sysdate(),sysdate()),
(155,'ind',30,155,'m@mail.com','m@mail.com',sysdate(),sysdate()),
(156,'ind',30,156,'m@mail.com','m@mail.com',sysdate(),sysdate()),
(157,'ind',30,157,'m@mail.com','m@mail.com',sysdate(),sysdate()),
(158,'ind',30,158,'m@mail.com','m@mail.com',sysdate(),sysdate()),

#--# Indonesia (IND) Push Message limit permissions
#--(89,'ind',20,19,'m@mail.com','m@mail.com',sysdate(),sysdate()),
#--(90,'ind',20,20,'m@mail.com','m@mail.com',sysdate(),sysdate()),
#--(91,'ind',20,21,'m@mail.com','m@mail.com',sysdate(),sysdate()),
#--(92,'ind',20,22,'m@mail.com','m@mail.com',sysdate(),sysdate()),
#--(93,'ind',20,23,'m@mail.com','m@mail.com',sysdate(),sysdate()),
#--(94,'ind',20,24,'m@mail.com','m@mail.com',sysdate(),sysdate()),
#--(95,'ind',20,25,'m@mail.com','m@mail.com',sysdate(),sysdate()),
#--(96,'ind',20,26,'m@mail.com','m@mail.com',sysdate(),sysdate()),
#--(97,'ind',20,27,'m@mail.com','m@mail.com',sysdate(),sysdate()),
#--#--# Indonesia (IND) Push Coupon permission function
#--(98,'ind',20,28,'m@mail.com','m@mail.com',sysdate(),sysdate()),
#--(99,'ind',20,29,'m@mail.com','m@mail.com',sysdate(),sysdate()),

#--# Indonesia (IND) Template Management limit permissions
#--(100,'ind',21,30,'m@mail.com','m@mail.com',sysdate(),sysdate()),
#--(101,'ind',21,31,'m@mail.com','m@mail.com',sysdate(),sysdate()),
#--(102,'ind',21,32,'m@mail.com','m@mail.com',sysdate(),sysdate()),
#--(103,'ind',21,33,'m@mail.com','m@mail.com',sysdate(),sysdate()),
#--(104,'ind',21,34,'m@mail.com','m@mail.com',sysdate(),sysdate()),
#--(105,'ind',21,35,'m@mail.com','m@mail.com',sysdate(),sysdate()),
#--(106,'ind',21,36,'m@mail.com','m@mail.com',sysdate(),sysdate()),
#--(107,'ind',21,37,'m@mail.com','m@mail.com',sysdate(),sysdate()),
#--(108,'ind',21,38,'m@mail.com','m@mail.com',sysdate(),sysdate()),
#--(109,'ind',21,39,'m@mail.com','m@mail.com',sysdate(),sysdate()),
#--(110,'ind',21,40,'m@mail.com','m@mail.com',sysdate(),sysdate()),
#--
#--#--# Indonesia (IND) Email Collection limit permissions
#--(111,'ind',22,41,'m@mail.com','m@mail.com',sysdate(),sysdate()),
#--(112,'ind',22,42,'m@mail.com','m@mail.com',sysdate(),sysdate()),
#--(113,'ind',22,43,'m@mail.com','m@mail.com',sysdate(),sysdate()),
#--(114,'ind',22,44,'m@mail.com','m@mail.com',sysdate(),sysdate()),
#--(115,'ind',22,45,'m@mail.com','m@mail.com',sysdate(),sysdate()),

#--# Indonesia (IND) Email Module limit permissions
#--(116,'ind',23,46,'m@mail.com','m@mail.com',sysdate(),sysdate()),
#--(117,'ind',23,47,'m@mail.com','m@mail.com',sysdate(),sysdate()),
#--(118,'ind',23,48,'m@mail.com','m@mail.com',sysdate(),sysdate()),
#--(119,'ind',23,49,'m@mail.com','m@mail.com',sysdate(),sysdate()),
#--(120,'ind',23,50,'m@mail.com','m@mail.com',sysdate(),sysdate()),
#--(121,'ind',23,51,'m@mail.com','m@mail.com',sysdate(),sysdate()),
#--
#--#--# Indonesia (IND) Email Template limit permissions
#--(122,'ind',24,52,'m@mail.com','m@mail.com',sysdate(),sysdate()),
#--(123,'ind',24,53,'m@mail.com','m@mail.com',sysdate(),sysdate()),
#--(124,'ind',24,54,'m@mail.com','m@mail.com',sysdate(),sysdate()),
#--(125,'ind',24,55,'m@mail.com','m@mail.com',sysdate(),sysdate()),
#--(126,'ind',24,56,'m@mail.com','m@mail.com',sysdate(),sysdate()),
#--(127,'ind',24,57,'m@mail.com','m@mail.com',sysdate(),sysdate()),
#--(128,'ind',24,58,'m@mail.com','m@mail.com',sysdate(),sysdate()),
#--(129,'ind',24,59,'m@mail.com','m@mail.com',sysdate(),sysdate()),

#--# Indonesia (IND) Approval Center limit permissions

#--# Indonesia (IND) User Management
(159,'ind',31,200,'m@mail.com','m@mail.com',sysdate(),sysdate()),
(160,'ind',31,201,'m@mail.com','m@mail.com',sysdate(),sysdate()),
(161,'ind',31,202,'m@mail.com','m@mail.com',sysdate(),sysdate()),
(162,'ind',31,203,'m@mail.com','m@mail.com',sysdate(),sysdate()),

#-- Site Management (# Indonesia (IND) limit permissions )
#--(134,'ind',27,64,'m@mail.com','m@mail.com',sysdate(),sysdate()),
#--(135,'ind',27,65,'m@mail.com','m@mail.com',sysdate(),sysdate()),
#--(136,'ind',27,66,'m@mail.com','m@mail.com',sysdate(),sysdate()),

#--# Indonesia (IND) System Settings
(163,'ind',32,207,'m@mail.com','m@mail.com',sysdate(),sysdate()),
(164,'ind',32,208,'m@mail.com','m@mail.com',sysdate(),sysdate()),
(165,'ind',32,209,'m@mail.com','m@mail.com',sysdate(),sysdate()),
(166,'ind',32,210,'m@mail.com','m@mail.com',sysdate(),sysdate())

#--End Indonesia (IND) permission functions

;

insert into `site_role_permission`(
    `id`,
    `tenant_id`,
    `role`,
    `perm_id`,
    `created_by`,
    `modified_by`,
    `created_at`,
    `modified_at`
) values
#-- Default Super Admin role permissions
(1,'',1,1,'m@mail.com','m@mail.com',sysdate(),sysdate()),
(2,'',1,2,'m@mail.com','m@mail.com',sysdate(),sysdate()),
(3,'',1,3,'m@mail.com','m@mail.com',sysdate(),sysdate()),
(4,'',1,4,'m@mail.com','m@mail.com',sysdate(),sysdate()),
(5,'',1,5,'m@mail.com','m@mail.com',sysdate(),sysdate()),
(6,'',1,6,'m@mail.com','m@mail.com',sysdate(),sysdate()),
(7,'',1,7,'m@mail.com','m@mail.com',sysdate(),sysdate()),
(8,'',1,8,'m@mail.com','m@mail.com',sysdate(),sysdate()),
(9,'',1,9,'m@mail.com','m@mail.com',sysdate(),sysdate()),
(10,'',1,10,'m@mail.com','m@mail.com',sysdate(),sysdate()),
(11,'',1,11,'m@mail.com','m@mail.com',sysdate(),sysdate()),
(12,'',1,12,'m@mail.com','m@mail.com',sysdate(),sysdate()),
(13,'',1,13,'m@mail.com','m@mail.com',sysdate(),sysdate()),
(14,'',1,14,'m@mail.com','m@mail.com',sysdate(),sysdate()),
(15,'',1,15,'m@mail.com','m@mail.com',sysdate(),sysdate()),
(16,'',1,16,'m@mail.com','m@mail.com',sysdate(),sysdate()),
(17,'',1,17,'m@mail.com','m@mail.com',sysdate(),sysdate()),
#-- Default Turkey (TR) Admin role permissions
(18,'tr',2,18,'m@mail.com','m@mail.com',sysdate(),sysdate()),
(19,'tr',2,19,'m@mail.com','m@mail.com',sysdate(),sysdate()),
(20,'tr',2,20,'m@mail.com','m@mail.com',sysdate(),sysdate()),
(21,'tr',2,21,'m@mail.com','m@mail.com',sysdate(),sysdate()),
(22,'tr',2,22,'m@mail.com','m@mail.com',sysdate(),sysdate()),
(23,'tr',2,23,'m@mail.com','m@mail.com',sysdate(),sysdate()),
(24,'tr',2,24,'m@mail.com','m@mail.com',sysdate(),sysdate()),
(25,'tr',2,25,'m@mail.com','m@mail.com',sysdate(),sysdate()),
(26,'tr',2,26,'m@mail.com','m@mail.com',sysdate(),sysdate()),
#--(27,'tr',2,27,'m@mail.com','m@mail.com',sysdate(),sysdate()),
(28,'tr',2,28,'m@mail.com','m@mail.com',sysdate(),sysdate()),

#-- Default Turkey (TR) Operator role permissions
(29,'tr',3,19,'m@mail.com','m@mail.com',sysdate(),sysdate()),
(30,'tr',3,20,'m@mail.com','m@mail.com',sysdate(),sysdate()),
(31,'tr',3,21,'m@mail.com','m@mail.com',sysdate(),sysdate()),
(32,'tr',3,22,'m@mail.com','m@mail.com',sysdate(),sysdate()),
(33,'tr',3,23,'m@mail.com','m@mail.com',sysdate(),sysdate()),
(34,'tr',3,24,'m@mail.com','m@mail.com',sysdate(),sysdate()),

#-- Default Indonesia (IND) Admin role permissions
(35,'ind',4,29,'m@mail.com','m@mail.com',sysdate(),sysdate()),
(36,'ind',4,30,'m@mail.com','m@mail.com',sysdate(),sysdate()),
(37,'ind',4,31,'m@mail.com','m@mail.com',sysdate(),sysdate()),
(38,'ind',4,32,'m@mail.com','m@mail.com',sysdate(),sysdate()),
#-- Default Indonesia (IND) Operator role permissions
(39,'ind',5,30,'m@mail.com','m@mail.com',sysdate(),sysdate())
;

select count(*) from `site_role_permission`;
select count(*) from `site_function`;
select count(*) from `site_permission`;
select count(*) from `site_permission_function`;
select count(*) from `site_role`;
select count(*) from `site_user`;


