# Azure Data Factory - Azure DevOps

## Create azure devops account
- Regiter in: dev.azure.com
	- Make sure accounts AD is the same: 
		- https://aex.dev.azure.com/
		- select "Default Directory" in profile

## Simple azure devops python project
- https://learn.microsoft.com/en-us/azure/devops/pipelines/ecosystems/python?view=azure-devops
	- remember to add MS hosted parallel jobs
	- may need your account
- https://olohmann.github.io/azure-hands-on-labs/labs/06_cicd_azure_devops/cicd_azure_devops.html

## Data Factory Linking
- go to Data Factory. In the upper left corner, named "Data Factory", and shows some drop-down options, click on Set Up Code Repository.
- set up the connection to the code repository was created in the 3rd step. Then,
	- Select Repository Type: Azure DevOps Git
	- Select Azure DevOps account, which is associated with a user account.
	- click Save
- configure a repository:
	- Choose Project Name (the one we just created)
	- Git Repository Name: We can create a new one or use the existing repository when we create it.
	- Collaboration Branch: I suggest you stick with Master. 
		-This is where all your branching will merge, and a copy of all the changes you’ve made will be published to the Azure Data Factory that runs via trigger or event.
	- Then click Save.
- Once a user can see their ADF page where Save as Template is grayed out, but underneath that, you’ll see two new Save buttons pop up. 
	- These buttons will allow if the saved changes the user made are different than they do and need to be done, which is to publish changes to the Data Factory.
- Now, all configurations and code repository are Saved, Save All, and Publish Buttons. 	- Additionally, the user will be asked what branch they want. A user can create a new one or the existing (Master) branch.

## Branching
- Try to use the name in such a way that differentiates when working in a team.
- In pipeline, users will add a wait command to see how the change gets captured. In Get Rows, you need to choose to make this wait happen when the failure occurs, then connect the failure to the wait and save it.
- After creating branch and command, a user will hit publish and receive an error message that says ‘publish is only allowed from collaboration (Master) branch. 
	- Merge the changes to Master.’
- To merge changes to the main branch, go up in the header section, and change the feature branch to the master branch. 
	- But when the user changes it, the wait command disappears, and where wait needs to occur.
- To execute and fix the wait command, the user moves back to the branch at the top and selects Create Pull Request from the drop-down options. 
	- This will pull that branch back into the collaboration (Master) branch.
- After pulling back the master branch, set up the pull request from the feature into the master branch and click Create, and it will pop up to either approve or complete the pull request and merge.
- Lastly, back in Data Factory, save all, and see that wait command come back into the master branch.

## Test environment
-Create 2 data factores: 
	- "devdatafactory"	for development
	- "depldatafactory" for deployment	
	- Enter in "dev" ADF.
- go to master branch -> add pipeline and changes -> publish
- Review changes in Az Devops
- Create build pipeline:
	- Go to "Pipelines" -> new pipeline -> use classic editor
	- Change default branch
	- Select template -> Empty job -> name: "ADF build pipeline"
	- Go to triggers -> Enable continuous integration
	- Go to tasks -> In agent job "+" -> Select "Publish build artifact" -> wait
	- Select added "Publish Artifact frop" -> change name "ARMTemplates" -> path to publish: choose the root folder of repository
	- Save and queue -> add comment -> save and run -> wait and review output
	- Review "Artifacts"
- Create release pipeline:
	- Go to "Releases" -> new pipeline -> wait
	- Select template -> empty job
	- In Stage -> name: "test enviroment"
	- click "Add an artifact" box -> Source type: build -> choose the previous build pipeline created -> add
	- Click on the "lightning button" -> Enale continous deployment
	- Click on the "test environmet" box -> click on "job" link in the box -> Agent job: click on add "+" -> search for "resource group" -> select "azure resource group deployment"
	- Click on "azure resource group deployment":
		- choose suscription -> Authorize
		- choose resource group
		- choose location
		- choose template -> "..." -> browse for "ARMTemplateForFactory.json"
		- choose template parameters -> "..." -> browse for "ARMTemplateParametersForFactory.json"
		- choose Override template parameters -> "..." -> change factory name
		- Deployment mode: incremental
		- Save (top) -> Ok
	- hit "Create release":
		- select "test enviroment" -> create
	- Review release (log at the top)
		- Click on "test enviroment" box -> deploy -> Deploy -> wait -> success
- Go to data factories
	- Open new data factory
