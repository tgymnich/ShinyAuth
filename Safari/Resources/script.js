document.addEventListener("DOMContentLoaded", function(event) {
    const isIframe = (window === window.parent) ? false : true;
    if (!isIframe && otp()) {
        addAppExtensionEventListeners();
        addWindowEventListeners();
        addIframeEventListeners();
        safari.extension.dispatchMessage("extensionReady");
    } else {
        addIframeEventListeners();
        parent.postMessage({message: "iframeReady"}, "*");
    }
});

var accounts;

var _otp;
function otp() {
    if (_otp == null) {
        const keywords = ["twofactor", "two-factor", "2fa", "otp", "authfactor", "6-digit code", "one-time-code"];
        const inputs = document.getElementsByTagName("input");

        for (let input of inputs) {
            const testID = keywords.some(el => input.id.includes(el));
            const testName = keywords.some(el => input.name.includes(el));
            const testPlaceholder = keywords.some(el => input.placeholder.includes(el));

            if (testID || testName || testPlaceholder) {
                _otp = input;
                return input;
            }
        }
        return undefined;
    } else {
        return _otp;
    }
}

var _iframe;
function iframe() {
    if (_iframe == null) {
        _iframe = document.createElement("iframe");
        _iframe.sandbox = "allow-scripts";
        _iframe.scrolling = "no";

        if (otp().nextSibling) {
            otp().parentNode.insertBefore(_iframe, otp().nextSibling);
        } else {
            otp().parentNode.appendChild(_iframe);
        }
        return _iframe;
    } else {
        return _iframe
    }
}

function resizeIframe(accounts) {
    if (otp() && iframe()) {
        const rect = otp().getBoundingClientRect();
        const itemHeight = 43;
        const padding = 5;
        const popupHeight = accounts.length * itemHeight + 2 * padding;
        iframe().style.top = rect.bottom+2+"px";
        iframe().style.left = rect.left-6+"px";
        iframe().style.height = popupHeight+"px";
    }
}

var originalOTPBackgroundColor = "white";
function fillToken(token) {
    if (otp()) {
        otp().value = token;
        originalOTPBackgroundColor = otp().style.backgroundColor;
        otp().style.backgroundColor = "#FAFFBD";
    }
    iframe().style.display = "none";
}

function createAccountList(accounts) {
    for (let account of accounts) {
        createAccount(account.label, account.token)
    }
}

function createAccount(label, token) {
    const box = document.createElement("div");
    box.className = "box";
    document.body.appendChild(box);

    const hstack = document.createElement("div");
    hstack.className = "hstack";
    box.appendChild(hstack);

    const icon = document.createElement("div");
    icon.className = "icon";
    hstack.appendChild(icon);
    
    const svg = document.createElement("img");
    svg.src = safari.extension.baseURI + "icon.svg";
    icon.appendChild(svg);

    const vstack = document.createElement("div");
    vstack.className = "vstack";
    hstack.appendChild(vstack);

    const title = document.createElement("div");
    title.className = "title";
    title.innerHTML = label;
    vstack.appendChild(title);

    const subtitle = document.createElement("div");
    subtitle.className = "subtitle";
    subtitle.innerHTML = `Fill code ${token}`;
    vstack.appendChild(subtitle);

    box.onmousedown = function() {
        parent.postMessage({"message": "fillToken", "token": token}, "*");
    };
}

function addOTPEventListeners() {
    otp().addEventListener("focus", function (event) {
        iframe().style.display = "block";
    });

    otp().addEventListener("blur", function (event) {
        iframe().style.display = "none";
    });
    
    otp().addEventListener("input", function (event) {
        otp().style.backgroundColor = originalOTPBackgroundColor;
    });
}

function addWindowEventListeners() {
    window.addEventListener("resize", function(event) {
        if (iframe()) {
            resizeIframe(accounts);
            iframe().style.display = "none";
        }
    });

    window.visualViewport.addEventListener("resize", function(event) {
        if (iframe()) {
            iframe().style.display = "none";
        };
    });
}

function addIframeEventListeners() {
    // IFrame Extension Messages
    window.addEventListener('message', function (event) {
        if (event.data.message == "iframeReady") {
            resizeIframe(accounts);
            iframe().contentWindow.postMessage({"message": "creatAccountList", "accounts": accounts}, "*");
        } else if (event.data.message == "creatAccountList") {
            createAccountList(event.data.accounts);
        } else if (event.data.message == "fillToken") {
            fillToken(event.data.token);
        }
    });
}

function addAppExtensionEventListeners() {
    // App Extension Messages
    safari.self.addEventListener("message", function (event) {
        if (event.name == "showPopup") {
            addOTPEventListeners();
            iframe();
            accounts = event.message.accounts;
        } else if (event.name == "fillToken") {
            fillToken(event.message.token);
        }
    });
}

