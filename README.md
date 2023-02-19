## 👋 Inspiration

According to the Department of Housing and Urban Development (in December 2022) there are over half a million people homeless in the United States. You may ask, “how accessible can technology be for homeless people?” If so, you might be surprised by these numbers: in a study conducted in the LA-Long Beach area of 421 homeless adults, 94% owned a cell phone and 56% owned a smartphone. However, the issue is that many of these users reported that limited internet access and minimal battery is a hindrance to their ability to fully utilize their devices. 

There are many organizations focused on supporting the homeless community, but promoting access to smartphone technology, something that many of us take for granted to access information, is a rarely handled pain point. 

This project offers a helping hand. Our app implements roundabout features oriented toward serving this cause with such particular necessities. Through technology, our mobile app _Hands For Help_ humanizes homelessness through the shared experience of modern technology usage.

## 🫴 What it does

This app offers our unhoused neighbors access to local city maps and bookmarks for work opportunities, charity events, food services, shelters, and any other postings by service organizations within the user’s proximity. These features are implemented in a way to mitigate both the intensive use of the internet/GPS and battery. 

To work around the internet and GPS, users only need to connect to a Wi-Fi service with their GPS on once because the app will store all the map and event data locally. Alternatively, users can share the data with each other through a scannable QR code, or as we call it, the “digital handshake.” While this latter option will still require one person to originally connect to the internet, the app then allows users to distribute the updated version offline and beyond the place of connection, expending less overall effort in the community. In particular, a passerby who has the app would also be able to support the homeless community by sharing a QR code themselves, humanizing the process.

Because the methods above reduce internet and GPS usage, the app inherently saves more battery than other map and events services. On top of this, because the app will never need to update its data outside of a user-specified event, it has no power-hungry features.

There is also a feature for social workers and organizations to post their own events through the app. These custom events can be transferred to user devices in a similar way.

## 👊 How we built it

We utilized a Flask backend and a Flutter frontend so that our app is accessible to both iOS and Android. Flask queried the Google Maps API to find nearby homeless service places, place details, and geocode for locations in order to send the relevant data to the frontend. The Google Maps Flutter Package is then used to display and mark the Flask-parsed events on a map. Flutter also stores the event information in a local database to populate the bookmarks page. In this format, the events won’t be lost when the app is reloaded. Furthermore, the QR code sharing feature utilizes Flutter’s access to the phone’s native camera in order to scan QR code position markers. In reality, the QR codes represent event metadata as a JSON string that will also then be stored in the local database by the app. 

## 🤏 Challenges we ran into

When we first settled on this idea, we had trouble outlining the feasible scope. For example, we had no concrete idea what data and how much of it could be stored in a QR code, what implementations were practical with little to no internet connection, and what methods would balance battery life with functionality. Furthermore, we identified services such as Apple AirDrop and Bluetooth to accomplish a similar peer-to-peer transfer of data, but found QR codes offered a more efficient and non-platform specific solution. 

## 🙌 Accomplishments that we're proud of

We are proud that, even though we were uncertain if some of our ideas were possible, we were able to manage our scope and create a functional project in the end. We are especially proud of our “digital handshake” QR code support because it was a creative solution that allowed us to work around the identified limitations.

Furthermore, this project gave us a chance to contribute to a social cause that we witness first-hand almost every day in the Bay Area. This opportunity has inspired us and allowed us to realize the power we have to make an impact. As a team, we were able to combine our skills and our shared concern for our community to make positive change.

## ✍️ What we learned

As we increased the pace of our workflow, we had more problems merging our files together since they became harder to track. After adjusting our roadmap together, we learned how to better communicate and specify our designs to our teammates to improve our version control. Moreover, we all gained a greater understanding of QR codes including their generation and data storage.

## 👉 What's next for Hands For Help

To make the app more user-friendly and accessible, intuitive navigation and visuals were carefully considered. However, it is possible to reduce the visual aesthetics of our navigations rendered and the refresh rate of the app, which could save even more battery life, but at a cost of the user flow. Furthermore, the use of QR codes to transfer data between devices locally can be scaled beyond resource finding, for example, sharing news.

Mobile technology will continue to change the world and such advancements would strengthen the durability of our product. Additionally, while the breadth of our mobile app is currently limited by the number of smartphone-owning people experiencing homelessness (which is a little over half according to the LA-Long Beach study), it is likely that the reach of our product will increase as cheaper smartphones become available.