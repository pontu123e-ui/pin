const express = require('express');
const cors = require('cors');
const fetch = require('node-fetch');

const app = express();
app.use(cors());
app.use(express.json());

app.get('/', (req, res) => {
    res.sendFile(__dirname + '/b.html');
});

app.get('/api/bypass', async (req, res) => {
    const targetUrl = req.query.url;
    if (!targetUrl) return res.status(400).json({ error: 'URL tidak boleh kosong' });

    const encodedUrl = encodeURIComponent(targetUrl);

    // Daftar provider API bypass gratis yang akan dicoba berurutan
    const apiEndpoints = [
        `https://api.bypasser.su/api/bypass?url=${encodedUrl}`,
        `https://bypass.city/api/bypass?url=${encodedUrl}`,
        `https://api.bypass.vip/bypass?url=${encodedUrl}`
    ];

    for (const endpoint of apiEndpoints) {
        try {
            const response = await fetch(endpoint, { timeout: 5000 });
            if (!response.ok) continue;

            const data = await response.json();
            const resultKey = data.result || data.destination || data.result_url || data.key;

            if (resultKey && !resultKey.includes('FREE API SHUT DOWN')) {
                return res.json({ success: true, key: resultKey });
            }
        } catch (e) {
            // Jika API gagal/down, lanjut mencoba API berikutnya di daftar
            continue;
        }
    }

    // Jika semua API di atas gagal
    res.status(500).json({ 
        success: false, 
        message: 'Semua provider API bypass publik sedang down/di-block. Coba lagi nanti.' 
    });
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => console.log(`Server running on port ${PORT}`));
