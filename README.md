# Azure Data Factory

## Resource Group
- Create a resource group named: adf-workshop

## Azure Storage account
- Create a resource group named: adfwstorageaccount
	- Allow hierarchical namespace
- Enter into Data Lake Storage
	- Add container: data (private)
		- Add folders: Source, Destination
		- Upload "Demo2 files" to "Source"
			- See details, edit

## Azure SQL Database
- Create sql db resource named: adf-w-database	
	- username: adf-w-admin
	- password: I****7_
- Create sql db server named: adf-w-dbserver
	- Serverless
	- Allow Azure services and resources to access this server

## Azure Data Factory
- Create a adf resource named: adf-w-datafactory
	- Open data factory studio
	- Navigate options
	- Review Integration Runtime

## Pipelines and activities

### Linked Services
	- In Manage Hub
	- To SQL Server: 
		- Search for sql database
		- Name: az_SQLDB_adf_w_dbserver
		- Copy db server name from db server info: adf-w-dbserver.database.windows.net
		- Copy SQL database from db server: adf-w-database
			- user username/password info
		- Test connection / make sure in networking in dbserver Azure services are allowed
	- To datalake:
		- Search for Data Lake storage Gen2
		- Name: az_ADLS_adfwdatastorage
		- Choose subscription + Storage account
		- Test connection

### Copy Wizard	
	- Objective: copy table content to datalake Destination folder
	- Review Demo1 sql file
	- Go to database (new tab)
		- Query editor -> access (remember allow IP)
		- Review tables, procedures, views
		- Open query -> Load Demo1 sql file
		- Reload -> query to show table content
	- In Author Hub -> Copy Data tool or	In Home Hub -> Ingest
		- Review options
		- Build-in copy task
		- Choose source: All -> the db -> table -> preview
		- Choose destination: 
			- All -> datalake -> Browse -> Destination
			- File name: Emp.csv
		- File format: Review options -> Delimeted , -> Add header
		- Settings: Demo1-CopyWizard -> Review Advanced
		- Resume: review -> Change dafault random db and dl "dataset" names -> Accept
		- Review Datasets
		- Review datalake Destination folder
		- Review Author Hub -> Pipelines -> Review copy block properties, source, sink, mapping, etc

### Metadata Activity
	- Objective: Get metadata: last modified date of file
	- Create a new pipeline: Demo2 - GetMedatadataActivity
		- Remember LinkedServices and its relationship with ADLS and ADB
	- Go to ADLS:
		- Updload Demo2 files to Source ADLS -> preview
	- Add activity: Metadata
		- Change Name: GetLastModifiedDate
		- Settings: rewiew dataset
			- Add new dataset az_ADLS_InputEmptq -> 
				- Linked service -> browse to find file -> first row header -> preview
				- delimited text by pipe "|" -> preview
			- Back to activity Settings -> choose dataset created
				- Field list -> new -> review -> choose last modified, size, item name
			- Publish
			- Run: Debug
				- Go to output -> Show input and output (arrows)

### Stored Procedure Activity
	- Clone GetMetadata Pipeline: Demo3 - StoredActivity
	- Load Demo3 files into SQLDB -> review tables and stored procedures
	- Add Stored procedure Activity to pipeline 
	- Connect Metadata activity to Stored Procedure Activity
		- review output connection options: success, failure, etc
	- Settings:
		- Choose DB and Stored procedure
		- Review Stored procedure parameters -> import
		- Click in parameter value -> add dynamic content -> review options
			- FileName: Choose Activity output -> [prev activity name]ItemName
				- Explain code
			- ModifiedDate: Activity output -> [prev activity name]LastModified
			- RecordInserDate: convertfromutc(utcnow,<time>)
				- https://learn.microsoft.com/en-us/windows-hardware/manufacture/desktop/default-time-zones?view=windows-11
			- Debug
			- Review output
				- Store procedure dont have an really output to be used
				- Lookup Activity will be needed
			- Review ADB table
			- It is N hours ahead -> Functions -> Add hours

