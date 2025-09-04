# Backend Services and APIs

## Overview

The D3LTA Flutter web app requires several backend services to function properly. This document outlines the necessary services and implementation options.

## Required Backend Services

### 1. Form Submission Service
- Handle contact form submissions
- Store order information
- Send confirmation emails

### 2. Seller Keyword Validation Service
- Validate seller discount codes
- Manage discount code database

### 3. QR Code Generation and Storage Service
- Generate QR codes based on user input
- Store generated QR codes
- Provide download links

### 4. Payment Processing Integration
- Handle payment processing
- Manage transaction records

## Implementation Options

### Option 1: Firebase (Recommended for MVP)
- Firebase Firestore for database
- Firebase Functions for serverless functions
- Firebase Authentication for user management
- Firebase Hosting for static assets

### Option 2: Supabase
- PostgreSQL database
- Supabase Functions for serverless functions
- Supabase Auth for authentication
- Supabase Storage for file storage

### Option 3: Custom Node.js/Express API
- Node.js/Express backend
- PostgreSQL or MongoDB database
- Deployed on Vercel, Render, or similar platform

## Recommended Approach: Firebase

For a quick MVP, Firebase is recommended due to its ease of use and free tier.

### Firebase Services Needed:
1. Firestore Database - Store order information and seller keywords
2. Firebase Functions - Handle form submissions, QR code generation
3. Firebase Authentication - Optional, for admin dashboard
4. Firebase Storage - Store generated QR codes

### Setup Steps:
1. Create Firebase project
2. Enable Firestore Database
3. Enable Firebase Functions
4. Enable Firebase Storage
5. Configure Firebase SDK in Flutter app
6. Deploy Firebase Functions

## Firebase Functions Implementation

### Form Submission Function
```javascript
const functions = require('firebase-functions');
const admin = require('firebase-admin');

admin.initializeApp();

exports.handleOrderSubmission = functions.https.onRequest(async (req, res) => {
  try {
    const orderData = req.body;
    
    // Store order in Firestore
    await admin.firestore().collection('orders').add({
      ...orderData,
      createdAt: admin.firestore.FieldValue.serverTimestamp()
    });
    
    // Send confirmation email (using nodemailer or similar)
    // Send notification to business email
    
    res.status(200).send({ success: true, message: 'Order submitted successfully' });
  } catch (error) {
    console.error('Error handling order submission:', error);
    res.status(500).send({ success: false, message: 'Error submitting order' });
  }
});
```

### Seller Keyword Validation Function
```javascript
exports.validateSellerKeyword = functions.https.onRequest(async (req, res) => {
  try {
    const { keyword } = req.query;
    
    const snapshot = await admin.firestore()
      .collection('sellerKeywords')
      .where('keyword', '==', keyword.toLowerCase())
      .limit(1)
      .get();
    
    const isValid = !snapshot.empty;
    
    res.status(200).send({ valid: isValid });
  } catch (error) {
    console.error('Error validating seller keyword:', error);
    res.status(500).send({ valid: false, error: 'Validation error' });
  }
});
```

### QR Code Generation Function
```javascript
const QRCode = require('qrcode');

exports.generateQRCode = functions.https.onRequest(async (req, res) => {
  try {
    const { data } = req.body;
    
    // Generate QR code
    const qrCodeDataUrl = await QRCode.toDataURL(data);
    
    // Store in Firebase Storage
    const bucket = admin.storage().bucket();
    const fileName = `qrcodes/${Date.now()}.png`;
    const file = bucket.file(fileName);
    
    // Convert data URL to buffer
    const base64Data = qrCodeDataUrl.replace(/^data:image\/png;base64,/, "");
    const buffer = Buffer.from(base64Data, 'base64');
    
    await file.save(buffer, {
      metadata: { contentType: 'image/png' }
    });
    
    // Get download URL
    const downloadURL = await file.getSignedUrl({
      action: 'read',
      expires: '03-01-2500'
    });
    
    res.status(200).send({ 
      success: true, 
      qrCodeUrl: downloadURL[0],
      fileName: fileName
    });
  } catch (error) {
    console.error('Error generating QR code:', error);
    res.status(500).send({ success: false, message: 'Error generating QR code' });
  }
});
```

## Security Considerations

1. Implement proper CORS headers
2. Use Firebase Security Rules for Firestore
3. Validate all input data
4. Implement rate limiting
5. Use HTTPS for all communications

## Deployment

1. Deploy Firebase Functions using `firebase deploy`
2. Update Flutter app with Firebase configuration
3. Test all backend integrations

## Cost Considerations

Firebase free tier includes:
- 1GB storage
- 10GB bandwidth
- 50,000 reads/day
- 20,000 writes/day
- 50,000 deletes/day

For higher usage, consider the Blaze plan which charges per usage.