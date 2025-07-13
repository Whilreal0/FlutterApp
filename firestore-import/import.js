const admin = require('firebase-admin');
const fs = require('fs');

const serviceAccount = require('./serviceAccountKey.json');
admin.initializeApp({ credential: admin.credential.cert(serviceAccount) });

const towns = require('./data.json');
const db = admin.firestore();

// 🔥 Deletes all towns and their subcollections
async function deleteAllElyuData() {
  const townsSnapshot = await db.collection('elyu').get();

  for (const townDoc of townsSnapshot.docs) {
    const townRef = townDoc.ref;

    // Delete subcollection: tourist_spots
    const spotsSnapshot = await townRef.collection('tourist_spots').get();
    for (const spot of spotsSnapshot.docs) {
      await spot.ref.delete();
    }

    // Delete town document
    await townRef.delete();
    console.log(`🗑️ Deleted: ${townRef.id}`);
  }

  console.log('✅ All existing elyu data deleted.');
}

// 🆕 Import fresh data
async function importData() {
  for (const town of towns) {
    const { name, tourist_spots = [], ...townFields } = town;
    const townRef = db.collection('elyu').doc(name);

    await townRef.set(townFields);
    console.log(`✅ Imported town: ${name}`);

    for (const spot of tourist_spots) {
      const spotRef = townRef.collection('tourist_spots').doc(spot.name);
      await spotRef.set(spot);
      console.log(`  🗺️ Added spot: ${spot.name}`);
    }
  }

  console.log('✅ All data imported successfully!');
}

// 🚀 Run both steps
async function runFullReplace() {
  await deleteAllElyuData();
  await importData();
}

runFullReplace().catch((err) => {
  console.error('❌ Import failed:', err);
});
