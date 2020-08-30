safari.self.addEventListener("message", function (event) {
    console.log("Received a message named: " + event.name);
    if (event.name == "credentials") {
        document.getElementById("otp").value = event.message.token;
        document.getElementById("otp").style.backgroundColor = "#FAFFBD";
    } else {
        console.log("Received a message named: " + event.name);
    }
});
