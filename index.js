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

    try {
        // Menggunakan API bypass alternatif
        const response = await fetch(`https://bypass.city/api/bypass?url=${encodeURIComponent(targetUrl)}`);
        const data = await response.json();

        if (data.result || data.destination) {
            res.json({ success: true, key: data.result || data.destination });
        } else {
            res.status(500).json({ success: false, message: data.message || 'Gagal me-bypass link.' });
        }
    } catch (err) {
        res.status(500).json({ success: false, message: 'Terjadi kesalahan pada server API.' });
    }
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => console.log(`Server running on port ${PORT}`));
