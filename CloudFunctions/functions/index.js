const functions = require('firebase-functions');
const admin = require('firebase-admin');

// init admin

admin.initializeApp(functions.config().firebase);


// TODO news added


// game details changed

exports.gameDetailsChanged = functions.database.ref('gamedays/{gamedayDate}/{gameId}').onUpdate(event => {

    console.log("game details changed");

    // TODO only updates

    const prevDetails = event.data.previous.val();
    const newDetails = event.data.val();

    // check if score changed

    if (prevDetails["score"][0] != newDetails["score"][0] || prevDetails["score"][1] != newDetails["score"][1]) {
        console.log(gameLiveMessage(newDetails));

        // send notification
        var topicName = newDetails["league"] + "_runs";
        sendNotificationToTopic("LIVE Score Update", gameLiveMessage(newDetails), topicName);
    }


    // check if game is final

    if (newDetails["state"] == "final") {
        console.log("game ended!!!!!!!!");

        // send notification
        var topicName = newDetails["league"] + "_final";
        sendNotificationToTopic("End of Game", gameLiveMessage(newDetails), topicName);

    }

    // TODO ppd rain

    return;
})


// send notification to topic

function sendNotificationToTopic(title, message, topic) {
    var payload =  {
            notification: {
                title: title,
                body: message
                 // TODO click scoring page
            }
        };

    admin.messaging().sendToTopic(topic, payload);
    // TODO catch error?
    return;
}


// Returns the update live game message

function gameLiveMessage(gameDetails) {
    var messageText = convertLeagueName(gameDetails["league"]) + " - " + gameDetails["teams"][0] + " " + gameDetails["score"][0] + " : " + gameDetails["teams"][1] + 
         " " + gameDetails["score"][1] + "\n";

    if (gameDetails["inning_is_top"] == true) {
        messageText += "T";
    } else {
        messageText += "B";
    }

    messageText += gameDetails["inning"] + ", " + gameDetails["outs"] + " Outs";

    return messageText;
}


// Returns the final game message

function gameFinalMessage(gameDetails) {
    var messageText =  convertLeagueName(gameDetails["league"]) + " - " + gameDetails["teams"][0] + " " + gameDetails["score"][0] + " : " + gameDetails["teams"][1] + 
         " " + gameDetails["score"][1];

    if (gameDetails["inning"] != 9) {
        messageText += "\nF/" + gameDetails["inning"];
    }

    return messageText;
}


// convert league name

function convertLeagueName(name) {
    var convertedName;

    switch(name) {
        case "FPSB": 
            convertedName = "Softball";
            break;
        // TODO 1. Liga
        default:
            convertedName = name;
    }

    return convertedName;
}

