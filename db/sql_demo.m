clear all
close all
clc

%% remove existing database
%delete('tutorial.db')

%% create SQLite Connection
dbfile = fullfile(pwd,'tutorial.db');
conn = sqlite(dbfile,'create');

%% create new tables in SQLite Database File

sqlstring = 'CREATE TABLE inventoryTable (productNumber NUMERIC, Quantity NUMERIC, Price NUMERIC, inventoryDate VARCHAR)';
exec(conn,sqlstring)

sqlstring = 'CREATE TABLE suppliers (SupplierNumber NUMERIC, SupplierName varchar(50), City varchar(20), Country varchar(20), FaxNumber varchar(20))';
exec(conn,sqlstring)

sqlstring = 'CREATE TABLE productTable (productNumber NUMERIC, stockNumber NUMERIC, supplierNumber NUMERIC, unitCost NUMERIC, productDescription varchar(20))';
exec(conn,sqlstring)

%% load new data into SQLite Database tables

load('sqliteworkflowdata.mat')

insert(conn,'inventoryTable', {'productNumber','Quantity','Price','inventoryDate'},CinvTable)

insert(conn,'suppliers', {'SupplierNumber','SupplierName','City','Country','FaxNumber'}, Csuppliers)

insert(conn,'productTable', {'productNumber','stockNumber','supplierNumber','unitCost', 'productDescription'},CprodTable)

clear CinvTable Csuppliers CsalesVol CprodTable

%% close connection
close(conn)
clear conn

%% create a read-only SQLite connection to tutorial.db.
conn = sqlite('tutorial.db','readonly');

%% read data from SQLite database tables

sqlstring = 'SELECT * FROM inventoryTable';
inventoryTable_data = fetch(conn,sqlstring);

sqlstring = 'SELECT * FROM suppliers';
suppliers_data = fetch(conn,sqlstring);

sqlstring = 'SELECT * FROM productTable';
productTable_data = fetch(conn,sqlstring);

sqlstring = 'SELECT productDescription FROM productTable WHERE SupplierNumber = "1011"';
out = fetch(conn,sqlstring);

sqlstring = 'SELECT suppliers.supplierName, productTable.productDescription FROM suppliers INNER JOIN productTable ON suppliers.supplierNumber = productTable.supplierNumber';
out = fetch(conn,sqlstring);

