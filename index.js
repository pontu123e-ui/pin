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
        // Menggunakan endpoint API bypass alternatif
        const response = await fetch(`https://api.ethon.ai/bypass?url=${encodeURIComponent(targetUrl)}`);
        
        if (!response.ok) {
            throw new Error(`HTTP Error Status: ${response.status}`);
        }

        const data = await response.json();

        if (data.result || data.destination || data.result_url) {
            res.json({ 
                success: true, 
                key: data.result || data.destination || data.result_url 
            });
        } else {
            res.status(500).json({ 
                success: false, 
                message: data.message || 'API gagal mengekstrak link/key.' 
            });
        }
    } catch (err) {
        res.status(500).json({ 
            success: false, 
            message: 'Penyedia API sedang down atau memblokir request.' 
        });
    }
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => console.log(`Server running on port ${PORT}`));
