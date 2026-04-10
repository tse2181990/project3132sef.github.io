# 在线学习系统 (Online Learning System)

基于 Spring Boot 的在线学习平台，支持课程讲座管理、投票系统和用户权限管理。

## ✨ 功能特性

### 📚 讲座管理 (Lecture)
- 创建、编辑、删除讲座
- 支持上传附件（图片、文档等）
- 讲座评论功能
- 附件下载与管理

### 🗳️ 投票系统 (Poll)
- 创建多选项投票
- 用户投票（支持修改投票）
- 实时查看投票结果
- 投票评论功能

### 👥 用户管理 (User Management)
- 用户注册与登录
- 基于 Spring Security 的角色权限控制
- 支持角色：`ROLE_USER`、`ROLE_ADMIN`、`ROLE_TEACHER`
- 用户信息管理（姓名、邮箱、电话等）

## 🛠️ 技术栈

| 技术 | 版本 | 用途 |
|------|------|------|
| Spring Boot | 3.x | 后端框架 |
| Spring Security | 6.x | 认证与授权 |
| Spring Data JPA | - | 数据持久化 |
| Hibernate | - | ORM 框架 |
| H2 / MySQL | - | 数据库 |
| Thymeleaf | - | 模板引擎（假设） |
| Maven / Gradle | - | 项目构建 |

## 📁 项目结构
