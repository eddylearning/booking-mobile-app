const functions = require('firebase-functions');
const admin = require('firebase-admin');
const axios = require('axios');

admin.initializeApp();

// 1. LOAD CONFIGURATION SECURELY
const config = functions.config().mpesa;
const MPESA_CONSUMER_KEY = config.consumer_key;
const MPESA_CONSUMER_SECRET = config.consumer_secret;
const MPESA_PASSKEY = config.passkey;
const SHORTCODE = config.shortcode || "174379"; // Default Test Shortcode

const DARAJA_AUTH_URL = "https://sandbox.safaricom.co.ke/oauth/v1/generate?grant_type=client_credentials";
const DARAJA_STK_PUSH_URL = "https://sandbox.safaricom.co.ke/mpesa/stkpush/v1/processrequest";

// 2. HELPER: GENERATE ACCESS TOKEN
const getAccessToken = async () => {
    const auth = Buffer.from(`${MPESA_CONSUMER_KEY}:${MPESA_CONSUMER_SECRET}`).toString('base64');
    try {
        const response = await axios.get(DARAJA_AUTH_URL, {
            headers: { Authorization: `Basic ${auth}` }
        });
        return response.data.access_token;
    } catch (error) {
        console.error("Error getting M-Pesa Token:", error);
        throw new functions.https.HttpsError('internal', 'Failed to connect to M-Pesa');
    }
};

// 3. CLOUD FUNCTION: INITIATE PAYMENT (Called from Flutter)
exports.initiateSTKPush = functions.https.onCall(async (data, context) => {
    // 1. Validate Data
    if (!context.auth) {
        throw new functions.https.HttpsError('unauthenticated', 'User must be logged in.');
    }

    const { phoneNumber, amount, orderId } = data;
    
    if (!phoneNumber || !amount || !orderId) {
        throw new functions.https.HttpsError('invalid-argument', 'Missing phone, amount, or order ID');
    }

    try {
        // 2. Get Token
        const token = await getAccessToken();

        // 3. Generate Timestamp and Password
        const date = new Date();
        const timestamp = date.getFullYear() +
            ("0" + (date.getMonth() + 1)).slice(-2) +
            ("0" + date.getDate()).slice(-2) +
            ("0" + date.getHours()).slice(-2) +
            ("0" + date.getMinutes()).slice(-2) +
            ("0" + date.getSeconds()).slice(-2);
        
        const password = Buffer.from(`${SHORTCODE}${MPESA_PASSKEY}${timestamp}`).toString('base64');

        // 4. Prepare STK Push Payload
        const payload = {
            "BusinessShortCode": SHORTCODE,
            "Password": password,
            "Timestamp": timestamp,
            "TransactionType": "CustomerPayBillOnline",
            "Amount": amount,
            "PartyA": phoneNumber, // Phone sending money
            "PartyB": SHORTCODE,   // Shortcode receiving money
            "PhoneNumber": phoneNumber,
            "CallBackURL": "https://shopke-4b83a.cloudfunctions.net/mpesaCallback", // SEE NOTE BELOW
            "AccountReference": orderId, // We use OrderID to match payment later
            "TransactionDesc": "Payment of Fresh Farm Order"
        };

        // 5. Send Request to Safaricom
        const response = await axios.post(DARAJA_STK_PUSH_URL, payload, {
            headers: { Authorization: `Bearer ${token}` }
        });

        console.log("M-Pesa Response:", response.data);
        
        // Return success to Flutter app
        return { 
            success: true, 
            message: "STK Push sent to phone. Please enter PIN.",
            responseCode: response.data.ResponseCode,
            merchantRequestID: response.data.MerchantRequestID
        };

    } catch (error) {
        console.error("STK Push Error:", error.response ? error.response.data : error.message);
        throw new functions.https.HttpsError('internal', 'M-Pesa Request Failed');
    }
});

// 4. CLOUD FUNCTION: HANDLE CALLBACK (Called by Safaricom)
exports.mpesaCallback = functions.https.onRequest(async (req, res) => {
    console.log("M-Pesa Callback received:", req.body);

    try {
        const body = req.body.Body.stkCallback;
        const resultCode = body.ResultCode;
        const orderId = body.AccountReference; // We passed this in the STK Push
        const resultDesc = body.ResultDesc;

        if (resultCode === 0) {
            // SUCCESS: Payment Received
            console.log(`Payment successful for Order: ${orderId}`);

            // Update Firestore
            await admin.firestore().collection('orders').doc(orderId).update({
                'status': 'Paid',
                'isPaid': true,
                'paymentResult': resultDesc,
                'updatedAt': admin.firestore.FieldValue.serverTimestamp()
            });
        } else {
            // FAILED: User cancelled or insufficient funds
            console.log(`Payment failed for Order: ${orderId} - ${resultDesc}`);

            await admin.firestore().collection('orders').doc(orderId).update({
                'status': 'Payment Failed',
                'paymentResult': resultDesc,
                'updatedAt': admin.firestore.FieldValue.serverTimestamp()
            });
        }

        // IMPORTANT: Always respond with 200 to Safaricom so they don't retry
        res.status(200).json({ ResultCode: 0, ResultDesc: "Success" });

    } catch (error) {
        console.error("Callback Processing Error:", error);
        res.status(500).send("Internal Server Error");
    }
});