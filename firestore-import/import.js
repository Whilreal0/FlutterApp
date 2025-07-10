const admin = require("firebase-admin");
const serviceAccount = require("./serviceAccountKey.json");

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount)
});

const db = admin.firestore();

const spots = [
  {
    "name": "Bangui Windmills",
    "description": "Iconic wind turbines by the sea.",
    "province": "Ilocos Norte",
    "lat": 18.5408,
    "lng": 120.6514,
    "region": "Region 1",
    "photos": ["https://via.placeholder.com/150"]
  },
  {
    "name": "Kapurpurawan Rock Formation",
    "description": "White limestone rock formations shaped by sea and wind.",
    "province": "Ilocos Norte",
    "lat": 18.4907,
    "lng": 120.6148,
    "region": "Region 1",
    "photos": ["https://via.placeholder.com/150"]
  },
  {
    "name": "Paoay Church",
    "description": "UNESCO World Heritage Baroque-style church.",
    "province": "Ilocos Norte",
    "lat": 18.0614,
    "lng": 120.5214,
    "region": "Region 1",
    "photos": ["https://via.placeholder.com/150"]
  },
  {
    "name": "Cape Bojeador Lighthouse",
    "description": "Historic lighthouse offering panoramic sea views.",
    "province": "Ilocos Norte",
    "lat": 18.5039,
    "lng": 120.6207,
    "region": "Region 1",
    "photos": ["https://via.placeholder.com/150"]
  },
  {
    "name": "Patapat Viaduct",
    "description": "Coastal highway bridge with dramatic views.",
    "province": "Ilocos Norte",
    "lat": 18.5592,
    "lng": 120.8960,
    "region": "Region 1",
    "photos": ["https://via.placeholder.com/150"]
  },
  {
    "name": "La Paz Sand Dunes",
    "description": "Epic 4x4 and sandboarding destination.",
    "province": "Ilocos Norte",
    "lat": 18.2010,
    "lng": 120.4950,
    "region": "Region 1",
    "photos": ["https://via.placeholder.com/150"]
  },
  {
    "name": "Pagudpud Beach (Saud Beach)",
    "description": "White-sand paradise known as the 'Boracay of the North'.",
    "province": "Ilocos Norte",
    "lat": 18.7350,
    "lng": 120.5270,
    "region": "Region 1",
    "photos": ["https://via.placeholder.com/150"]
  },
  {
    "name": "Kabigan Falls",
    "description": "Series of scenic waterfalls in Pagudpud.",
    "province": "Ilocos Norte",
    "lat": 18.7344,
    "lng": 120.5881,
    "region": "Region 1",
    "photos": ["https://via.placeholder.com/150"]
  },
  {
    "name": "Calle Crisologo",
    "description": "Historic cobblestone street in UNESCO Vigan.",
    "province": "Ilocos Sur",
    "lat": 17.5747,
    "lng": 120.3860,
    "region": "Region 1",
    "photos": ["https://via.placeholder.com/150"]
  },
  {
    "name": "Vigan Cathedral",
    "description": "Earthquake Baroque cathedral near Plaza Salcedo.",
    "province": "Ilocos Sur",
    "lat": 17.5738,
    "lng": 120.3863,
    "region": "Region 1",
    "photos": ["https://via.placeholder.com/150"]
  },
  {
    "name": "Bantay Bell Tower",
    "description": "Hilltop bell tower with panoramic city views.",
    "province": "Ilocos Sur",
    "lat": 17.5698,
    "lng": 120.3845,
    "region": "Region 1",
    "photos": ["https://via.placeholder.com/150"]
  },
  {
    "name": "Baluarte Zoo",
    "description": "Safari-style mini-zoo owned by Chavit Singson.",
    "province": "Ilocos Sur",
    "lat": 17.5477,
    "lng": 120.3876,
    "region": "Region 1",
    "photos": ["https://via.placeholder.com/150"]
  },
  {
    "name": "National Museum Ilocos Regional Complex",
    "description": "Regional museum showcasing Ilocano heritage.",
    "province": "Ilocos Sur",
    "lat": 17.5720,
    "lng": 120.3860,
    "region": "Region 1",
    "photos": ["https://via.placeholder.com/150"]
  },
  {
    "name": "Ma-Cho Temple",
    "description": "Taoist temple overlooking San Fernando Bay.",
    "province": "La Union",
    "lat": 16.6177,
    "lng": 120.3182,
    "region": "Region 1",
    "photos": ["https://via.placeholder.com/150"]
  },
  {
    "name": "San Juan Surf Beach",
    "description": "Popular surfing destination and relaxed town vibe.",
    "province": "La Union",
    "lat": 16.6111,
    "lng": 120.3294,
    "region": "Region 1",
    "photos": ["https://via.placeholder.com/150"]
  },
  {
    "name": "Tangadan Falls",
    "description": "Scenic double-drop waterfall near San Juan.",
    "province": "La Union",
    "lat": 16.6902,
    "lng": 120.4177,
    "region": "Region 1",
    "photos": ["https://via.placeholder.com/150"]
  },
  {
    "name": "Hundred Islands National Park",
    "description": "Group of 124+ limestone islands for island-hopping.",
    "province": "Pangasinan",
    "lat": 16.1686,
    "lng": 120.0097,
    "region": "Region 1",
    "photos": ["https://via.placeholder.com/150"]
  },
  {
    "name": "Patar Beach",
    "description": "Golden sand beach in Bolinao with stunning sunsets.",
    "province": "Pangasinan",
    "lat": 16.3460,
    "lng": 119.7860,
    "region": "Region 1",
    "photos": ["https://via.placeholder.com/150"]
  },
  {
    "name": "Cape Bolinao Lighthouse",
    "description": "Historic lighthouse with coastal views in Bolinao.",
    "province": "Pangasinan",
    "lat": 16.4339,
    "lng": 119.8450,
    "region": "Region 1",
    "photos": ["https://via.placeholder.com/150"]
  },
  {
    "name": "Bolinao Falls (1,2,3)",
    "description": "Multi-tier waterfalls in Bolinao area.",
    "province": "Pangasinan",
    "lat": 16.3865,
    "lng": 119.7710,
    "region": "Region 1",
    "photos": ["https://via.placeholder.com/150"]
  },
  {
    "name": "Lingayen Beach",
    "description": "Historical beach where MacArthur landed.",
    "province": "Pangasinan",
    "lat": 16.0250,
    "lng": 120.1900,
    "region": "Region 1",
    "photos": ["https://via.placeholder.com/150"]
  },
  {
    "name": "Balungao Hilltop Adventure Park",
    "description": "Zipline and hot springs at foot of Mount Balungao.",
    "province": "Pangasinan",
    "lat": 15.9490,
    "lng": 120.4900,
    "region": "Region 1",
    "photos": ["https://via.placeholder.com/150"]
  },
  {
    "name": "Manleluag Spring Protected Landscape",
    "description": "Hot springs and protected landscape in Pangasinan.",
    "province": "Pangasinan",
    "lat": 15.8920,
    "lng": 120.3830,
    "region": "Region 1",
    "photos": ["https://via.placeholder.com/150"]
  },
  {
    "name": "Santiago Island",
    "description": "Snorkeling spot off Bolinao with marine protected area.",
    "province": "Pangasinan",
    "lat": 16.3480,
    "lng": 119.7800,
    "region": "Region 1",
    "photos": ["https://via.placeholder.com/150"]
  },
  {
    "name": "Paoay Lake",
    "description": "Freshwater lake and protected landscape near Paoay.",
    "province": "Ilocos Norte",
    "lat": 18.0380,
    "lng": 120.5210,
    "region": "Region 1",
    "photos": ["https://via.placeholder.com/150"]
  }
]


async function importData() {
  const batch = db.batch();
  const spotsRef = db.collection("spots");

  spots.forEach((spot) => {
    const docRef = spotsRef.doc(); // Auto-ID
    batch.set(docRef, spot);
  });

  await batch.commit();
  console.log("✅ Successfully imported tourist spots to Firestore.");
}

importData().catch(console.error);
