const noblox = require('noblox.js');
const fs = require('fs');

const PLACE_ID = 104973076655377; // Place ID Capybaras VS Plants

async function run() {
    try {
        const cookie = process.env.ROBLOX_COOKIE;
        if (cookie) {
            await noblox.setCookie(cookie);
            console.log("Berhasil authentication dengan cookie Roblox.");
        } else {
            console.log("Menjalankan tracker tanpa cookie.");
        }

        // Ambil data detail game dari API Roblox
        const placeDetails = await noblox.getPlaceInfo(PLACE_ID);

        const stockData = {
            gameName: placeDetails.Name || "Capybaras VS Plants",
            status: "Online / Active",
            placeId: PLACE_ID,
            playing: placeDetails.Playing || 0,
            visits: placeDetails.Visits || 0,
            capybaraStock: "Mengecek NPC Capybara...",
            gearStock: "Mengecek NPC Gear...",
            updatedAt: new Date().toISOString()
        };

        fs.writeFileSync('stock.json', JSON.stringify(stockData, null, 2));
        console.log("File stock.json berhasil diperbarui!");
    } catch (err) {
        console.error("Gagal menjalankan tracker:", err);
        process.exit(1);
    }
}

run();
