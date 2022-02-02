
# doctor_mfc_admin

A CMS web application developed in Flutter, 
for administration of devices, issues, solutions, documentation, 
guides and users of doctor_mfc mobile app, a troubleshooting 
service developed for a US corporation, which name will not be
mentioned for privacy.

This is the Admin application for my senior project at Metropolitana University, Caracas, VE (2022).

The database is Firebase Firestore and the search engine used was Algolia.




## Features

- **System issues management**: Create systems, link known issues and solutions, link attachments to solutions which can be links, documentation and guides.
- **Deep step-based solution creation**: Create solutions with steps. This feature has been very deeply developed in order to optimize user experience.
- **Link existing documentation to solutions**: Link documentation that has already been added to database to your solutions, so you don't have to repeat the work twice, and also keep the database uncluttered with repeated documentation.
- **Systems' documentation management**: Add all the documentation of a device so users can access it when needed.
- **How-to guide management**: Add how-to guides in the system for your users to follow when needed.
- **User management**: Create, enable and disable users of doctor_mfc app.



## Tech Stack

**Client:** Flutter

**Server:** Firebase Firestore, Algolia


## Deployment

To deploy this project, you will need Flutter SDK and 
Android Studio installed in your computer. Then run the following command:

```bash
  // First run this command to get all the dependencies used for this project
  dart pub get

  // Then run the following command to deploy in web.
  // For Chrome users:
  flutter run -d Chrome 

  // For Safari users:
  flutter run -d Safari

  // For other explorers, you should look up what tag to use in 
  // order to run the project in that explorer:
  flutter run -d $EXPLORER_NAME
```


## Support

For support, ideas or if you want to contribute, email me at andres.epacheco99@gmail.com. I'll be glad to talk to you.


## Author

- [@andrespd99](https://www.github.com/andrespd99) 