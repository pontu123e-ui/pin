const noblox = require('noblox.js');
const fs = require('fs');

async function checkStock() {
    try {
        // Ambil ID game tujuan kamu (Ganti ID di bawah dengan Place ID game Roblox-nya)
        const placeId = 123456789; 
        const gameInfo = await noblox.getPlaceInfo(placeId);

        const stockData = {
            updatedAt: new Date().toISOString(),
            gameName: gameInfo.Name || "Game Roblox",
            status: "Online",
            // Kamu bisa tambah data stok custom di sini
        };

        fs.writeFileSync('stock.json', JSON.stringify(stockData, null, 2));
        console.log('Stok berhasil diupdate!');
    } catch (err) {
        console.error('Gagal update stok:', err);
    }
}

checkStock();
