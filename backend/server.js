// const functions = require('firebase-functions');
// const admin = require('firebase-admin');
// const axios = require('axios');

// admin.initializeApp();

// // 1. LOAD CONFIGURATION SECURELY
// const config = functions.config().mpesa;
// const MPESA_CONSUMER_KEY = config.consumer_key;
// const MPESA_CONSUMER_SECRET = config.consumer_secret;
// const MPESA_PASSKEY = config.passkey;
// const SHORTCODE = config.shortcode || "174379"; // Default Test Shortcode

// const DARAJA_AUTH_URL = "https://sandbox.safaricom.co.ke/oauth/v1/generate?grant_type=client_credentials";
// const DARAJA_STK_PUSH_URL = "https://sandbox.safaricom.co.ke/mpesa/stkpush/v1/processrequest";

// // 2. HELPER: GENERATE ACCESS TOKEN
// const getAccessToken = async () => {
//     const auth = Buffer.from(`${MPESA_CONSUMER_KEY}:${MPESA_CONSUMER_SECRET}`).toString('base64');
//     try {
//         const response = await axios.get(DARAJA_AUTH_URL, {
//             headers: { Authorization: `Basic ${auth}` }
//         });
//         return response.data.access_token;
//     } catch (error) {
//         console.error("Error getting M-Pesa Token:", error);
//         throw new functions.https.HttpsError('internal', 'Failed to connect to M-Pesa');
//     }
// };

// // 3. CLOUD FUNCTION: INITIATE PAYMENT (Called from Flutter)
// exports.initiateSTKPush = functions.https.onCall(async (data, context) => {
//     // 1. Validate Data
//     if (!context.auth) {
//         throw new functions.https.HttpsError('unauthenticated', 'User must be logged in.');
//     }

//     const { phoneNumber, amount, orderId } = data;
    
//     if (!phoneNumber || !amount || !orderId) {
//         throw new functions.https.HttpsError('invalid-argument', 'Missing phone, amount, or order ID');
//     }

//     try {
//         // 2. Get Token
//         const token = await getAccessToken();

//         // 3. Generate Timestamp and Password
//         const date = new Date();
//         const timestamp = date.getFullYear() +
//             ("0" + (date.getMonth() + 1)).slice(-2) +
//             ("0" + date.getDate()).slice(-2) +
//             ("0" + date.getHours()).slice(-2) +
//             ("0" + date.getMinutes()).slice(-2) +
//             ("0" + date.getSeconds()).slice(-2);
        
//         const password = Buffer.from(`${SHORTCODE}${MPESA_PASSKEY}${timestamp}`).toString('base64');

//         // 4. Prepare STK Push Payload
//         const payload = {
//             "BusinessShortCode": SHORTCODE,
//             "Password": password,
//             "Timestamp": timestamp,
//             "TransactionType": "CustomerPayBillOnline",
//             "Amount": amount,
//             "PartyA": phoneNumber, // Phone sending money
//             "PartyB": SHORTCODE,   // Shortcode receiving money
//             "PhoneNumber": phoneNumber,
//             "CallBackURL": "https://shopke-4b83a.cloudfunctions.net/mpesaCallback", // SEE NOTE BELOW
//             "AccountReference": orderId, // We use OrderID to match payment later
//             "TransactionDesc": "Payment of Fresh Farm Order"
//         };

//         // 5. Send Request to Safaricom
//         const response = await axios.post(DARAJA_STK_PUSH_URL, payload, {
//             headers: { Authorization: `Bearer ${token}` }
//         });

//         console.log("M-Pesa Response:", response.data);
        
//         // Return success to Flutter app
//         return { 
//             success: true, 
//             message: "STK Push sent to phone. Please enter PIN.",
//             responseCode: response.data.ResponseCode,
//             merchantRequestID: response.data.MerchantRequestID
//         };

//     } catch (error) {
//         console.error("STK Push Error:", error.response ? error.response.data : error.message);
//         throw new functions.https.HttpsError('internal', 'M-Pesa Request Failed');
//     }
// });

// // 4. CLOUD FUNCTION: HANDLE CALLBACK (Called by Safaricom)
// exports.mpesaCallback = functions.https.onRequest(async (req, res) => {
//     console.log("M-Pesa Callback received:", req.body);

//     try {
//         const body = req.body.Body.stkCallback;
//         const resultCode = body.ResultCode;
//         const orderId = body.AccountReference; // We passed this in the STK Push
//         const resultDesc = body.ResultDesc;

//         if (resultCode === 0) {
//             // SUCCESS: Payment Received
//             console.log(`Payment successful for Order: ${orderId}`);

//             // Update Firestore
//             await admin.firestore().collection('orders').doc(orderId).update({
//                 'status': 'Paid',
//                 'isPaid': true,
//                 'paymentResult': resultDesc,
//                 'updatedAt': admin.firestore.FieldValue.serverTimestamp()
//             });
//         } else {
//             // FAILED: User cancelled or insufficient funds
//             console.log(`Payment failed for Order: ${orderId} - ${resultDesc}`);

