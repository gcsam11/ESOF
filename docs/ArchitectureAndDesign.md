## Architecture and Design

### Logical architecture
To allow easy understanding of the code for any future modifications, we divided our project into:
* TreeDesigner UI: user interface of the app, which includes screens for creating and editing genealogy trees, adding photos and details, viewing public trees and managing user accounts;
* TreeDesigner Business Logic: programming logic that handles the functionality of the app, including user authentication, tree creation and management and data storage;
* TreeDesigner Database Schema: structure of the database used to store data for the app;
* Google Account: external service used to handle user authentication and user account creation. This will simplify the process of managing user accounts and passwords, as users can use their existing Google account to log in to the app.

![LogicalView](https://github.com/FEUP-LEIC-ES-2022-23/2LEIC02T2/blob/1980f576b30f3eb841795cdc57f9d45fb2ec0b68/Images/LogicalArchitecture.png)

### Physical architecture
The Physical Architecture of our app is composed by the User Device, App Server and Google Server.
We decided to use Flutter(with Dart programming language) for the app with Firebase for the database because they are simple technologies and suitable for our type of project.

![DeploymentView](https://github.com/FEUP-LEIC-ES-2022-23/2LEIC02T2/blob/1980f576b30f3eb841795cdc57f9d45fb2ec0b68/Images/PhysicalArchitecture.png)
