document.addEventListener("DOMContentLoaded", function(event) {
    const iFrameDetection = (window === window.parent) ? false : true;
    if (!iFrameDetection) {
        safari.extension.dispatchMessage("getAccounts");
    }
});

window.addEventListener("resize", function(event) {
    const iframe = document.getElementById("shiny-auth");
    if (iframe) {
        resizeIFrame(iframe);
        iframe.style.display = "none";
    }
});

window.visualViewport.addEventListener("resize", function(event) {
    const iframe = document.getElementById("shiny-auth");
    if (iframe) {
        iframe.style.display = "none";
    }
});

safari.self.addEventListener("message", function (event) {
    if (event.name == "showPopup") {
        setupIFrame(event.message.accounts);
    } else if (event.name == "fillToken") {
        fillToken(token);
    }
});

function fillToken(token) {
    const otp = findOTPField();
    
    if (otp) {
        otp.value = token;
        otp.style.backgroundColor = "#FAFFBD";
    }
};

function setupIFrame(accounts) {
    const otp = findOTPField();
    
    if (otp) {
        var iframe = document.getElementById("shiny-auth");
        const rect = otp.getBoundingClientRect();
        
        if (!iframe) {
            iframe = document.createElement("iframe");
            // insert iframe after otp
            if (otp.nextSibling) {
                otp.parentNode.insertBefore(iframe, otp.nextSibling);
            }
            else {
                otp.parentNode.appendChild(iframe);
            }
        }
        
        otp.onfocus = function() {
            iframe.style.display = "block";
        };
        
        otp.focusout = function() {
            iframe.style.display = "none";
        };
        
        const accountHTML = accounts.map(account => createAccountView(account.label, account.token));
        const html = accountHTML.join("");
        
        const itemHeight = 47;
        const padding = 5;
        const popupHeight = accounts.length * itemHeight + 2 * padding;
        
        iframe.id = "shiny-auth";
//        iframe.sandbox = "allow-scripts";
        iframe.setAttribute("srcdoc", html);
        iframe.scrolling = "no";
        iframe.style.height = popupHeight+"px";
        resizeIFrame(iframe);
        
        iframe.addEventListener("load", function() {
            console.log("load")
            for (let i = 0; i < accounts.length; i++) {
                let element = iframe.contentWindow.document.getElementsByClassName("box")[i];
                let account = accounts[i];
                
                element.onclick = function() {
                    console.log("click")
                    fillToken(account.token);
                    iframe.style.display = "none";
                };
            }
        });

    }
}

function resizeIFrame(iframe) {
    const otp = findOTPField();
    if (otp && iframe) {
        const rect = otp.getBoundingClientRect();
        iframe.style.top = rect.bottom+2+"px";
        iframe.style.left = rect.left-6+"px";
    }
}

function createAccountView(label, token) {
    
    const icon = `
    <svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:serif="http://www.serif.com/" width="100%" height="100%" viewBox="0 0 14 14" version="1.1" xml:space="preserve" style="fill-rule:evenodd;clip-rule:evenodd;stroke-linejoin:round;stroke-miterlimit:2;">
    <g transform="matrix(1,0,0,1,-2870,-120)">
    <g id="AppIcon-Safari" serif:id="AppIcon Safari" transform="matrix(0.0194444,0,0,0.0194444,2814.19,117.667)">
    <rect x="2870" y="120" width="720" height="720" style="fill:none;"/>
    <g transform="matrix(1.05751,0,0,0.993363,2701.24,12.1259)">
    <g transform="matrix(1.0014,0,0,0.796875,-3.70248,110.594)">
    <path d="M716,478.673C716,442.979 694.339,414 667.658,414L338.342,414C311.661,414 290,442.979 290,478.673L290,765.327C290,801.021 311.661,830 338.342,830L667.658,830C694.339,830 716,801.021 716,765.327L716,478.673Z"/>
    </g>
    <g>
    <g transform="matrix(0.691623,0,0,0.753846,143.94,65.9692)">
    <path d="M742,365.5C742,239.855 640.145,138 514.5,138C388.855,138 287,239.855 287,365.5L377.152,365.5C377.152,289.645 438.645,228.152 514.5,228.152C590.355,228.152 651.848,289.645 651.848,365.5L742,365.5Z"/>
    </g>
    <g transform="matrix(2.00095,0,0,1,-342.762,-1.87228e-05)">
    <rect x="342.436" y="341.5" width="31.161" height="129"/>
    </g>
    <g transform="matrix(2.00095,0,0,1,-657.749,-5.09119e-05)">
    <rect x="625.964" y="341.5" width="31.161" height="129"/>
    </g>
    </g>
    </g>
    </g>
    </g>
    </svg>
    `;
    
    const html = `
    <div class="box">
        <div class="hstack">
            <div class="icon">
                ${icon}
            </div>
            <div class="vstack">
                <div class="title">
                    ${label}
                </div>
                <div class="subtitle">
                    Fill code ${token}
                </div>
            </div>
        </div>
    </div>
    `;
    
    return html;
}


function findOTPField() {
    const keywords = ["twofactor", "two-factor", "2fa", "otp", "authfactor", "6-digit code", "one-time-code"];
    const inputs = document.getElementsByTagName("input");
    
    for (let input of inputs) {
        const testID = keywords.some(el => input.id.includes(el));
        const testName = keywords.some(el => input.name.includes(el));
        const testPlaceholder = keywords.some(el => input.placeholder.includes(el));
        
        if (testID || testName || testPlaceholder) {
            return input;
        }
    }
}
