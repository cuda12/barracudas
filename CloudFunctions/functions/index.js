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

        // TODO change this to topics
        var registrationToken = "eRtAjkTPbbE:APA91bE7lBpaxgXNzDSkOxr07-KymyW4-hlPfMiQc4G6E-p4zqdasqYm9AiTtuOVB-Nb_67S0rekb1hPYfrYg2-7cV-8u8FEcj4UBHKM_M9_BlJDizVyDVAoszTjgIwFVCPZL1Ff1PR7";

        var payload =  {
            notification: {
                title: "New Score",
                body: gameLiveMessage(newDetails)
                 // TODO click scoring page
            }
        };

        admin.messaging().sendToDevice(registrationToken, payload);
    }


    // check if game is final

    if (newDetails["state"] == "final") {
        console.log("game ended!!!!!!!!");

        // TODO change this to topics
        var registrationToken = "eRtAjkTPbbE:APA91bE7lBpaxgXNzDSkOxr07-KymyW4-hlPfMiQc4G6E-p4zqdasqYm9AiTtuOVB-Nb_67S0rekb1hPYfrYg2-7cV-8u8FEcj4UBHKM_M9_BlJDizVyDVAoszTjgIwFVCPZL1Ff1PR7";

        var payload =  {
            notification: {
                title: "End of Game",
                body: gameFinalMessage(newDetails)
                // TODO click scoring page
            }
        };

        admin.messaging().sendToDevice(registrationToken, payload);

    }

    // TODO ppd rain

    return;
})


// Returns the update live game message

function gameLiveMessage(gameDetails) {
    var messageText = "LIVE " + gameDetails["league"] + "\n" + gameDetails["teams"][0] + " " + gameDetails["score"][0] + " : " + gameDetails["score"][1] + 
         " " + gameDetails["teams"][1];

    if (gameDetails["inning_is_top"] == true) {
        messageText += ", T";
    } else {
        messageText += ", B";
    }

    messageText += gameDetails["inning"] + ", " + gameDetails["outs"] + " Outs";

    return messageText;
}


// Returns the final game message

function gameFinalMessage(gameDetails) {
    var messageText = "FINAL: " + gameDetails["league"] + ": " + gameDetails["teams"][0] + " " + gameDetails["score"][0] + " vs. " + gameDetails["teams"][1] + 
         " " + gameDetails["score"][1];

    if (gameDetails["inning"] != 9) {
        messageText += ", F/" + gameDetails["inning"];
    }

    return messageText;
}