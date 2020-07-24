%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% (C) 2020 by Felix Leidinger
% 
% This function reads the tables from a SQLite database file in the working directory into
% a structure data type variable into the workspace. Optionally, the converted database
% can be saved into a mat file for faster reloading and protection of the original
% database.
% Make sure JDBC driver for SQLite is available!
%
% driver: string or char array of the root path, where the driver jar file is located (e.g. path = pwd)
%
% driverFile: string or char array of the driver jar filename in the path directory, e.g. sqlite-jdbc-3.30.1.jar
%
% dbPath: string or char array of the root path, where the dbFile is located (e.g. path = pwd)
%
% dbFile: string or char array of the database filename in the path directory, e.g. mydatabase.db
%
% query_db_structure: search string to query the root structure of the
% database, e.g. '', or "", or 'main', etc...
%
% saveWorkspace: logical, 0 --> do not save, 1 --> save workspace
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [db] = SQLite2struct(driverPath,driverFile,dbPath,dbFile,query_db_structure,saveWorkspace)

% create a JDBC SQLite connection
databasename = '';
dbFile = fullfile([dbPath '/' dbFile]);
driverFile = fullfile([driverPath '/' driverFile]);
driver = ['org.sqlite.' driverFile]; %'org.sqlite.JDBC';
url = ['jdbc:sqlite:' dbFile];
username = '';
password = '';
conn = database(databasename,username,password,driver,url);

% read the main structure from the database
data = sqlfind(conn,query_db_structure);

% construct a cell array and copy data from the database tables into the respective cell
% field
architecture = cell(length(data.Table),1);
for i = 1:length(data.Table)
     architecture{i} = {};
     architecture{i} = sqlread(conn,data.Table{i});
     architecture{i} = table2struct(architecture{i});
end

% convert to structure and return
db = cell2struct(architecture, data.Table(:));

if saveWorkspace == 1
    save('db_struct.mat','db');
end

% close connection
close(conn)
clear conn