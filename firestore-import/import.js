const admin = require('firebase-admin');
const fs = require('fs');

// Load Firebase service account
const serviceAccount = require('./serviceAccountKey.json');

// Initialize app
admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
});

// Load town data (should be an array of town objects)
const towns = require('./data.json');

const db = admin.firestore();

async function importData() {
  for (const town of towns) {
    const {
      name,
      tourist_spots = [],
      ...townDataWithoutSpots
    } = town;

    const townRef = db.collection('elyu').doc(name);

    // Save the town document
    await townRef.set(townDataWithoutSpots);
    console.log(`✅ Town imported: ${name}`);

    // Import tourist spots as a subcollection
    if (Array.isArray(tourist_spots) && tourist_spots.length > 0) {
      for (const spot of tourist_spots) {
        const spotRef = townRef.collection('tourist_spots').doc(spot.name);
        await spotRef.set(spot);
        console.log(`  🗺️ Tourist Spot added: ${spot.name}`);
      }
    } else {
      console.log(`  ⚠️ No tourist spots for ${name}`);
    }
  }

  console.log('✅ All data imported successfully!');
}

importData().catch((err) => {
  console.error('❌ Import failed:', err);
});