//             await admin.firestore().collection('orders').doc(orderId).update({
//                 'status': 'Payment Failed',
//                 'paymentResult': resultDesc,
//                 'updatedAt': admin.firestore.FieldValue.serverTimestamp()
//             });
//         }

//         // IMPORTANT: Always respond with 200 to Safaricom so they don't retry
//         res.status(200).json({ ResultCode: 0, ResultDesc: "Success" });

//     } catch (error) {
//         console.error("Callback Processing Error:", error);
//         res.status(500).send("Internal Server Error");
//     }
// });


// ✅ Load environment variables
require("dotenv").config();

const express = require("express");
const cors = require("cors");
const admin = require("firebase-admin");
const axios = require("axios");

// ✅ Initialize Firebase Admin using service account
const serviceAccount = require("./serviceAccountKey.json");

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
});

const db = admin.firestore();

const app = express();
app.use(cors({ origin: '*' }));
// app.use(cors({ 
//   origin: ['http://localhost:51513', 'http://localhost:5000'], 
//   credentials: true 
// }));
app.use(express.json());

/**
 * ✅ Health Check Endpoint
 */
app.get("/health", (req, res) => {
  res.json({ status: "healthy", timestamp: new Date().toISOString() });
});

/**
 * ✅ Helper: Get M-Pesa Access Token
 */
async function getAccessToken() {
  const consumerKey = process.env.MPESA_CONSUMER_KEY;
  const consumerSecret = process.env.MPESA_CONSUMER_SECRET;

  if (!consumerKey || !consumerSecret) {
    throw new Error("M-Pesa credentials missing in .env");
  }

  const auth = Buffer.from(`${consumerKey}:${consumerSecret}`).toString("base64");

  const response = await axios.get(
    "https://sandbox.safaricom.co.ke/oauth/v1/generate?grant_type=client_credentials",
    {
      headers: { Authorization: `Basic ${auth}` },
    }
  );

  return response.data.access_token;
}

/**
 * ✅ Initiate STK Push
 */
app.post("/initiate-stk-push", async (req, res) => {
  try {
    const { phone, amount, orderId } = req.body;

    if (!phone || !amount) {
      return res.status(400).json({
        error: "Phone number and amount are required",
      });
    }

    const accessToken = await getAccessToken();

    const shortcode = process.env.MPESA_SHORTCODE;
    const passkey = process.env.MPESA_PASSKEY;
    const callbackUrl = process.env.MPESA_CALLBACK_URL;

    if (!shortcode || !passkey || !callbackUrl) {
      throw new Error("Missing M-Pesa configuration in .env");
    }

    const timestamp = new Date()
      .toISOString()
      .replace(/[-:TZ.]/g, "")
      .slice(0, 14);

    const password = Buffer.from(shortcode + passkey + timestamp).toString("base64");

    const payload = {
      BusinessShortCode: shortcode,
      Password: password,
      Timestamp: timestamp,
      TransactionType: "CustomerPayBillOnline",
      Amount: amount,
      PartyA: phone,
      PartyB: shortcode,
      PhoneNumber: phone,
      CallBackURL: callbackUrl,
      AccountReference: orderId || "QuickRecovery",
      TransactionDesc: "Payment for goods",
    };

    const mpesaResponse = await axios.post(
      "https://sandbox.safaricom.co.ke/mpesa/stkpush/v1/processrequest",
      payload,
      {
        headers: {
          Authorization: `Bearer ${accessToken}`,
          "Content-Type": "application/json",
        },
      }
    );

    res.json(mpesaResponse.data);
  } catch (error) {
    console.error("STK Push Error:", error.message);

    res.status(500).json({
      error: "Failed to initiate STK Push",
      details: error.message,
    });
  }
});

/**
 * ✅ M-Pesa Callback
 */
app.post("/mpesa-callback", async (req, res) => {
  res.status(200).json({
    ResultCode: 0,
    ResultDesc: "Success",
  });

  try {
    const callback = req.body;

    if (callback.Body?.stkCallback) {
      const stkCallback = callback.Body.stkCallback;
      const resultCode = parseInt(stkCallback.ResultCode);
      const checkoutRequestId = stkCallback.CheckoutRequestID;

      let mpesaStatus = "failed";
      if (resultCode === 0) mpesaStatus = "paid";
      if (resultCode === 1031 || resultCode === 1032) mpesaStatus = "cancelled";

      const ordersQuery = await db
        .collection("orders")
        .where("checkoutRequestId", "==", checkoutRequestId)
        .limit(1)
        .get();

      if (!ordersQuery.empty) {
        const orderId = ordersQuery.docs[0].id;

        await db.collection("orders").doc(orderId).update({
          mpesaStatus,
          updatedAt: admin.firestore.FieldValue.serverTimestamp(),
        });

        console.log("Order updated:", orderId);
      }
    }
  } catch (error) {
    console.error("Callback processing error:", error);
  }
});

/**
 * ✅ Start Express Server (NO Firebase Functions)
 */
const PORT = 5000;

app.listen(PORT, () => {
  console.log(`🚀 Server running on http://localhost:${PORT}`);
});