### LookUp Activity
	- Objective: Lookup last exectution date
	- Clone Stored procedure pipeline: Demo4 - LookupActivity
	- Get rid of stored procedure activity
	- Load Demo4 files to SQLDB -> review files
	- Add Lookup Activity to pipeline -> connect GetMetadata to Lookup
		- Can be run paralelly
	- Settings:
		- Chooose table -> stored procedure -> LastLoadDate
		- Import procedure parameters
		- Click in parameter value -> add dynamic content -> review options
			- FileName: Choose Activity output -> [prev activity name]ItemName
	- Publish and debug
		- Review input and outputs
		- Point the difference hours btwn getMetadata and lookup last modified data due to UTF and local time.			

### If Condition Activity
	- Objective: Update control table if last modified date is grater than execution, if not wait
	- Clone Lookup pipeline
	- Add If Condition Activity to pipeline -> Connect to Lookup output
	- Activities:
		- Click in Expression -> add dynamic content -> review functions -> look for greaterorequal -> add -> review reference (https://learn.microsoft.com/es-es/azure/data-factory/control-flow-expression-language-functions)
			- first argument: lastModifiedDate -> needs to be formated to date
				- enclose lastModifiedDate by formatDateTime, using 'o'
				- enclose formatDate by addhours -> second argument <number hours diference identified>
			- second argument: lookup activity.output.firstRow.ExecutionDate (look for lookup activity action)
	- True/Fase configuration:
		- to test add to both Add Wait Activity
	- Publish and debug
		- Review outputs -> Only True
	- Modify True condition:
		- Get rid of wait
		- Add Stored procedure for update execution date
			- Settings:
				- Choose procedure: UpdateLastExecutionDate -> import
				- Click in parameter value -> add dynamic content
					- Under SystemVariables -> add PipelineTriggerTime
					- Enclose PipelineTriggerTime with ConvertFromUTC
	- Publish and debug
		- Go to ADB -> review Control table for last execution date -> must be updated
	- Run again
		- Enters in False


## Data Flows
	- Objective: review business case
	- Create new Data Flow
	- Activate Data Flow Debug -> Creates Spark cluster -> everything is translated to scala.
	- Add source 1: review options -> grey are not sopported directly
		- Upload Demo6 "txt" files to datalake Source folder
		- Create new Dataset 1
			- ADLS -> delimited text -> az_aDLS_ProductsAll
			- Select ProductsAll -> preview -> use comma delimiter
			- Import schema
		- Create new Dataset 2
			- ADLS -> delimited text -> az_aDLS_ProductModels
			- Select ProductModels -> preview -> user pipe delimiter
			- Import schema
		- Select az_aDLS_ProductsAll dataset -> Data preview
	- Add source 2:
		- Select az_aDLS_ProductModels dataset -> Data preview
	- Add the LookUp:
		- Settigs:
			- Primary stream: ProductsAll
			- Lookup stream: ProductModels
			- Lookup conditions: ProductModelId == ProductModelId
				- Change data type to int in sources -> projection -> detect data type -> adjust manually
		- Preview -> look for productmodelId and other duplications
	- Add Select:
		- Remove duplications
		- Settings:
			- Review
			- Get rid of ProductModelId
			- Rename ProductModel@Name to ModelName
			- Move ModelName near to Product Name
		- Preview 
	- Add Filter:
		- Settings:
			- Filter on -> Open expression builder -> review expresions
			- notEqual() -> Input schema -> ListPrice -> second argument "0"
		- Preview -> verify all prices have value
	- Add Sink:
		- ProductsFinal
		- Create new dataset: 
			- Delimeted text: az_ADLS_ProductsFinal
			- First row headers
			- Browse for Destination -> ProductsFinal.csv
		- Sink
			- Choose dataset
		- Settings:
			- Review options
		- Data preview
	- Pubish
	- Create a pipeline:
		- Add Dataflow
			- Settings: Review options -> Add the previous dataflow
	- Publish -> Debug

## Triggers
	- In the pipeline click on trigger
	- Review options and types
	- Review Pipeline runs hub

## Key Vault
	- Create linked service for the key vault in Azure Data Factory (ADF).
		- key vault name -> create new key vault: adfwkeyvault1

	- Test connection
	- Access Key Vault -> 
		- create a secret: 
			- sqldb: go to sqldatabase -> show connection strings -> copy
			- create secret with this string
				- remember change password for real
		- access policies -> give permision to ADF
	- Use secret in sql dataset -> test connection
