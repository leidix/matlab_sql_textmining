clear; close all; clc;

addpath(genpath('./functions'));
addpath(genpath('./drivers'));
addpath(genpath('./db'));

%%
driverPath = [pwd, '/drivers'];
driverFile = 'sqlite-jdbc-3.30.1.jar';
dbPath = [pwd, '/db'];
dbFile = 'my_recipes.sqlite';
query_db_structure = "";
saveWorkspace = 1;

db = SQLite2struct(driverPath,driverFile,dbPath,dbFile,query_db_structure,saveWorkspace);