
/*
====================================================

Project:
ShopSphere Enterprise Analytics Warehouse


Script:
Database Creation


Purpose:

Creates the main SQL Server database
and required schemas.

====================================================
*/


CREATE DATABASE ShopSphereDW;
GO


USE ShopSphereDW;
GO



CREATE SCHEMA raw;
GO


CREATE SCHEMA staging;
GO


CREATE SCHEMA dw;
GO


CREATE SCHEMA audit;
GO
